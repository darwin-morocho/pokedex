class Env {
  Env._(); // coverage:ignore-line

  static String get baseApiUrl {
    return const String.fromEnvironment('BASE_API_URL');
  }

  static String get baseImageUrl {
    return const String.fromEnvironment('BASE_IMAGE_URL');
  }
}
