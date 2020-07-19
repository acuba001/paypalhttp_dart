import 'package:paypalhttp_dart/src/http_headers.dart';
import 'package:test/test.dart';


void main() {
  group('Test for HttpPaypalHeader: ', (){
    test('Add and check the value', (){
      var header = HttpPaypalHeaders();

      header.add('Content-Type', 'application/json');
      
      expect(
        header.value('Content-Type'), 
        equals('application/json')
      );

      expect(
        header.value('content-type'), 
        equals('application/json')
      );
    });

    test('Add and check the value w/ case preserved', (){
      var header = HttpPaypalHeaders();

      header.add(
        'Content-Type', 
        'application/json',
        preserveHeaderCase: true
      );
      
      expect(
        header.value('Content-Type'), 
        equals('application/json')
      );

      expect(
        header.value('content-type'), 
        equals('application/json')
      );
    });

    test('forEach uses the appropriate case', (){
      var header = HttpPaypalHeaders();

      header.add(
        'Content-Type', 
        'application/json',
        preserveHeaderCase: true
      );
      header.add('Data-Key', 'Data-Value');

      var headerKey = <String>[];
      var headerValue = <String>[];
      header.forEach((name, values) {
        headerKey.add(name);
        headerValue.add(values.single);
      });

      expect(headerKey[0], 'Content-Type');
      expect(headerValue[0], 'application/json');
      expect(headerKey[1], 'data-key');
      expect(headerValue[1], 'Data-Value');
    });
  });
}