import 'dart:async';

import 'package:iris_notifier/src/event_state_notifier.dart';

import 'publicAccess.dart';

enum EventList implements EventNotifyImplement {
  start,
  run,
  stop;
}

enum StateList {
  error,
  wait,
  ok;
}

class StateStructure extends StatesManager<StateList> {
  bool isRequested = false;
  bool isInRequest = false;

  bool isOk(){
    return isRequested && !isInRequest && !hasStates({StateList.error, StateList.wait});
  }
}
///=============================================================================
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

      PublicAccess.messageNotifier.addValue('myKey', timer.tick);
      PublicAccess.messageNotifier.notify(event: EventList.start);
    });
  }

  static void listener(EventStateNotifier notifier, EventNotifyImplement? event){
    if(notifier.stateManager.hasState(StateList.ok)){
      final tick = notifier.getValue('myKey');

      (notifier as StateStructure).isInRequest = true;
    }
  }
}