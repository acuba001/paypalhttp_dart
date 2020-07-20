import 'package:paypalhttp_dart/paypalhttp_dart.dart';

void main() {
  var env = Environment('https://example.com');

  var client = HttpPaypalClient(env);

  var req = HttpPaypalRequest(
    '/path/to/resource',
    'GET',
    null
  );

  client.addInjector(
    (req) => req.headers().add('/path/to/resource', 'custom value')
  );

  var res = client.execute(req);
}
