class GlobalVariables {
  static final GlobalVariables _instance = GlobalVariables._internal();

  factory GlobalVariables() => _instance;

  GlobalVariables._internal();

  String ipVM = 'https://2.138.46.131:25565'; //'https://2.139.44.30:25566' para /favoritos
  String tokenUser = '';
}

GlobalVariables globalVariables = GlobalVariables();





