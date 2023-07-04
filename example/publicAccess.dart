
import 'package:iris_notifier/src/event_state_notifier.dart';

import '../lib/src/data_notifier_service.dart';
import 'exampleForState.dart';

class PublicAccess {
  PublicAccess._();

 static final newDataNotifier =  DataNotifierService.generateKey();
 static final newDataNotifier2 =  DataNotifierKey.by('myKey');

  static final StateStructure stateStructure = StateStructure();
  static final EventStateNotifier<StateStructure> messageNotifier = EventStateNotifier(stateStructure);
}