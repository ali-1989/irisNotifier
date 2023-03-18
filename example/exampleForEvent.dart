import 'dart:async';

import '../lib/src/event_notifier_service.dart';

enum EventList implements EventImplement {
  networkConnected(100),
  networkDisConnected(101),
  networkStateChange(102),
  webSocketConnected(105),
  webSocketDisConnected(106),
  webSocketStateChange(107),
  userProfileChange(110),
  userLogin(111),
  userLogoff(112);

  final int _number;

  const EventList(this._number);

  int getNumber(){
    return _number;
  }
}

class ExampleForEventNotifier {

  /// first, must add function(s) as listener
  static void dataNotifier$addListener(){
    EventNotifierService.addListener(EventList.networkConnected, eventNotifierListener1);
    EventNotifierService.addListener(EventList.networkDisConnected, eventNotifierListener2);
  }

  /// any time you feel not need to listening, can remove that
  static void dataNotifier$removeListener(){
    EventNotifierService.removeListener(EventList.networkConnected, eventNotifierListener1);
    EventNotifierService.removeListener(EventList.networkDisConnected, eventNotifierListener2);
  }

  /// Here you can publish data
  static void startNotifier(){
    Timer.periodic(Duration(seconds: 5), (timer) {
      EventNotifierService.notify(EventList.networkConnected);
      EventNotifierService.notify(EventList.userLogin, data: {'name' : 'user-name'});
    });

  }

  static void eventNotifierListener1({data}){
    print('net is ok, $data');
  }

  static void eventNotifierListener2({data}){
    print('oh net is disconnect, $data');
  }

  /// this is alternative for using listener function
  static void startListening(){
    StreamSubscription? sub1;
    StreamSubscription? sub2;

    sub1 = EventNotifierService.getStream<Map>(EventList.userLogin).listen((data) {
      print('stream listener1: $data');
      sub1!.cancel();
    });

    sub2 = EventNotifierService.getStream<Map>(EventList.userLogin).listen((data) {
      print('stream listener2: $data');
      sub2!.cancel();
    });
  }
}