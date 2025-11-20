import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pockaw/core/utils/logger.dart';

/// Riverpod-powered Google auth controller.
///
/// Replaces the previous stream-based API with a Notifier provider that
/// exposes the current [GoogleSignInAccount?] as state and provides
/// imperative methods for sign-in, sign-out and Drive scope management.
class GoogleAuthNotifier extends Notifier<GoogleSignInAccount?> {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Private subscription to the SDK authentication events.
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSub;

  // Private scope for Drive access. Use full Drive scope so the service can
  // create files/folders in the user's My Drive. Previously this used the
  // AppData scope which only permits access to the hidden appDataFolder and
  // caused permission errors when calling My Drive endpoints.
  static const List<String> _driveScopes = [drive.DriveApi.driveScope];

  @override
  GoogleSignInAccount? build() {
    // Initial state is null. We set up listeners and attempt lightweight
    // authentication to restore any existing session.
    _initialize();
    return null;
  }

  Future<void> _initialize() async {
    try {
      // Ensure the GoogleSignIn SDK is initialized with the Android server
      // client id so Drive scopes and permission grants work correctly on
      // Android. The client id is defined in the compatibility facade below.
      await _googleSignIn.initialize();

      // Listen to auth events and update the provider state accordingly.
      _authSub = _googleSignIn.authenticationEvents.listen(
        _handleAuthenticationEvent,
        onError: _handleAuthenticationError,
      );
    } catch (e, st) {
      Log.e('GoogleSignIn initialize failed: $e\n$st', label: 'Auth Error');
    }

    // Ensure we clean up when the provider is disposed
    ref.onDispose(() {
      _authSub?.cancel();
    });
  }

  void _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    Log.i('Auth event: ${user?.email ?? 'Signed out'}', label: 'Auth');
    state = user;
  }

  void _handleAuthenticationError(Object e, StackTrace st) {
    String errorMessage = 'Unknown error: $e';
    if (e is GoogleSignInException) {
      errorMessage = 'GoogleSignInException ${e.code}: ${e.description}';
    }
    Log.e('$errorMessage\n$st', label: 'Auth Error');
    state = null;
  }

  /// Triggers the Google Sign-In UI.
  Future<void> signIn({
    Function(GoogleSignInAccount?)? onSuccess,
    Function? onError,
    Function? onCanceled,
  }) async {
    try {
      // Make sure the instance is initialized with the client ID too.
      await _googleSignIn.initialize();
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        state = await GoogleSignIn.instance.authenticate();
        if (state != null) {
          onSuccess?.call(state);
        } else {
          onCanceled?.call();
        }
      } else {
        onError?.call();
      }
    } catch (e, st) {
      String errorMessage = 'signIn failed: $e';
      if (e is GoogleSignInException) {
        errorMessage = 'GoogleSignInException ${e.code}: ${e.description}';
      }
      Log.e('$errorMessage\n$st', label: 'Auth Error');
      // Ensure state is cleared if auth fails
      if (state != null) {
        state = null;
      }
    }
  }

  /// Signs the user out.
  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect(); // Disconnect to reset state
    } catch (e, st) {
      Log.e('Google Sign-Out failed: $e\n$st', label: 'Auth Error');
    }
  }

  /// Checks if the current user has authorized Drive scopes.
  Future<bool> hasDriveAccess() async {
    if (state == null) return false;
    final auth = await state!.authorizationClient.authorizationForScopes(
      _driveScopes,
    );
    return auth != null;
  }

  /// Requests permission for the Google Drive AppData scope.
  /// Must be called from a user interaction (like a button press).
  Future<bool> requestDriveAccess() async {
    if (state == null) {
      Log.e('No user signed in to request scopes.', label: 'Auth');
      return false;
    }
    try {
      await state!.authorizationClient.authorizeScopes(_driveScopes);
      // If no exception was thrown we consider the request successful.
      Log.i('Drive scope request result: true', label: 'Auth');
      return true;
    } catch (e, st) {
      String errorMessage = 'requestDriveAccess failed: $e';
      if (e is GoogleSignInException) {
        errorMessage = 'GoogleSignInException ${e.code}: ${e.description}';
      }
      Log.e('$errorMessage\n$st', label: 'Auth Error');
      return false;
    }
  }

  /// Gets the authorization headers for making Drive API calls.
  Future<Map<String, String>?> getAuthHeaders() async {
    if (state == null) {
      Log.e('No user to get auth headers.', label: 'Auth');
      return null;
    }
    try {
      final headers = await state!.authorizationClient.authorizationHeaders(
        _driveScopes,
      );
      if (headers == null) {
        Log.e(
          'Failed to construct authorization headers.',
          label: 'Auth Error',
        );
        return null;
      }
      return headers;
    } catch (e, st) {
      Log.e('getAuthHeaders failed: $e\n$st', label: 'Auth Error');
      return null;
    }
  }
}

final googleAuthProvider =
    NotifierProvider<GoogleAuthNotifier, GoogleSignInAccount?>(
      GoogleAuthNotifier.new,
    );

/// Compatibility facade for existing code that expects a plain
/// `GoogleAuthService` class. This delegates to the GoogleSignIn SDK
/// directly and provides the same async helpers as the notifier.
class GoogleAuthService {
  // Drive scope kept in sync with the notifier above
  static const List<String> _driveScopes = [drive.DriveApi.driveScope];

  Future<GoogleSignInAccount> signIn() async {
    await GoogleSignIn.instance.initialize();
    return GoogleSignIn.instance.authenticate();
  }

  Future<void> signOut() => GoogleSignIn.instance.disconnect();

  Future<bool> hasDriveAccess() async {
    await GoogleSignIn.instance.initialize();
    final user = await GoogleSignIn.instance.attemptLightweightAuthentication();
    if (user == null) return false;
    final auth = await user.authorizationClient.authorizationForScopes(
      _driveScopes,
    );
    return auth != null;
  }

  Future<bool> requestDriveAccess() async {
    final user = await GoogleSignIn.instance.attemptLightweightAuthentication();
    if (user == null) {
      Log.e('No user signed in to request scopes.', label: 'Auth');
      return false;
    }
    try {
      await user.authorizationClient.authorizeScopes(_driveScopes);
      Log.i('Drive scope request result: true', label: 'Auth');
      return true;
    } catch (e, st) {
      String errorMessage = 'requestDriveAccess failed: $e';
      if (e is GoogleSignInException) {
        errorMessage = 'GoogleSignInException ${e.code}: ${e.description}';
      }
      Log.e('$errorMessage\n$st', label: 'Auth Error');
      return false;
    }
  }

  Future<Map<String, String>?> getAuthHeaders() async {
    final user = await GoogleSignIn.instance.attemptLightweightAuthentication();
    if (user == null) {
      Log.e('No user to get auth headers.', label: 'Auth');
      return null;
    }
    try {
      final headers = await user.authorizationClient.authorizationHeaders(
        _driveScopes,
      );
      if (headers == null) {
        Log.e(
          'Failed to construct authorization headers.',
          label: 'Auth Error',
        );
        return null;
      }
      return headers;
    } catch (e, st) {
      Log.e('getAuthHeaders failed: $e\n$st', label: 'Auth Error');
      return null;
    }
  }
}
