class SentryDsn {
  final String dsn;
  late final String host;
  late final String protocol;
  late final String publicKey;
  late final String projectId;

  SentryDsn({required this.dsn}) {
    final regExp = RegExp(r'(\w+)://(\w+)@(.*)/(\w+)');
    final match = regExp.firstMatch(dsn);
    if (match == null) {
      throw Exception('Invalid Sentry DSN: $dsn');
    }

    protocol = match.group(1)!;
    publicKey = match.group(2)!;
    host = match.group(3)!;
    projectId = match.group(4)!;
  }

  @override
  String toString() => dsn;
}
