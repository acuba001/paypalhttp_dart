import 'dart:io';


class HttpPaypalResponse{

  Object body;
  int status_code;
  HttpHeaders headers;

  HttpPaypalResponse(this.body, this.status_code, this.headers);
}