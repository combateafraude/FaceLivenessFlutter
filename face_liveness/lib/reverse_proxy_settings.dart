/// The reverse proxy settings that will be used to run the FaceLiveness and Authentication services.
///
/// These two services can operate independently of each other.
class ReverseProxySettings {
  /// The base URL of the reverse proxy that will be used to run the FaceLiveness service.
  ///
  /// **The URL's protocol must be WSS**.
  String? faceLivenessBaseUrl;

  /// A list of certificates that will be used to authenticate the reverse proxy to run the FaceLiveness service.
  ///
  /// The certificates must be **base64-encoded SHA-256 hash of certificate' Subject Public Key Info**.
  List<String>? certificates;

  /// The base URL of the reverse proxy that will be used to run the Authentication service.
  ///
  /// **The URL's protocol must be HTTPS**.
  String? authenticationBaseUrl;

  ReverseProxySettings({
    this.faceLivenessBaseUrl,
    this.certificates,
    this.authenticationBaseUrl,
  });

  Map asMap() {
    Map<String, dynamic> map = {};

    if (faceLivenessBaseUrl != null && certificates == null) {
      throw ArgumentError(
          "You must provide a list of certificates if you want to use the reverse proxy for running FaceLiveness.",
          "certificates");
    }

    map["faceLivenessBaseUrl"] = faceLivenessBaseUrl;
    map["certificates"] = certificates?.map((e) => e).toList();
    map["authenticationBaseUrl"] = authenticationBaseUrl;

    return map;
  }
}
