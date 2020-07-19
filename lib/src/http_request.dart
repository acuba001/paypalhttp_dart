import 'http_headers.dart';

class HttpPaypalRequest {
  String path;
  String verb;
  Object body;
  final HttpPaypalHeaders _headers;
  final Type _responseType;

  HttpPaypalRequest(this.path, this.verb, this._responseType): 
    _headers = HttpPaypalHeaders();
  

  HttpPaypalHeaders headers() => _headers;
  Type responseType() => _responseType;

  HttpPaypalRequest copy(){
    var other = HttpPaypalRequest(path, verb, _responseType);
    other.body = body;
    _headers.forEach((name, values) => other.headers().add(name, values.single));
    return other;
  }
}