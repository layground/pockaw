import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pockaw/core/services/google/google_auth_service.dart';
import 'package:pockaw/core/utils/logger.dart';

class DriveFileSummary {
  final String id;
  final String name;
  final DateTime? modifiedTime;
  final int size;
  DriveFileSummary(this.id, this.name, this.modifiedTime, this.size);
}

class GoogleDriveService {
  final GoogleAuthService _authService;

  static const String _driveApiBase = 'https://www.googleapis.com/drive/v3';
  static const String _uploadApiBase =
      'https://www.googleapis.com/upload/drive/v3';

  GoogleDriveService(this._authService);

  Future<Map<String, String>?> _headers() => _authService.getAuthHeaders();

  // Search "My Drive" for Pockaw backups
  Future<List<DriveFileSummary>> searchBackups() async {
    final headers = await _headers();
    if (headers == null) throw Exception('Not authenticated');

    try {
      final q = Uri.encodeQueryComponent(
        "mimeType = 'application/zip' and name contains 'Pockaw_Backup_' and trashed = false",
      );

      final url = Uri.parse(
        '$_driveApiBase/files?spaces=drive&q=$q&fields=files(id,name,modifiedTime,size)&orderBy=modifiedTime desc',
      );

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final files = (data['files'] as List)
            .map(
              (f) => DriveFileSummary(
                f['id'],
                f['name'],
                DateTime.tryParse(f['modifiedTime'] ?? ''),
                f['size'] != null ? int.parse(f['size']) : 0,
              ),
            )
            .toList();
        Log.i('Found ${files.length} backups.', label: 'Drive');
        return files;
      } else {
        throw Exception('Drive search failed: ${response.body}');
      }
    } catch (e, st) {
      Log.e('Search error: $e\n$st', label: 'Drive Error');
      return [];
    }
  }

  /// Returns last backup zip file on Google Drive
  Future<DriveFileSummary?> getLatestBackup() async {
    final backups = await searchBackups();
    if (backups.isNotEmpty) {
      return backups.first;
    }
    return null;
  }

  // Download a specific backup file
  Future<File?> downloadBackup(String fileId) async {
    final headers = await _headers();
    if (headers == null) return null;

    try {
      final url = Uri.parse('$_driveApiBase/files/$fileId?alt=media');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final file = File(p.join(tempDir.path, 'drive_restore_$fileId.zip'));
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Download failed: ${response.body}');
      }
    } catch (e, st) {
      Log.e('Download error: $e\n$st', label: 'Drive Error');
      return null;
    }
  }

  // Upload a NEW backup file to root of "My Drive"
  Future<void> uploadBackup(File localFile) async {
    final headers = await _headers();
    if (headers == null) return;

    try {
      final filename = p.basename(localFile.path);
      final size = await localFile.length();

      // 1. Init Resumable Upload
      final initUrl = Uri.parse('$_uploadApiBase/files?uploadType=resumable');
      final initHeaders = {
        ...headers,
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final body = jsonEncode({
        'name': filename,
        'mimeType': 'application/zip',
      });

      final initRes = await http.post(
        initUrl,
        headers: initHeaders,
        body: body,
      );
      if (initRes.statusCode != 200) throw Exception('Init upload failed');

      final uploadUrl = initRes.headers['location']!;

      // 2. Upload Content using StreamedRequest
      // FIX: Use StreamedRequest instead of simple put with file stream body
      final request = http.StreamedRequest('PUT', Uri.parse(uploadUrl));
      request.headers['Content-Length'] = size.toString();
      // No need for Authorization header here as the uploadUrl is unique and authenticated

      // Pipe file stream to request
      final fileStream = localFile.openRead();
      fileStream.listen(
        (chunk) => request.sink.add(chunk),
        onDone: () => request.sink.close(),
        onError: (e) {
          request.sink.addError(e);
          request.sink.close();
        },
        cancelOnError: true,
      );

      final uploadRes = await request.send();

      if (uploadRes.statusCode == 200 || uploadRes.statusCode == 201) {
        Log.i('Upload successful: $filename', label: 'Drive');
      } else {
        // Read response for error details
        final respBody = await uploadRes.stream.bytesToString();
        throw Exception(
          'Upload bytes failed: ${uploadRes.statusCode} - $respBody',
        );
      }
    } catch (e, st) {
      Log.e('Upload error: $e\n$st', label: 'Drive Error');
      rethrow;
    }
  }
}
