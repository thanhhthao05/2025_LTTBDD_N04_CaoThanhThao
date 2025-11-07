abstract class ValueListenable<T> {
  T get value;
  void addListener(void Function() listener);
  void removeListener(void Function() listener);
}

class ValueNotifier<T> implements ValueListenable<T> {
  ValueNotifier(this._value);

  T _value;
  final List<void Function()> _listeners = [];

  @override
  T get value => _value;

  set value(T newValue) {
    if (identical(newValue, _value)) return;
    _value = newValue;
    _notifyListeners();
  }

  @override
  void addListener(void Function() listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  @override
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _listeners.clear();
  }

  void _notifyListeners() {
    for (final listener in List<void Function()>.from(_listeners)) {
      listener();
    }
  }
}

