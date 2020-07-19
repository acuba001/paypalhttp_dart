import 'dart:io';

import 'package:mock_web_server/mock_web_server.dart';
import 'package:paypalhttp_dart/paypalhttp_dart.dart';
import 'package:paypalhttp_dart/src/environment.dart';
import 'package:paypalhttp_dart/src/http_client.dart';
import 'package:test/test.dart';

// import 'package:http/http.dart';

// import 'mock_classes.dart';

void main() {
  group('Tests for HttpPaypalClient w/ mock server:', (){
    HttpPaypalRequest req;
    MockWebServer mockServer;
    Environment env;

    setUp((){
      env = Environment('http://localhost:8081');
      mockServer = MockWebServer(port: 8081);
      mockServer.start();
    });

    test('Added header in execute', () async{

      req = HttpPaypalRequest('/', 'GET', null);
      
      var client = HttpPaypalClient(env);
      
      mockServer.enqueue(body: '');

      await client.execute(req);
      var headers = mockServer.takeRequest().headers;
      expect(
        // TODO: When dart:io is updated with fix, remove toLowerCase
        headers['User-Agent'.toLowerCase()], 
        equals(client.get_user_agent())
      );
    });

    test('addInjector Execution', () async{
      req = HttpPaypalRequest('/', 'GET', null);

      var client = HttpPaypalClient(env);

      client.addInjector((req) {
        req.headers()
          .add('Foo', 'Bar', preserveHeaderCase: true);
      });

      mockServer.enqueue(body: '');
      await client.execute(req);

      var headers = mockServer.takeRequest().headers;

      // TODO: When dart:io is updated with fix, remove toLowerCase
      expect(headers['Foo'.toLowerCase()], equals('Bar'));
    });

    test('execute uses all params in request', () async{
      req = HttpPaypalRequest('/', 'POST', null);
      req.headers()
        ..add('Test', 'Header')
        ..add('Content-Type', 'text/plain');
      req.body = 'Some data';

      var client = HttpPaypalClient(env);

      mockServer.enqueue(body: '');
      await client.execute(req);

      var request = mockServer.takeRequest();

      expect(request.method, 'POST');
      expect(mockServer.url, 'http://127.0.0.1:8081/');
      // TODO: When dart:io is updated with fix, remove toLowerCase
      expect(request.headers['Test'.toLowerCase()], equals('Header'));
      expect(request.body, equals('Some data'));
    });

    test('On error throws HTTP error for non-200 codes', () async{
      req = HttpPaypalRequest('/', 'GET', null);
      
      var client = HttpPaypalClient(env);
      
      mockServer.enqueue(httpCode: 401);

      expect(
        client.execute(req), 
        throwsA(equals(isA<HttpException>()))
      );
    });

    test('On success returns with empty body', () async{
      req = HttpPaypalRequest('/', 'GET', null);
      
      var client = HttpPaypalClient(env);
      
      mockServer.enqueue(httpCode: 204);
      var res = await client.execute(req);

      expect(res.body, equals(''));
    });

    test('On success escapes dashes when unmarshalling', () async{
      req = HttpPaypalRequest('/', 'GET', null);
      
      var client = HttpPaypalClient(env);
      
      mockServer.enqueue(
        httpCode: 201, 
        body: '{\"valid-key\": \"valid-data\"}',
        headers: {'Content-Type': 'application/json'}
      );
      // TODO: Deal w/ type of response.body
      var res = await client.execute(req);
      var body = res.body as Map;
      expect(body['valid-key'], 'valid-data');
    });

    test('Execute does not modify request', () async{
      req = HttpPaypalRequest('/', 'GET', null);
      
      var client = HttpPaypalClient(env);
      
      mockServer.enqueue(httpCode: 200);
      await client.execute(req);

      var len = 0;
      req.headers().forEach((name, values) {len++;});

      expect(len, 0);
    });

    test('Execute preserve files in copy', () async{
      req = HttpPaypalRequest('/', 'GET', null);
      req.headers().add('Content-Type', 'multipart/related');
      var license = File('LICENSE');
      req.body = {
        'license': license
      };
      
      var client = HttpPaypalClient(env);
      
      mockServer.enqueue(httpCode: 200);
      await client.execute(req);

      var request = mockServer.takeRequest();
      var licenseStr = license.readAsStringSync();
      
      expect(
        request.body.contains(licenseStr), 
        equals(true)
      );
    });

    tearDown((){
      mockServer.shutdown();
    });
  });

  // group('Tests for HttpPaypalClient w/o mock server:', (){
  //   Environment env;
  //   test('Throws Exception when argument not functional in addInjector', (){
  //     env = MockEnvironment();
  //     var client = HttpPaypalClient(env);

  //     // expect(() => client.addInjector(1), isNull);
  //   });
  // });

  // group('a: ', (){
  //   test('a', () async{
  //     var _server = MockWebServer(port: 8081);
  //     _server.start();

  //     _server.enqueue(httpCode: 401);
  //     var client = HttpClient();
  //     var response = await client
  //       .openUrl('GET', Uri.parse('http://localhost:8081/'))
  //       .then((req) => req.close());
  //     expect(response.statusCode, 401);
  //   });
  // });
}