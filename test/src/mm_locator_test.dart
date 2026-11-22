import 'package:minimal_mvn/minimal_mvn.dart';
import 'package:test/test.dart';

void main() {
  group('MMLocator', () {
    test('creates instance lazily', () {
      var created = 0;
      final locator = MMLocator(() {
        created++;
        return 42;
      });
      expect(created, 0);
      locator.instance;
      expect(created, 1);
      locator.instance;
      expect(created, 1);
    });

    test('returns same instance', () {
      final locator = MMLocator(() => <String>[]);
      final first = locator.instance;
      final second = locator.instance;
      expect(second, same(first));
    });
  });
}
