import 'dart:async';
import 'dart:math';


typedef DataListener<T> = FutureOr<void> Function(T data);
///=============================================================================
class DataNotifierService {
  static final Map<DataNotifierKey, List<DataListener>> _listenersMap = {};
  static final Map<DataNotifierKey, StreamController> _streams = {};

  DataNotifierService._();

  static DataNotifierKey generateKey(){
    return DataNotifierKey.by(_generateDateMill());
  }

  static String _generateDateMill(){
    return '${DateTime.now().toUtc().millisecondsSinceEpoch}';
  }

  static int getRandomInt(int min, int max){
    return Random().nextInt(max-min) + min;
  }

  static void addListener(DataNotifierKey key, DataListener func){
    if(!_listenersMap.containsKey(key)){
      _listenersMap[key] = <DataListener>[];
    }

    if(_listenersMap[key]!.contains(func)){
      return;
    }

    _listenersMap[key]?.add(func);
  }

  static void removeListener<T>(DataNotifierKey key, DataListener<T> func){
    if(!_listenersMap.containsKey(key)){
      return;
    }

    if(_listenersMap[key]!.remove(func)){
      return;
    }
  }

  static bool hasListener(DataNotifierKey key){
    if(!_listenersMap.containsKey(key)){
      return false;
    }

    return _listenersMap[key]!.isNotEmpty;
  }

  static void clearListenersFor(DataNotifierKey event){
    _listenersMap[event]?.clear();
  }

  static Stream<T> getStream<T>(DataNotifierKey key){
    if(!_streams.containsKey(key)){
      _streams[key] = StreamController<T>.broadcast();
    }

    return _streams[key]!.stream as Stream<T>;
  }

  static Future<void> notify(DataNotifierKey key, dynamic data) async {
    for (final ef in _listenersMap.entries) {
      if (ef.key == key) {
        for (final f in ef.value) {
          try {
            await f.call(data);
          }
          catch (e) {/**/}
        }
        break;
      }
    }

    for(final ef in _streams.entries){
      if(ef.key == key){
        try{
          ef.value.sink.add(data?? getRandomInt(10, 9999));
        }
        catch(e){/**/}
        break;
      }
    }
  }

  static Future<void> notifyFor(List<DataNotifierKey> keys, dynamic data) async {
    for(final k in keys){
      notify(k, data);
    }
  }
}
///=============================================================================
class DataNotifierKey {
  final String key;

  DataNotifierKey.by(this.key);
}
