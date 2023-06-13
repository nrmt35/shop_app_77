import 'json_http_client.dart';
import 'responses.dart';

extension Endpoints on Never {
  static const String _baseUrl = 'https://run.mocky.io/v3';

  static const String categories = '$_baseUrl/058729bd-1402-4578-88de-265481fd7d54';
  static const String dishes = '$_baseUrl/aba7ecaa-0a70-453b-b62d-0e326c859b3b';
}

class ApiClient {
  final JsonHttpClient _httpClient;

  ApiClient(this._httpClient);

  Future<List<Category>> categories() {
    return _httpClient.get(
      Endpoints.categories,
      mapper: (dynamic r) {
        final response = r as Map<String, dynamic>;
        return (response['сategories'] as List<dynamic>)
            .map((dynamic o) => Category.fromJson(o as Map<String, dynamic>))
            .toList(growable: false);
      },
    );
  }

  Future<List<Dish>> dishes() {
    return _httpClient.get(
      Endpoints.dishes,
      mapper: (dynamic r) {
        final response = r as Map<String, dynamic>;
        return (response['dishes'] as List<dynamic>)
            .map((dynamic o) => Dish.fromJson(o as Map<String, dynamic>))
            .toList(growable: false);
      },
    );
  }
}
