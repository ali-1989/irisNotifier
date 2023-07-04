import 'dart:async';

typedef EventListener<S> = void Function(EventStateNotifier notifier, EventNotifyImplement? event);
///==============================================================================
class EventStateNotifier<S extends StatesManager> {
  late final S _states;
  final Map<String, dynamic> stores = {};
  final List<EventListener> _listeners = [];
  final Map<EventNotifyImplement, StreamController> _streams = {};

  EventStateNotifier(S stateManager): this._states = stateManager;

  void addListener(EventListener func){
    if(!_listeners.contains(func)){
      _listeners.add(func);
    }
  }

  void removeListener(EventListener func){
    _listeners.remove(func);
  }

  void clearListeners(){
    _listeners.clear();
  }

  S get stateManager {
    return _states;
  }

  Stream<T> getStream<T>(EventNotifyImplement key){
    if(!_streams.containsKey(key)){
      _streams[key] = StreamController<T>.broadcast();
    }

    return _streams[key]!.stream as Stream<T>;
  }

  void notify({EventNotifyImplement? event}){
    for(final lis in _listeners){
      try{
        lis.call(this, event);
      }
      catch(e){/**/}
    }

    for(final ef in _streams.entries){
      if(ef.key == event){
        try{
          ef.value.sink.add(null);
        }
        catch(e){/**/}
        break;
      }
    }
  }

  void notifyFor(List<EventNotifyImplement> events){
    for(final e in events){
      notify(event: e);
    }
  }
  ///------------------------------------------------
  void addValue(String key, dynamic value){
    stores[key] = value;
  }

  void removeValue(String key){
    stores.remove(key);
  }

  dynamic getValue(String key){
    if(existKey(key)) {
      return stores[key];
    }

    return null;
  }

  bool existKey(String key){
    return stores.containsKey(key);
  }

  void clearValues(){
    stores.clear();
  }
}
///==============================================================================
class EventNotifyImplement {
}
///==============================================================================
class StatesManager<S> {
  final Set<S> _states = {};

  Set<S> getStates(){
    return _states;
  }

  void addState(S state){
    _states.add(state);
  }

  void addStates(Set<S> states){
    _states.addAll(states);
  }

  void removeState(S state){
    _states.remove(state);
  }

  void clearStates(){
    _states.clear();
  }

  bool hasState(S state){
    return _states.contains(state);
  }

  bool hasStates(Set<S> states){
    for(final x in states){
      if(!_states.contains(x)){
        return false;
      }
    }

    return true;
  }
}
