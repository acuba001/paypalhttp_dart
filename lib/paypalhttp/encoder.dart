import 'dart:io';

import './serializer/serializer.dart';
import './http_request.dart';

class Encoder{
  
  List<Serializer> encoders;

  Encoder(this.encoders);

  String serialize_request(HttpPaypalRequest request){
    var header = request.headers();
    var contentType = header.value(HttpHeaders.contentTypeHeader);
    if( contentType != null){
      var encoder = _encoder(contentType);
      if(encoder != null){
        return encoder.encode(request);
      } else{
        throw Exception('Unable to serialize request with Content-Type '
          '${contentType}. Supported encodings are ${supported_encodings()}');
      }
    }
    throw Exception('Http request does not have content-type header set');
  }

  Object deserialize_response(Object responseBody, HttpHeaders headers){
    var contentType = headers.value(HttpHeaders.contentTypeHeader);
    if(contentType == null){
      throw Exception('HttpRequest does not have Content-Type header set');
    }

    var encoder = _encoder(contentType);
    if(encoder == null){
      throw Exception('Unable to deserialize response with Content-Type '
        '${contentType}. Supported decodings are ${supported_encodings()}');
    }
    return encoder.decode(responseBody);
  }

  List<String> supported_encodings(){
    var out = <String>[];
    encoders.forEach((encoder) => out.add(encoder.content_type()));
    return out;
  }

  Serializer _encoder(String contentType){
    for (var encoder in encoders) {
      var exp = RegExp(encoder.content_type());
      if(exp.firstMatch(contentType) != null){
        return encoder;
      }
    }
    return null;
  }
}