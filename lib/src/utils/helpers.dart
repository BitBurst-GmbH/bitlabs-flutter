import 'dart:math';

String generateV4UUID() {
  final random = Random.secure();
  return List.generate(16, (index) {
    int value = random.nextInt(256);
    if (index == 6) {
      value = (value & 0x0F) | 0x40; // version 4
    } else if (index == 8) {
      value = (value & 0x3F) | 0x80; // variant 1
    }
    return value.toRadixString(16).padLeft(2, '0');
  }).join().replaceAllMapped(RegExp(r'(.{8})(.{4})(.{4})(.{4})(.{12})'),
      (match) => '${match[1]}-${match[2]}-${match[3]}-${match[4]}-${match[5]}');
}
