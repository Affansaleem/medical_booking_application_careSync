import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() => _instance;

  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    const url = AppConstants.supabaseUrl;
    const anonKey = AppConstants.supabaseAnonKey;

    if (url == AppConstants.supabaseUrlPlaceholder ||
        anonKey == AppConstants.supabaseAnonKeyPlaceholder) {
      debugPrint(
        'WARNING: Supabase URL and Anon Key are set to default placeholders. '
        'Please update lib/core/constants/app_constants.dart with your actual credentials.',
      );
      return;
    }

    try {
      await Supabase.initialize(url: url, publishableKey: anonKey);
      debugPrint('Supabase initialized successfully.');
    } catch (e) {
      debugPrint('ERROR: Failed to initialize Supabase: $e');
      rethrow;
    }
  }
}
