import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../utils/helpers.dart';

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
      await Supabase.initialize(
        url: url,
        publishableKey: anonKey,
        httpClient: LoggingHttpClient(http.Client()),
      );
      debugPrint('Supabase initialized successfully.');
    } catch (e) {
      debugPrint('ERROR: Failed to initialize Supabase: $e');
      rethrow;
    }
  }
}

class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;

  LoggingHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final startTime = DateTime.now();
    final requestId = request.hashCode.toString();

    AppHelpers.log(
      '\x1B[34m🚀 [API Request] ID: $requestId | ${request.method} | ${request.url}\x1B[0m\n'
      '\x1B[36mHeaders: ${request.headers}\x1B[0m',
      name: 'SupabaseAPI',
    );

    try {
      final response = await _inner.send(request);
      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (response.statusCode >= 400) {
        final bytes = await response.stream.toBytes();
        final bodyString = utf8.decode(bytes, allowMalformed: true);

        AppHelpers.log(
          '\x1B[31m❌ [API Error Response] ID: $requestId | Status: ${response.statusCode} | Duration: ${duration}ms\x1B[0m\n'
          '\x1B[33mHeaders: ${response.headers}\x1B[0m\n'
          '\x1B[31;1mBody: $bodyString\x1B[0m',
          name: 'SupabaseAPI',
        );

        return http.StreamedResponse(
          Stream.value(bytes),
          response.statusCode,
          contentLength: response.contentLength,
          request: response.request,
          headers: response.headers,
          isRedirect: response.isRedirect,
          persistentConnection: response.persistentConnection,
          reasonPhrase: response.reasonPhrase,
        );
      } else {
        AppHelpers.log(
          '\x1B[32m✅ [API Response] ID: $requestId | Status: ${response.statusCode} | Duration: ${duration}ms\x1B[0m\n'
          '\x1B[36mHeaders: ${response.headers}\x1B[0m',
          name: 'SupabaseAPI',
        );
        return response;
      }
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      AppHelpers.log(
        '\x1B[31;1m🔥 [API Exception] ID: $requestId | Error: $e | Duration: ${duration}ms\x1B[0m',
        name: 'SupabaseAPI',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
