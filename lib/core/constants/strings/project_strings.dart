class ProjectStrings {
  static ProjectStrings? _instance;
  static ProjectStrings get instance {
    _instance ??= ProjectStrings._init();
    return _instance!;
  }

  ProjectStrings._init();
  final String appTitle = 'Personel Takip | EKABAV';
}
