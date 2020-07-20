## HttpPaypalClient 
PayPalHttp is a generic HTTP Client.

In it's simplest form, an [`HttpPaypalClient`](lib/src/http_client.dart) exposes an `#execute` method which takes an HTTP request, executes it against the domain described in an `Environment`, and returns an `HttpPaypalResponse`. It throws an Error, and potentially an `HttpError`, if anything goes wrong during execution.

### Environment

An [`Environment`](lib/src/environment.dart) describes a domain that hosts a REST API, against which an `HttpPaypalClient` will make requests. `Environment` is a simple class that contains one property, `base_url`.

```dart
var env = Environment("https://example.com");
```

### Requests

HTTP request objects contain all the information needed to make an HTTP request against the REST API. Specifically, one request object describes a path, a verb, any path/query/form parameters, headers, attached files for upload, and body data. To make one, use [`HttpPaypalRequest`](lib/src/http_request.dart).

### Responses

[`HttpPaypalResponse`](lib/src/http_response.dart)s contain information returned by a server in response to a request as described above. They contain a `status_code`, `headers`, and a `body`, which represents any data returned by the server.

```dart
var req = HttpPaypalRequest(
    '/path/to/resource',
    'GET',
    null
  );

var res = client.execute(req);
```

### Injectors

Injectors are functions that can be used for executing arbitrary pre-flight logic, such as modifying a request or logging data. Injectors are attached to an `HttpPaypalClient` using the `#addInjector` method.

The HttpPaypalClient executes its `Injector`s in a first-in, first-out order, before each request.

```dart
client = HttpPaypalClient(env);

client.addInjector(
  (req) => req.headers().add('/path/to/resource', 'custom value')
);

...
```

<!-- ### Error Handling

`HttpPaypalClient#execute` may raise an `IOError` if something went wrong during the course of execution. If the server returned a non-200 response, this execption will be an instance of [`HttpError`](paypalhttp/http_error.py) that will contain a status code and headers you can use for debugging. 

```dart
try{
  var res = client.execute(req);
  var status_code = res.status_code;
  var headers = res.headers;
  var response_data = res.body;
} catch (HttpError err) {
  // Inspect this exception for details
  var status_code = err.status_code;
  var headers = err.headers;
  var message = str(err);
} catch (IOError err){
  // Something else went wrong
  print(err);
}
``` -->

### Serializer
(De)Serialization of request and response data is done by instances of [`Encoder`](lib/src/encoder.dart). PayPalHttp currently supports `JSON` encoding out of the box.

## License
PayPalHttp-Dart is open source and available under the MIT license. See the [LICENSE](./LICENSE) file for more info.

## Contributing
Pull requests and issues are welcome.
