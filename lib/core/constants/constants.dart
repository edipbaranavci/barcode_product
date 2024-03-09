class Constants {
  static Constants? _instance;
  // Avoid self isntance
  Constants._();
  static Constants get instance {
    _instance ??= Constants._();
    return _instance!;
  }
}
