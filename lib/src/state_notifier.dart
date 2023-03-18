

typedef StateListener<T> = void Function(StateNotifier notifier, {T? data});
///==============================================================================
class StateNotifier<SH extends StateHolder> {
  late final SH states;
  final Map<String, dynamic> stores = {};
  final List<StateListener> _listeners = [];

  StateNotifier(this.states);

  void addListener(StateListener func){
    if(!_listeners.contains(func)){
      _listeners.add(func);
    }
  }

  void removeListener(StateListener func){
    _listeners.remove(func);
  }

  void clearListeners(){
    _listeners.clear();
  }

  void notify({Set? states, dynamic data}){
    if(states != null) {
      this.states._states.addAll(states);
    }

    for(final ef in _listeners){
      try{
        ef.call(this, data: data);
      }
      catch (e){}
    }
  }

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
///=============================================================================
class StateHolder<S> {
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