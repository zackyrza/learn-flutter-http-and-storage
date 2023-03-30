import 'package:dio/dio.dart';

class DioApi {
  final dio = Dio();
  final apiPath = 'https://jsonplaceholder.typicode.com';

  void request() async {
    Response response;
    response = await dio.get('${apiPath}/posts');
    print(response.data.toString());
  }
}
