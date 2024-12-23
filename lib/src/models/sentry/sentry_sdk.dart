class SentrySDK {
  final String name;
  final String version;

  SentrySDK({
    this.name = 'sentry.dart.flutter',
    required this.version,
  });

  Map<String, String> toJson() => {
        'name': name,
        'version': version,
      };
}
