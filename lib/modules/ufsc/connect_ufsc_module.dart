import 'package:app_tcc/modules/base/module.dart';
import 'package:kiwi/kiwi.dart';

import 'ufsc_service.dart';

part 'connect_ufsc_module.g.dart';

abstract class ConnectUfscInjector {
  @Register.factory(UfscService)
  void configure();
}

class ConnectUfscModule extends Module {
  @override
  void setup() {
    var injector = _$ConnectUfscInjector();
    injector.configure();
  }
}
