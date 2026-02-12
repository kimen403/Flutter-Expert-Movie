import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ditonton/common/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Constants', () {
    test('BASE_IMAGE_URL should be correct', () {
      expect(BASE_IMAGE_URL, 'https://image.tmdb.org/t/p/w500');
    });

    group('Colors', () {
      test('kRichBlack should be correct', () {
        expect(kRichBlack, const Color(0xFF000814));
      });

      test('kOxfordBlue should be correct', () {
        expect(kOxfordBlue, const Color(0xFF001D3D));
      });

      test('kPrussianBlue should be correct', () {
        expect(kPrussianBlue, const Color(0xFF003566));
      });

      test('kMikadoYellow should be correct', () {
        expect(kMikadoYellow, const Color(0xFFffc300));
      });

      test('kDavysGrey should be correct', () {
        expect(kDavysGrey, const Color(0xFF4B5358));
      });

      test('kGrey should be correct', () {
        expect(kGrey, const Color(0xFF303030));
      });
    });

    group('Drawer Theme', () {
      test('kDrawerTheme should have correct backgroundColor', () {
        expect(kDrawerTheme.backgroundColor, Colors.grey.shade700);
      });
    });

    group('Color Scheme', () {
      test('kColorScheme should have correct primary', () {
        expect(kColorScheme.primary, kMikadoYellow);
      });

      test('kColorScheme should have correct secondary', () {
        expect(kColorScheme.secondary, kPrussianBlue);
      });

      test('kColorScheme should have correct secondaryContainer', () {
        expect(kColorScheme.secondaryContainer, kPrussianBlue);
      });

      test('kColorScheme should have correct surface', () {
        expect(kColorScheme.surface, kRichBlack);
      });

      test('kColorScheme should have correct error', () {
        expect(kColorScheme.error, Colors.red);
      });

      test('kColorScheme should have correct onPrimary', () {
        expect(kColorScheme.onPrimary, kRichBlack);
      });

      test('kColorScheme should have correct onSecondary', () {
        expect(kColorScheme.onSecondary, Colors.white);
      });

      test('kColorScheme should have correct onSurface', () {
        expect(kColorScheme.onSurface, Colors.white);
      });

      test('kColorScheme should have correct onError', () {
        expect(kColorScheme.onError, Colors.white);
      });

      test('kColorScheme should have correct brightness', () {
        expect(kColorScheme.brightness, Brightness.dark);
      });
    });
  });
}
