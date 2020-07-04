import 'dart:convert';
import 'package:paypalhttp_dart/paypalhttp/http_request.dart';

import './serializer.dart';

class Json extends Serializer {
  @override
  String encode(HttpPaypalRequest request) => jsonEncode(request);
  @override
  Object decode(Object body) => jsonDecode(body);
  @override
  String content_type() => 'application/json';
}