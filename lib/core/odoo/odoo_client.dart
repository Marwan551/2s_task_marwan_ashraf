import 'package:dio/dio.dart';
import 'odoo_exception.dart';

class OdooClient {
  final Dio _dio;

  OdooClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 30),
                sendTimeout: const Duration(seconds: 15),
                headers: const {'content-type': 'application/json'},
              ),
            );

  Future<int?> authenticate({
    required String baseUrl,
    required String db,
    required String username,
    required String password,
  }) async {
    final result = await _call(
      baseUrl: baseUrl,
      service: 'common',
      method: 'login',
      args: [db, username, password],
    );
    if (result is num && result > 0) {
      return result.toInt();
    }
    return null;
  }

  Future<dynamic> executeKw({
    required String baseUrl,
    required String db,
    required int uid,
    required String password,
    required String model,
    required String method,
    List args = const [],
    Map<String, dynamic> kwargs = const {},
  }) async {
    return _call(
      baseUrl: baseUrl,
      service: 'object',
      method: 'execute_kw',
      args: [db, uid, password, model, method, args, kwargs],
    );
  }

  Future<dynamic> _call({
    required String baseUrl,
    required String service,
    required String method,
    required List<dynamic> args,
  }) async {
    try {
      final uri = Uri.tryParse(baseUrl.trim());
      if (uri == null ||
          !uri.hasAuthority ||
          !const {'http', 'https'}.contains(uri.scheme) ||
          uri.host.isEmpty ||
          uri.userInfo.isNotEmpty ||
          uri.query.isNotEmpty ||
          uri.fragment.isNotEmpty) {
        throw OdooException('Enter a valid Odoo URL using http or https.');
      }
      final basePath = uri.path.replaceFirst(RegExp(r'/+$'), '');
      final url = uri.replace(path: '$basePath/jsonrpc').toString();
      final response = await _dio.post(
        url,
        data: {
          'jsonrpc': '2.0',
          'method': 'call',
          'id': DateTime.now().microsecondsSinceEpoch,
          'params': {
            'service': service,
            'method': method,
            'args': args,
          },
        },
      );
      final data = response.data;
      if (data is! Map) {
        throw OdooException('Odoo returned an invalid response.');
      }
      final error = data['error'];
      if (error != null) {
        final errorMap = error is Map ? error : const <dynamic, dynamic>{};
        final errorData = errorMap['data'];
        final details = errorData is Map ? errorData : const <dynamic, dynamic>{};
        final message = details['message'] ?? errorMap['message'];
        throw OdooException(
          message is String && message.isNotEmpty ? message : 'Odoo API error',
          code: errorMap['code'] is int ? errorMap['code'] as int : null,
          data: errorData,
        );
      }
      if (!data.containsKey('result')) {
        throw OdooException('Odoo returned a response without a result.');
      }
      return data['result'];
    } on DioException catch (error) {
      final isNetworkError = error.response == null;
      throw OdooException(
        isNetworkError
            ? 'Could not connect to Odoo. Check the server URL and your network connection.'
            : 'Odoo request failed with HTTP ${error.response?.statusCode}.',
        isNetworkError: isNetworkError,
      );
    }
  }
}
