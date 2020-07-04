import '../http_request.dart';

import './serializer.dart';

class Text extends Serializer{
  @override
  String encode(HttpPaypalRequest request) => request.body.toString();
  @override
  Object decode(Object body) => body.toString();
  @override
  String content_type() => 'text/.*';
}
