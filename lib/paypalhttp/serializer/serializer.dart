import '../http_request.dart';

abstract class Serializer{
  String encode(HttpPaypalRequest request);
  Object decode(Object body);
  String content_type();
}