class AppConstants {
  AppConstants._();

  static const String appName = 'CareSync';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  static const String appBoxName = 'care_sync_box';
  static const String keyUserToken = 'user_token';
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
}
