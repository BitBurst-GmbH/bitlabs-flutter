class SendEnvelopeResponse {
  final String id;

  SendEnvelopeResponse(Map<String, dynamic> json) : id = json['id'];

  Map<String, dynamic> toJson() => {'id': id};
}
