class ServerException implements Exception {
  final String? message;
  ServerException({this.message});
  @override
  String toString() => message ?? 'ServerException';
}



class CacheException implements Exception {}
