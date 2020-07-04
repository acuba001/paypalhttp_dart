import 'dart:io';

class HttpPaypalHeaders extends HttpHeaders{

  final Map<String, List<String>> _headers;

  HttpPaypalHeaders(): 
    _headers = <String, List<String>>{};

  @override
  List<String> operator [](String name) {
    if(_headers.containsKey(name)){
      return List<String>.from(_headers[name]);
    }
    return null;
  }
  
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    if(value is List<String>){
      if(_headers.containsKey(name)){
        _headers[name].addAll(value);
      }else{
        _headers[name] = List<String>.from(value);
      }
      return;
    } 
    if(value is Map<String, String>){
      var out = <String>[];
      value.forEach((k, v) {
        if(value == null) {
          out.add(k);
        } else {
          out.add('${k}=${v}');
        }
      });
      if(_headers.containsKey(name)){
        _headers[name].addAll(out);
      }else{
        _headers[name] = out;
      }
      return;
    } 
    if(value is String){
      if(_headers.containsKey(name)){
        _headers[name].add(value);
      } else{
        _headers[name] = <String> [value];
      }
      return;
    }
    throw Exception('Value type for Header.add unexpected. Please ' 
      'input a List<String>, Map<String,String>, or String.');
  }

  @override
  void clear() {
    _headers.clear();
  }

  @override
  void forEach(void Function(String name, List<String> values) action) {
    _headers.forEach(action);
  }

  @override
  void noFolding(String name) {
    throw UnimplementedError();
  }

  @override
  void remove(String name, Object value) {
    if(value is List<String>){
      _headers[name].removeWhere((s) => value.contains(s));
      return;
    } 
    if(value is Map<String, String>){
      var out = <String>[];
      value.forEach((k, v) {
        if(value == null) {
          out.add(k);
        } else {
          out.add('${k}=${v}');
        }
      });
      remove(name, out);
      return;
    } 
    if(value is String){
      _headers[name].remove(value);
      return;
    }
    throw Exception('Value type for Header.add unexpected. Please ' 
      'input a List<String>, Map<String,String>, or String.');
  }

  @override
  void removeAll(String name) {
    _headers.remove(name);
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    if(value is List<String>){
      _headers[name] = List<String>.from(value);
      return;
    } 
    if(value is Map<String, String>){
      var out = <String>[];
      value.forEach((k, v) {
        if(value == null) {
          out.add(k);
        } else {
          out.add('${k}=${v}');
        }
      });
      _headers[name] = out;
      return;
    } 
    if(value is String){
      _headers[name] = <String> [value];
      return;
    }
    throw Exception('Value type for Header.add unexpected. Please ' 
      'input a List<String>, Map<String,String>, or String.');
  }

  @override
  String value(String name) {
    if(_headers.containsKey(name)){
      return _headers[name].join(', ');
    }else{
      return null;
    }
  }

}