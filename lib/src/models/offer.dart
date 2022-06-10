class Offer {
  final int id;

  Offer(Map<String, dynamic> json) : id = json['id'];

  Map<String, int> toJson() => {'id': id};
}
