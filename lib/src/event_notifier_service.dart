import 'dart:async';

typedef EventFunction = void Function({dynamic data});
typedef MultiEventFunction = void Function(EventImplement event, {dynamic data});
///==============================================================================
class EventNotifierService {
  static final List<MultiEventFunction> _listeners = [];
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
    if(!_listeners.contains(func)){
      _listeners.add(func);
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
    _listeners.remove(func);
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

  static void notify(EventImplement event, {dynamic data}){
    for (final ef in _listenersMap.entries) {
      if (ef.key == event) {
        for (final f in ef.value) {
          try {
            f.call(data: data);
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

    for(final lis in _listeners){
      try{
        lis.call(event, data: data);
      }
      catch(e){/**/}
    }
  }

  static void notifyFor(List<EventImplement> events, {dynamic data}){
    for(final e in events){
      notify(e, data: data);
    }
  }
}
///==============================================================================
class EventImplement {
}

