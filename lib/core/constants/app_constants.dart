class AppConstants {
  AppConstants._();

  static const String appName = 'CareSync';

  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  static const String supabaseUrl = 'https://figtlufcjamukntnzlws.supabase.co';
  static const String supabaseAnonKey =
      'sb_publishable_gZufayX9xWuWW9NFntIZgw_VjdZ8srm';
  static const String supabaseUrlPlaceholder = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKeyPlaceholder = 'YOUR_SUPABASE_ANON_KEY';

  static const String appBoxName = 'care_sync_box';
  static const String keyUserToken = 'user_token';
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
}
