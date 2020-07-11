import 'dart:io';

class HttpPaypalHeaders extends HttpHeaders{

  final Map<String, List<String>> _headers;

  HttpPaypalHeaders(): 
    _headers = <String, List<String>>{};

  @override
  List<String> operator [](String name) {
    var lower = name.toLowerCase();
    if(_headers.containsKey(lower)){
      return List<String>.from(_headers[lower]);
    }
    return null;
  }
  
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    var lower = name.toLowerCase();
    if(value is List<String>){
      if(_headers.containsKey(lower)){
        _headers[lower].addAll(value);
      }else{
        _headers[lower] = List<String>.from(value);
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
      if(_headers.containsKey(lower)){
        _headers[lower].addAll(out);
      }else{
        _headers[lower] = out;
      }
      return;
    } 
    if(value is String){
      if(_headers.containsKey(lower)){
        _headers[lower].add(value);
      } else{
        _headers[lower] = <String> [value];
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
    var lower = name.toLowerCase();
    if(value is List<String>){
      _headers[lower].removeWhere((s) => value.contains(s));
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
      remove(lower, out);
      return;
    } 
    if(value is String){
      _headers[lower].remove(value);
      return;
    }
    throw Exception('Value type for Header.add unexpected. Please ' 
      'input a List<String>, Map<String,String>, or String.');
  }

  @override
  void removeAll(String name) {
    var lower = name.toLowerCase();
    _headers.remove(lower);
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    var lower = name.toLowerCase();
    if(value is List<String>){
      _headers[lower] = List<String>.from(value);
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
      _headers[lower] = out;
      return;
    } 
    if(value is String){
      _headers[lower] = <String> [value];
      return;
    }
    throw Exception('Value type for Header.add unexpected. Please ' 
      'input a List<String>, Map<String,String>, or String.');
  }

  @override
  String value(String name) {
    var lower = name.toLowerCase();
    if(_headers.containsKey(lower)){
      return _headers[lower].join(', ');
    }else{
      return null;
    }
  }

}