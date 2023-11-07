import 'package:bitlabs/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('rounded', () {
    test('When three or more decimal points, Expect three decimal points', () {
      const d = 1.123456789;
      const expected = '1.123';

      expect(d.rounded(), expected);
    });
    
    test('When less than three decimal points, Expect the same', () {
      const d = 1.12;
      const expected = '1.12';

      expect(d.rounded(), expected);
    });
    
    test('When no decimal points, Expect the same', () {
      const double d = 1;
      const expected = '1';

      expect(d.rounded(), expected);
    });

    test('When three decimal points but zeros, Expect no zeros', () {
      const d = 1.000;
      const expected = '1';

      expect(d.rounded(), expected);
    });

    test('When three decimal points but last one is zero, Expect no zeros', () {
      const d = 1.120;
      const expected = '1.12';

      expect(d.rounded(), expected);
    });
  });
  
  group('colorsFromCSS', () {
    test('When single hex color, Expect two colors', () {
      const s = '#000000';
      const expected = [Colors.black, Colors.black];

      expect(s.colorsFromCSS(), expected);
    });
    
    test('When linear gradient, Expect two colors', () {
      const s = 'linear-gradient(90deg, #000000 0%, #ffffff 100%)';
      const expected = [Colors.black, Colors.white];

      expect(s.colorsFromCSS(), expected);
    });
    
    test('When empty string, Expect empty array', () {
      const s = '';
      const expected = [];

      expect(s.colorsFromCSS(), expected);
    });

    test('When string is not a hex nor a gradient, Expect empty array', () {
      const s = 'not a hex nor a gradient';
      const expected = [];

      expect(s.colorsFromCSS(), expected);
    });
  });
}
