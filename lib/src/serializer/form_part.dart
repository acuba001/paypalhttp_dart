import 'package:paypalhttp_dart/src/http_headers.dart';

extension StringExtension on String {
    String capitalize() {
      return '${this[0].toUpperCase()}${substring(1)}';
    }
}

class FormPart{

  Object value;
  HttpPaypalHeaders headers;

  FormPart(this.value, HttpPaypalHeaders headers){
    this.headers = HttpPaypalHeaders();
    headers.forEach((name, values) {
      var newName = name.split('-').map((e) => e.capitalize()).join('-');
      this.headers.add(newName, values);
    });
  }
}