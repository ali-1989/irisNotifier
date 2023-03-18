
import '../lib/src/data_notifier_service.dart';
import '../lib/src/state_notifier.dart';
import 'exampleForState.dart';

class PublicAccess {
  PublicAccess._();

 static final newDataNotifier =  DataNotifierService.generateKey();
 static final newDataNotifier2 =  DataNotifierKey.by('myKey');

  static final StateStructure stateStructure = StateStructure();
  static final StateNotifier<StateStructure> messageNotifier = StateNotifier(stateStructure);
}