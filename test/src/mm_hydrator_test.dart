import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minimal_mvn/minimal_mvn.dart';


class InMemoryStorage implements StorageProvider {
  final Map<String, String> _storage = {};
  bool _initialized = false;

  @override
  Future<bool> isInitialized() async => _initialized;

  @override
  Future<void> initialize() async => _initialized = true;

  @override
  Future<String?> getString(final String key) async => _storage[key];

  @override
  Future<bool> setString(final String key, final String value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool> remove(final String key) async {
    _storage.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _storage.clear();
    return true;
  }
}

@immutable
class TestState implements MMState {
  const TestState({required this.value, required this.count});

  factory TestState.fromJson(final Map<String, dynamic> json) => TestState(
        value: json['value'] as String,
        count: json['count'] as int,
      );

  final String value;
  final int count;

  Map<String, dynamic> toJson() => {'value': value, 'count': count};

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is TestState && value == other.value && count == other.count;

  @override
  int get hashCode => Object.hash(value, count);
}

class _MMSelector<T> extends ValueNotifier<T> {
  _MMSelector(this._getValue) : super(_getValue());

  final T Function() _getValue;
  VoidCallback? onAddListener;
  VoidCallback? onRemoveListener;

  void notify() {
    value = _getValue();
  }

  @override
  void addListener(final VoidCallback listener) {
    onAddListener?.call();
    super.addListener(listener);
  }

  @override
  void removeListener(final VoidCallback listener) {
    onRemoveListener?.call();
    super.removeListener(listener);
  }
}

class TestNotifier extends ChangeNotifier implements MMNotifier<TestState> {
  TestNotifier() {
    _state = const TestState(value: 'initial', count: 0);
  }

  late TestState _state;
  int _listenersCount = 0;
  bool _disposed = false;

  @override
  bool get disposed => _disposed;

  @override
  TestState get state => _state;

  @override
  OnUnsubscribedCallback? onUnsubscribed;

  @override
  void notify(final TestState value) {
    _state = value;
    notifyListeners();
  }

  @override
  ValueNotifier<S> select<S>(final S Function(TestState state) selector) {
    final notifier = _MMSelector(() => selector(_state));
    addListener(notifier.notify);
    return notifier;
  }

  @override
  void addListener(final VoidCallback listener) {
    super.addListener(listener);
    _listenersCount++;
  }

  @override
  void removeListener(final VoidCallback listener) {
    super.removeListener(listener);
    _listenersCount--;
    if (_listenersCount <= 0) {
      _listenersCount = 0;
      onUnsubscribed?.call();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

void main() {
  group('MMHydrator', () {
    late InMemoryStorage storage;
    late MMHydrator<TestState> hydrator;
    late HydrationEvent? lastEvent;
    late String? lastError;

    setUp(() {
      storage = InMemoryStorage();
      lastEvent = null;
      lastError = null;

      hydrator = MMHydrator<TestState>(
        key: 'test_key',
        toJson: (final state) => state.toJson(),
        fromJson: TestState.fromJson,
        storage: storage,
        onEvent: (final event, final error) {
          lastEvent = event;
          lastError = error;
        },
      );
    });

    test('save should store state as JSON with version', () async {
      const state = TestState(value: 'test', count: 42);
      final result = await hydrator.save(state);

      expect(result, true);
      expect(lastEvent, HydrationEvent.completed);
      expect(lastError, null);

      final stored = await storage.getString('test_key');
      expect(stored, '{"version":1,"data":{"value":"test","count":42}}');
    });

    test('load should restore state from JSON', () async {
      await storage.setString(
        'test_key',
        '{"version":1,"data":{"value":"test","count":42}}',
      );

      final result = await hydrator.load();

      expect(result, isA<TestState>());
      expect(result?.value, 'test');
      expect(result?.count, 42);
    });

    test('load should handle missing data', () async {
      final result = await hydrator.load();
      expect(result, null);
    });

    test('load should handle invalid JSON', () async {
      await storage.setString('test_key', 'invalid json');
      final result = await hydrator.load();
      expect(result, null);
    });

    test('clear should remove stored state', () async {
      await storage.setString('test_key', '{"data":{"value":"test"}}');
      final result = await hydrator.clear();
      expect(result, true);
      expect(await storage.getString('test_key'), null);
    });
  });

  group('MMNotifierHydration', () {
    late InMemoryStorage storage;
    late MMHydrator<TestState> hydrator;
    late TestNotifier notifier;

    setUp(() {
      storage = InMemoryStorage();
      hydrator = MMHydrator<TestState>(
        key: 'test_key',
        toJson: (final state) => state.toJson(),
        fromJson: TestState.fromJson,
        storage: storage,
      );
      notifier = TestNotifier();
    });

    test('select should update when selected value changes', () {
      final valueNotifier = notifier.select((final state) => state.value);
      final listener = expectAsync1(
        (final value) => expect(value, 'updated'),
      );

      valueNotifier.addListener(() => listener(valueNotifier.value));
      notifier.notify(const TestState(value: 'updated', count: 0));
    });

    test('select should not update when unselected value changes', () {
      final valueNotifier = notifier.select((final state) => state.value);
      var callCount = 0;

      valueNotifier.addListener(() => callCount++);
      notifier.notify(const TestState(value: 'initial', count: 42));

      expect(callCount, 0);
    });

    test('hydrate should update notifier state', () async {
      await storage.setString(
        'test_key',
        '{"data":{"value":"loaded","count":100}}',
      );

      final result = await notifier.hydrate(hydrator);
      expect(result, true);
      expect(notifier.state.value, 'loaded');
      expect(notifier.state.count, 100);
    });

    test('persist should save current state', () async {
      final result = await notifier.persist(hydrator);
      expect(result, true);

      final stored = await storage.getString('test_key');
      expect(stored, '{"version":1,"data":{"value":"initial","count":0}}');
    });
  });
}
