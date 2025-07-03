import 'package:bitlabs/src/utils/helpers.dart';
import 'package:test/test.dart';

void main() {
  group('generateV4UUID', () {
    test('Format is correct', () {
      final uuid = generateV4UUID();
      final expected = RegExp(
        r'^[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}$',
      );

      expect(uuid, matches(expected));
    });

    test('When two ids are generated, Expect them to be non-equal', () {
      final uuid1 = generateV4UUID();
      final uuid2 = generateV4UUID();

      expect(uuid1, isNot(uuid2));
    });

    test('When two ids are generated, Expect them to be valid', () {
      final uuid1 = generateV4UUID();
      final uuid2 = generateV4UUID();

      expect(uuid1, isNotNull);
      expect(uuid2, isNotNull);
    });
  });
}
