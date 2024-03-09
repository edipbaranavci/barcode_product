class StaticConstants {
  static StaticConstants? _instance;
  // Avoid self isntance
  StaticConstants._();
  static StaticConstants get instance {
    _instance ??= StaticConstants._();
    return _instance!;
  }

  final String personnelsCollectionNames = 'personels';
  final String advancesCollectionNames = 'advances';
  final String payablesCollectionNames = 'payables';
  final String permissionsCollectionNames = 'permissions';
  final String salariesCollectionNames = 'salaries';
  final String usersCollectionNames = 'users';
}
