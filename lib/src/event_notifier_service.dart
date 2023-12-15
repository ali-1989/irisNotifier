import 'dart:async';

typedef EventFunction = FutureOr<void> Function({dynamic data});
typedef MultiEventFunction = FutureOr<void> Function(EventImplement event, {dynamic data});
///=============================================================================
class EventNotifierService {
  static final List<MultiEventFunction> _multiListeners = [];
  static final Map<EventImplement, List<EventFunction>> _listenersMap = {};
  static final Map<EventImplement, StreamController> _streams = {};

  EventNotifierService._();

  static void addListener(EventImplement event, EventFunction func){
    if(!_listenersMap.containsKey(event)){
      _listenersMap[event] = <EventFunction>[];
    }

    if(_listenersMap[event]!.contains(func)){
      return;
    }

    _listenersMap[event]?.add(func);
  }

  static void addMultiListener(MultiEventFunction func){
    if(!_multiListeners.contains(func)){
      _multiListeners.add(func);
    }
  }

  static void removeListener(EventImplement event, EventFunction func){
    if(!_listenersMap.containsKey(event)){
      return;
    }

    if(_listenersMap[event]!.remove(func)){
      return;
    }
  }

  static void removeMultiListener(MultiEventFunction func){
    _multiListeners.remove(func);
  }

  static bool hasListener(EventImplement event){
    if(!_listenersMap.containsKey(event)){
      return false;
    }

    return _listenersMap[event]!.isNotEmpty;
  }

  static void clearListenersFor(EventImplement event){
    _listenersMap[event]?.clear();
  }

  static Stream<T> getStream<T>(EventImplement key){
    if(!_streams.containsKey(key)){
      _streams[key] = StreamController<T>.broadcast();
    }

    return _streams[key]!.stream as Stream<T>;
  }

  static Future<void> notify(EventImplement event, {dynamic data}) async {
    for (final ef in _listenersMap.entries) {
      if (ef.key == event) {
        for (final f in ef.value) {
          try {
            await f.call(data: data);
          }
          catch (e) {/**/}
        }
        break;
      }
    }

    for(final ef in _streams.entries){
      if(ef.key == event){
        try{
          ef.value.sink.add(data);
        }
        catch(e){/**/}
        break;
      }
    }

    for(final lis in _multiListeners){
      try{
        await lis.call(event, data: data);
      }
      catch(e){/**/}
    }
  }

  static Future<void> notifyFor(List<EventImplement> events, {dynamic data}) async {
    for(final e in events){
      await notify(e, data: data);
    }
  }
}
///=============================================================================
class EventImplement {
}

