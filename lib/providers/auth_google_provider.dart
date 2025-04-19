import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_google_service.dart';

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});
