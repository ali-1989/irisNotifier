import 'dart:async';

import '../lib/src/state_notifier.dart';
import 'publicAccess.dart';

enum StateList {
  error,
  wait,
  ok;
}

class StateStructure extends StateHolder<StateList> {
  bool isRequested = false;
  bool isInRequest = false;

  bool isOk(){
    return isRequested && !isInRequest && !hasStates({StateList.error, StateList.wait});
  }
}

class ExampleForStateNotifier {

  /// first, must add function(s) as listener
  static void stateNotifier$addListener(){
    PublicAccess.messageNotifier.addListener(listener);
  }

  /// any time you feel not need to listening, can remove that
  static void stateNotifier$removeListener(){
    PublicAccess.messageNotifier.removeListener(listener);
  }

  /// Here you can publish data
  static void startNotifier(){
    Timer.periodic(Duration(seconds: 5), (timer) {
      PublicAccess.messageNotifier.notify();
      PublicAccess.messageNotifier.notify(states: {StateList.ok}, data: 'any data');
    });
  }

  static void listener(StateNotifier notifier, {dynamic data}){
    if(notifier.states.hasState(StateList.ok)){
      //
    }
  }
}