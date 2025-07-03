extension MapExtension on Map {
  T getValue<T>(String key) {
    final value = this[key];
    if (value == null) throw ArgumentError('Missing or null: $key');
    if (value is! T) {
      throw ArgumentError(
          'Expected $key to be ${T.toString()} but was ${value.runtimeType}');
    }
    return value;
  }
}
