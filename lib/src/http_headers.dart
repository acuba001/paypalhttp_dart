import 'dart:io';

class HttpPaypalHeaders extends HttpHeaders{

  final Map<String, List<String>> _headers;
  final Map<String, String> _lowerToKey;

  HttpPaypalHeaders(): 
    _headers = <String, List<String>>{},
    _lowerToKey = <String, String>{};

  @override
  List<String> operator [](String name) {
    return _headers[_lowerToKey[name.toLowerCase()]];
  }
  
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {
    final lower = name.toLowerCase();
    if(preserveHeaderCase){
      if(_lowerToKey.containsKey(lower)){
        _headers[name] = _headers[_lowerToKey[lower]];
        _headers.remove(_lowerToKey[lower]);
        _headers[name].add(value);
      }else{
        _headers.putIfAbsent(name, () => <String>[]).add(value.toString());
      }
      _lowerToKey[lower] = name;
    }else{
      _headers.putIfAbsent(lower, () => <String>[]).add(value.toString());
      _lowerToKey[lower] = lower;
    }
  }

  @override
  void clear() {
    _headers.clear();
    _lowerToKey.clear();
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
    final lower = name.toLowerCase();
    if(_lowerToKey.containsKey(lower)){
      _headers[_lowerToKey[lower]].remove(value.toString());
    }
  }

  @override
  void removeAll(String name) {
    final lower = name.toLowerCase();
    if(_lowerToKey.containsKey(lower)){
      _headers.remove(_lowerToKey[name.toLowerCase()]);
      _lowerToKey.remove(lower);
    }
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    final lower = name.toLowerCase();
    if(_lowerToKey.containsKey(lower)){
      _headers.remove(_lowerToKey[lower]);
    }
    _lowerToKey[lower] = name;
    _headers[name] = <String>[value.toString()];
  }

  @override
  String value(String name) {
    final values = _headers[_lowerToKey[name.toLowerCase()]];
    if (values == null) {
      return null;
    }
    return values.single;
  }

}