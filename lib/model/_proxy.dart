enum ProxyConfigType { autoproxy, http, https }

class ProxyConfig {
  ProxyConfig();
  factory ProxyConfig.fromJson(Map<String, dynamic> json) {
    final ProxyConfigType configType = ProxyConfigType.values
        .firstWhere((ProxyConfigType t) => t.toString == json['type']);
    switch (configType) {
      case ProxyConfigType.autoproxy:
        return ProxyAutoConfig(url: json['url'] as String);
      case ProxyConfigType.http:
        return ProxyHttpConfig(
            host: json['host'] as String, port: json['port'] as String);
      case ProxyConfigType.https:
        return ProxyHttpsConfig(
            host: json['host'] as String, port: json['port'] as String);
    }
  }
}

class ProxyAutoConfig extends ProxyConfig {
  ProxyAutoConfig({required this.url});
  final String url;
}

class ProxyHttpConfig extends ProxyConfig {
  ProxyHttpConfig({required this.host, required this.port});
  final String host;
  final String port;
}

class ProxyHttpsConfig extends ProxyConfig {
  ProxyHttpsConfig({required this.host, required this.port});
  final String host;
  final String port;
}
