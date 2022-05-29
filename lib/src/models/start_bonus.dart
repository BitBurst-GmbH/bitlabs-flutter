class StartBonus {
  final String reward;

  StartBonus(Map<String, dynamic> json) : reward = json['reward'];

  Map<String, String> toJson() => {'reward': reward};
}
