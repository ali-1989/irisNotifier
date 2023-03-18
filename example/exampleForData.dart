import 'dart:async';

import '../lib/src/data_notifier_service.dart';
import 'publicAccess.dart';

class ExampleForDataNotifier {

  /// first, must add function(s) as listener
  static void dataNotifier$addListener(){
    DataNotifierService.addListener(PublicAccess.newDataNotifier, dataNotifierListener1);
    DataNotifierService.addListener(PublicAccess.newDataNotifier, dataNotifierListener2);
  }

  /// any time you feel not need to listening, can remove that
  static void dataNotifier$removeListener(){
    DataNotifierService.removeListener(PublicAccess.newDataNotifier, dataNotifierListener1);
    DataNotifierService.removeListener(PublicAccess.newDataNotifier, dataNotifierListener2);
  }

  /// Here you can publish data
  static void startNotifier(){
    Timer.periodic(Duration(seconds: 5), (timer) {
      //if(DataNotifierService.hasListener(PublicAccess.newDataNotifier)){
        DataNotifierService.notify(PublicAccess.newDataNotifier, {'hi' : 'user', 'tick' : '${timer.tick}'});
      //}
    });

  }

  static void dataNotifierListener1(data){
    if(data is Map){
      print('listener1: $data');
    }
  }

  static void dataNotifierListener2(data){
    if(data is Map){
      print('listener2: $data');
    }
  }

  /// this is alternative for using listener function
  static void startListening(){
    StreamSubscription? sub1;
    StreamSubscription? sub2;

    sub1 = DataNotifierService.getStream<Map>(PublicAccess.newDataNotifier).listen((data) {
      print('stream listener1: $data');
      sub1!.cancel();
    });

    sub2 = DataNotifierService.getStream<Map>(PublicAccess.newDataNotifier).listen((data) {
      print('stream listener2: $data');
      sub2!.cancel();
    });
  }
}