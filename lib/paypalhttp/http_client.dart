import 'dart:html';
import 'dart:io';
import 'dart:convert';
import 'package:paypalhttp_dart/paypalhttp/serializer/form_endcoded.dart';

import 'dart:async';

import './environment.dart';
import './encoder.dart';
import './http_request.dart';
import './http_response.dart';
import './serializer/json.dart';
import './serializer/text.dart';
import './serializer/multipart.dart';


typedef Injector = void Function(HttpPaypalRequest req);

class HttpPaypalClient{
  
  Environment environment;
  final List<Injector> _injectors = [];
  Encoder encoder;
  HttpClient client;
  
  HttpPaypalClient(this.environment): 
    encoder = Encoder([Json(), Text(), Multipart(), FormEncoded()]), 
    client = HttpClient();

  String get_user_agent() => 'Dart HTTP/1.1';
  
  int timeout() => 30;

  void addInjector(Injector injector) => _injectors.add(injector);

  Map<String,String> formatHeaders(Map<String,String> headers){
    var formattedHeader = {};
    headers.forEach((key, value)=>{
      formattedHeader[key.toLowerCase()] = value
    });
    return formattedHeader;
  }

  Future<HttpPaypalResponse> execute(HttpPaypalRequest request){
    // Use a deep copy of request
    var reqcpy = request.copy();
    var headers = reqcpy.headers();

    // Apply injectors
    _injectors.map((e) => e(reqcpy));

    // Add user-agent header
    headers.add(HttpHeaders.userAgentHeader, get_user_agent());

    return client.openUrl(reqcpy.verb, Uri.parse(environment.baseUrl + reqcpy.path))
      .then((HttpClientRequest req) {
        headers.forEach((name, values) => req.headers.add(name, values));
        if(reqcpy.body != null){
          req.write(encoder.serialize_request(reqcpy));
        }
        return req.close();
      })
      .then((HttpClientResponse res) => parse_response(res));
  }

  Future<HttpPaypalResponse> parse_response(HttpClientResponse response) async{
    var status_code = response.statusCode;

    if(200 <= status_code && status_code <= 299){
      var body = '';
      var text = await response.transform(utf8.decoder).join('; ');
      if(text != null && text.isNotEmpty && text != 'None'){
        body = encoder.deserialize_response(text, response.headers);
      }
      return HttpPaypalResponse(body, status_code, response.headers);
    }
    var message = await response.join('; ');
    throw HttpException(message);
  }
}