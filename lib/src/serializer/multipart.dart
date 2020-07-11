import 'dart:io';
import 'package:path/path.dart';
import 'package:paypalhttp_dart/src/encoder.dart';

import 'package:paypalhttp_dart/src/http_request.dart';

import '../http_request.dart';
import './serializer.dart';
import './json.dart';
import './text.dart';
import './form_endcoded.dart';
import './form_part.dart';

class Multipart  extends Serializer{
  static String get _CLRF => '\r\n';

  @override
  String encode(HttpPaypalRequest request){
    var boundary = DateTime.now().millisecondsSinceEpoch.toString();
    var headers = request.headers();
    headers.set(
      'content-type', 
      'multipart/form-data; boundary=$boundary'
    );

    var params = <String>[];
    var form_params = <String>[];
    var file_params = <String>[];
    var body = request.body as Map;
    body.forEach((key, value) {
      if(value is File){
        file_params.add(add_file_part(key,value));
      } else if(value is FormPart){
        form_params.add(add_form_part(key, value));
      } else{
        form_params.add(add_form_field(key, value));
      }
    });

    params = form_params + file_params;
    var data = '--' + boundary + _CLRF + params.join('--' + boundary + _CLRF) 
      + _CLRF + '--' + boundary + '--';

    return data;
  }
  @override
  Object decode(Object responseBody) {
    throw Exception('Multipart does not support deserialization.');
  }
  @override
  String content_type() => 'multipart/.*';

  String add_file_part(String key, File f){
    var filename = basename(f.path);
    var mime_type = mime_type_for_filename(filename);
    var out = 'Content-Disposition: form-data; '
      'name=\"${key}\"; filename=\"${filename}\"${_CLRF}';

    out += 'Content-Type: '
      '${mime_type}${_CLRF}${_CLRF}${f.readAsBytesSync()}${_CLRF}';

    return out;
  }

  String add_form_part(String key, FormPart formPart){
    var out = 'Content-Disposition: form-data; name=\"${key}\"';
    var contentType = formPart.headers.value(HttpHeaders.contentTypeHeader);
    if(contentType == 'application/json'){
      out += '; filename=\"${key}.json\"';
    }
    out += _CLRF;

    formPart.headers.forEach((name, values) {
      out += '${name}: ${formPart.headers.value(name)}${_CLRF}';
    });

    out += _CLRF;

    var req = HttpPaypalRequest('', '', Object);
    var headers = req.headers();
    formPart.headers.forEach((name, values) => headers.add(name, values));
    req.body = formPart.value;
    out += Encoder([Json(), Text(), FormEncoded()]).serialize_request(req);

    out += _CLRF;
    return out;
  }

  String add_form_field(String key, Object value) {
    return 'Content-Disposition: form-data; '
      'name=\"${key}\"${_CLRF}${_CLRF}${value}${_CLRF}';
  }

  String mime_type_for_filename(String filename){
    var extension = filename.split('.').last.toLowerCase();
    if(extension == 'jpeg' || extension == 'jpg'){
      return 'image/jpeg';
    } else if(extension == 'png'){
      return 'image/png';
    } else if(extension == 'gif'){
      return 'image/gif';
    } else if(extension == 'pdf'){
      return 'application/pdf';
    } else{
      return 'application/octet-stream';
    }
  }
}