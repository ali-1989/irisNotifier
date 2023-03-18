#[![Dart CI](https://github.com/dart-lang/args/actions/workflows/test-package.yml/badge.svg)](https://github.com/dart-lang/args/actions/workflows/test-package.yml)
[![pub package](https://img.shields.io/pub/v/args.svg)](https://pub.dev/packages/args)

## Iris
#
This library is a notifier for Events,Data and States. in 3 separate classes.

This library works in both server-side and client-side apps. (Dart & Flutter)

#

### DataNotifierService

This service notify data to listeners.

First create a key:

```dart
class PublicAccess {
    PublicAccess._();

    static final newDataNotifier =  DataNotifierService.generateKey();
    // or
    static final newDataNotifier2 =  DataNotifierKey.by('myKey');
}
```

Then start using:

```dart
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
```
#
#
### EventNotifierService

This service notify to listeners when an event occurs.

First create an `enum` or a `class` that implement `EventImplement`:

```dart
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
```

Then start using:

```dart
class ExampleForEventNotifier {

  /// first, must add function(s) as listener
  static void eventNotifier$addListener(){
    EventNotifierService.addListener(EventList.networkConnected, eventNotifierListener1);
    EventNotifierService.addListener(EventList.networkDisConnected, eventNotifierListener2);
  }

  /// any time you feel not need to listening, can remove that
  static void eventNotifier$removeListener(){
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
```
#
#
### StateNotifier

This tool notifies to listeners and holds states.

First create a `class` that extends `StateHolder`:

```dart
enum StateList {
  error,
  wait,
  ok;
}

class StateStructure extends StateHolder<StateList> {
  bool isRequested = false;
  bool isRequesting = false;

  bool isOk(){
    return isRequested && !isRequesting && !hasStates({StateList.error, StateList.wait});
  }
}
```

Then create a StateNotifier:

```dart
class PublicAccess {
  PublicAccess._();
  
  static final StateStructure stateStructure = StateStructure();
  static final StateNotifier<StateStructure> stateNotifier = StateNotifier(stateStructure);
```

Then start using:

```dart
class ExampleForStateNotifier {

  /// first, must add function(s) as listener
  static void stateNotifier$addListener(){
    PublicAccess.stateNotifier.addListener(listener);
  }

  /// any time you feel not need to listening, can remove that
  static void stateNotifier$removeListener(){
    PublicAccess.stateNotifier.removeListener(listener);
  }

  /// Here you can publish data
  static void startNotifier(){
    Timer.periodic(Duration(seconds: 5), (timer) {
      PublicAccess.stateNotifier.notify();

      /// share a data
      PublicAccess.stateNotifier.addValue('myKey', timer.tick);
      
      /// notify with state(s) and data
      PublicAccess.stateNotifier.notify(states: {StateList.ok}, data: 'any data');
    });
  }

  static void listener(StateNotifier notifier, {dynamic data}){
    if(notifier.states.hasState(StateList.ok)){
      final tick = notifier.getValue('myKey');

      (notifier as StateStructure).isInRequest = true;
    }
  }
}
```


[pub]: https://pub.dev/

