class ServerException implements Exception {
  final String message;
  final String? code;
  const ServerException({required this.message, this.code});
}

class CacheException implements Exception {
  final String message;
  const CacheException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  const NetworkException({this.message = 'No internet connection'});
}
