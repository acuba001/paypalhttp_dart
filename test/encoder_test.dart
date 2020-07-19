import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:paypalhttp_dart/paypalhttp_dart.dart';
import 'package:paypalhttp_dart/src/encoder.dart';
import 'package:paypalhttp_dart/src/http_headers.dart';
import 'package:test/test.dart';

import 'mock_classes.dart';

void main() {
  group('Test for Encoder:', () {
    HttpPaypalRequest req;
    HttpPaypalHeaders headers;

    test('Throws when content-type header not set.', () {

      req = MockHttpPaypalRequest();
      headers = HttpPaypalHeaders();

      when(req.headers()).thenReturn(headers);

      var encoder = Encoder([
        Json(), 
        Text(), 
        Multipart(), 
        FormEncoded()
      ]);
      // encoder.serialize_request(req);
      expect(
        () => encoder.serialize_request(req),
        throwsA(isA<MissingContentTypeException>())
      );
    });

    test('Throws when content-type not JSON.', (){

      req = MockHttpPaypalRequest();
      headers = HttpPaypalHeaders();

      headers.add('Content-Type', 'application/xml');

      when(req.headers()).thenReturn(headers);

      var encoder = Encoder([
        Json(), 
        Text(), 
        Multipart(), 
        FormEncoded()
      ]);

      expect(
        () => encoder.serialize_request(req),
        throwsException
      );
    });

    test('Request with content-type JSON. Stringify Data', (){

      req = MockHttpPaypalRequest();
      headers = HttpPaypalHeaders();

      headers.add('Content-Type', 'application/json; charset=utf8');

      when(req.headers()).thenReturn(headers);
      when(req.body).thenReturn({
        'key': 'value',
        'list': ['one', 'two']
      });

      var encoder = Encoder([
        Json(), 
        Text(), 
        Multipart(), 
        FormEncoded()
      ]);

      var s = encoder.serialize_request(req);

      expect(s, '{"key":"value","list":["one","two"]}');
    });

    test('Request with content-type text. Stringify Data', (){

      req = MockHttpPaypalRequest();
      headers = HttpPaypalHeaders();

      headers.add('Content-Type', 'text/plain; charset=utf8');

      when(req.headers()).thenReturn(headers);
      when(req.body).thenReturn('some text data');

      var encoder = Encoder([
        Json(), 
        Text(), 
        Multipart(), 
        FormEncoded()
      ]);

      var s = encoder.serialize_request(req);

      expect(s, req.body);
    });

    test('Request with content-type multipart. Stringify Data', (){

      req = MockHttpPaypalRequest();
      headers = HttpPaypalHeaders();

      headers.add('Content-Type', 'multipart/form-data; charset=utf8');

      when(req.headers()).thenReturn(headers);

      var bodyHeaders = HttpPaypalHeaders();
      bodyHeaders.add('Content-Type', 'application/json');
      var f = File('test/resources/fileupload_test_binary.jpg');
      var data = f.readAsBytesSync();

      when(req.body).thenReturn({
        'file': f,
        'input': FormPart({'key': 'val'}, bodyHeaders)
      });

      var encoder = Encoder([
        Json(), 
        Text(), 
        Multipart(), 
        FormEncoded()
      ]);

      var s = encoder.serialize_request(req);

      expect(
        req.headers()
          .value('content-type')
          .contains('multipart/form-data; boundary='), 
        isTrue
      );
      expect(
        s.contains(
          'Content-Disposition: form-data; name=\"input\"; '
          'filename=\"input.json\"'
        ), 
        isTrue
      );
      expect(s.contains('{\"key\":\"val\"}'), isTrue);
      expect(
        s.contains(
          'Content-Disposition: form-data; name=\"file\"; '
          'filename=\"fileupload_test_binary.jpg\"'
        ), 
        isTrue
      );
      expect(s.contains('Content-Type: image/jpeg'), isTrue);
      expect(s.contains(data.toString()), isTrue);

      var exp = RegExp(
        r'.*input.json.*fileupload_test_binary.jpg.*',
        dotAll: true
      );
      expect(exp.firstMatch(s), isNotNull);
    });

    test('Request with content-type form-urlencoded. Stringify Data', (){
      req = MockHttpPaypalRequest();
      headers = HttpPaypalHeaders();

      headers.add(
        'Content-Type', 
        'application/x-www-form-urlencoded; charset=utf8'
      );

      when(req.headers()).thenReturn(headers);
      when(req.body).thenReturn({
        'key': 'value',
        'key_two': 'value with spaces'
      });

      var encoder = Encoder([
        Json(), 
        Text(), 
        Multipart(), 
        FormEncoded()
      ]);

      var s = encoder.serialize_request(req);

      var exp = RegExp(
        '(key=value&key_two=value%20with%20spaces'
        '|key_two=value%20with%20spaces&key=value)'
      );

      expect(exp.firstMatch(s), isNotNull);
    });

    // TODO: Add deserializing tests
  });
}
