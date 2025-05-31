// Current Time: 2025-05-31 05:56:27
// Current User: EuniceNzilani

class ApiConfig {
  // Supabase Configuration
  static const String baseUrl =
      'https://kqgbftwsodpttpqgqnbh.supabase.co/rest/v1';
  static const String apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtxZ2JmdHdzb2RwdHRwcWdxbmJoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU5ODk5OTksImV4cCI6MjA2MTU2NTk5OX0.rwJSY4bJaNdB8jDn3YJJu_gKtznzm-dUKQb4OvRtP6c';

  // Headers
  static Map<String, String> get headers => {
    'apikey': apiKey,
    'Content-Type': 'application/json',
  };

  // API Endpoints
  static const String visits = '/visits';
  static const String customers = '/customers';
  static const String activities = '/activities';

  // API Timeouts (in milliseconds)
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 3000;
  static const int sendTimeout = 3000;

  // Retry Configuration
  static const int maxRetries = 3;
  static const int retryDelay = 1000; // milliseconds

  // Error Messages
  static const String networkError =
      'Network error occurred. Please check your connection.';
  static const String timeoutError = 'Request timed out. Please try again.';
  static const String serverError =
      'Server error occurred. Please try again later.';
  static const String unauthorizedError =
      'Unauthorized access. Please login again.';
}
