enum CafStage {
  prod,
  beta,
}

extension StageToString on CafStage {
  String get stringValue => name.toUpperCase();
}

enum CameraFilter {
  natural,
  lineDrawing,
}

extension CameraFilterToString on CameraFilter {
  String get stringValue => _enumCaseToString(name);
}

enum UrlExpirationTime {
  threeHours,
  thirtyDays,
}

extension UrlExpirationTimeToString on UrlExpirationTime {
  String get stringValue => _enumCaseToString(name);
}

/// separate camelCase text with underscore: camelCase => camel_Case
/// and convert the whole text to uppercase before returning it.
String _enumCaseToString(String text) {
  final exp = RegExp(r'(?<=[a-z])[A-Z]');
  return text
      .replaceAllMapped(exp, (Match m) => ('_${m.group(0)!}'))
      .toUpperCase();
}
