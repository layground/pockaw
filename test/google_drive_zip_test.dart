import 'dart:io';
import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:pockaw/core/utils/logger.dart';
import 'package:test/test.dart';

void main() {
  test(
    'zip contains data.json and images and extraction preserves files',
    () async {
      final tempDir = await Directory.systemTemp.createTemp('pockaw_test_zip');
      final contentDir = Directory(p.join(tempDir.path, 'content'));
      await contentDir.create(recursive: true);

      final dataFile = File(p.join(contentDir.path, 'data.json'));
      final sample = {
        'users': [
          {'id': 1, 'profilePicture': 'images/pic.png'},
        ],
        'transactions': [],
      };
      await dataFile.writeAsString(json.encode(sample));

      final imagesDir = Directory(p.join(contentDir.path, 'images'));
      await imagesDir.create(recursive: true);
      final imageFile = File(p.join(imagesDir.path, 'pic.png'));
      await imageFile.writeAsBytes(List.generate(16, (i) => i));

      final zipPath = p.join(tempDir.path, 'test_backup.zip');

      // Build archive explicitly to avoid platform-specific ZipFileEncoder issues
      final archiveBuilder = Archive();
      for (final entity in contentDir.listSync(recursive: true)) {
        if (entity is File) {
          final rel = p.relative(entity.path, from: contentDir.path);
          final bytes = await entity.readAsBytes();
          archiveBuilder.addFile(
            ArchiveFile(rel.replaceAll('\\', '/'), bytes.length, bytes),
          );
        }
      }

      final zipBytes = ZipEncoder().encode(archiveBuilder);
      await File(zipPath).writeAsBytes(zipBytes);

      final bytes = await File(zipPath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      Log.d('Archive length: ${archive.length}');
      Log.d('Archive isEmpty: ${archive.isEmpty}');

      final names = archive.where((e) => e.isFile).map((e) => e.name).toList();
      // Normalize separators to / to make assertions platform independent
      final normalized = names.map((n) => n.replaceAll('\\', '/')).toList();
      Log.d('ZIP entries:');
      for (final n in normalized) {
        Log.d(' - $n');
      }
      expect(
        normalized.any((n) => n == 'data.json' || n.endsWith('/data.json')),
        isTrue,
      );
      expect(
        normalized.any(
          (n) => n.endsWith('/images/pic.png') || n == 'images/pic.png',
        ),
        isTrue,
      );

      // Extract and verify copied file
      final extractDir = await Directory.systemTemp.createTemp(
        'pockaw_test_extract',
      );
      for (final file in archive) {
        if (file.isFile) {
          final outFile = File(p.join(extractDir.path, file.name));
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content as List<int>);
        }
      }

      // Find the extracted data.json by searching for basename
      File? extractedDataFile;
      for (final f in Directory(extractDir.path).listSync(recursive: true)) {
        if (p.basename(f.path) == 'data.json') {
          extractedDataFile = File(f.path);
          break;
        }
      }
      expect(extractedDataFile, isNotNull);
      final extractedData =
          json.decode(await extractedDataFile!.readAsString())
              as Map<String, dynamic>;
      expect(extractedData['users'][0]['profilePicture'], 'images/pic.png');

      final extractedImage = File(p.join(extractDir.path, 'images', 'pic.png'));
      expect(await extractedImage.exists(), isTrue);

      await tempDir.delete(recursive: true);
      await extractDir.delete(recursive: true);
    },
  );
}
