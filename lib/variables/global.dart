class GlobalVariables {
  static final GlobalVariables _instance = GlobalVariables._internal();

  factory GlobalVariables() => _instance;

  GlobalVariables._internal();

  String ipVM = 'https://2.138.46.131:25565'; 
  String tokenUser = '';
}

GlobalVariables globalVariables = GlobalVariables();





