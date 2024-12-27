class SentryEnvelopeHeaders {
  final String eventId;
  final String sentAt;
  final String dsn;

  SentryEnvelopeHeaders({
    required this.eventId,
    required this.sentAt,
    required this.dsn,
  });

  Map<String, String> toJson() => {
        'event_id': eventId,
        'sent_at': sentAt,
        'dsn': dsn,
      };
}
