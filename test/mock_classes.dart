import 'package:mockito/mockito.dart';

import 'package:paypalhttp_dart/paypalhttp_dart.dart';
import 'package:paypalhttp_dart/src/encoder.dart';
import 'package:paypalhttp_dart/src/http_headers.dart';

class MockHttpPaypalRequest extends Mock implements HttpPaypalRequest {}
class MockHttpPaypalHeaders extends Mock implements HttpPaypalHeaders {}
class MockEncoder extends Mock implements Encoder {}
class MockEnvironment extends Mock implements Environment {}