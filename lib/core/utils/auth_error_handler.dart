class AuthErrorHandler {
  static String getMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Please login instead.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'requires-recent-login':
        return 'Please log in again to continue.';
      case 'credential-already-in-use':
        return 'This account is already linked with another user.';
      case 'sign_in_canceled':
      case 'canceled':
      case 'aborted-by-user':
        return 'Sign in cancelled.';
      default:
        if (errorCode.contains('canceled')) return 'Sign in cancelled.';
        // Log the unknown error code for debugging purposes
        // debugPrint('Unknown Auth Error Code: $errorCode');
        return 'Authentication failed: $errorCode';
    }
  }
}
