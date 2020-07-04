import '../http_request.dart';

import './serializer.dart';

class FormEncoded extends Serializer{
  @override
  String encode(HttpPaypalRequest httpRequest) {
    var params = [];
    var body = httpRequest.body as Map<String,String>;
    body.forEach((key, value) => params.add('${key}=${value}'));
    return Uri.encodeComponent(params.join('&'));
  }
  @override
  Object decode(Object responseBody) {
    throw Exception('FormEncoded does not support deserialization');
  }
  @override
  String content_type() => 'application/x-www-form-urlencoded';
}