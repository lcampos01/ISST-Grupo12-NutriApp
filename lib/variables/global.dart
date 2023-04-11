class GlobalVariables {
  static final GlobalVariables _instance = GlobalVariables._internal();

  factory GlobalVariables() => _instance;

  GlobalVariables._internal();

  String tokenUser = '';
  int isAdmin = 0; //no es admin
  String email = 'nombre@example.com';
  String password = 'contraseña';
  String username = 'Nombre';
  String sexo = 'hombre';
  String fechaNacimiento = DateTime.now().toString().split(" ")[0];
  int peso = 81;
  int altura = 192;
  int actividadFisica = 1;  //0:sedentario 1:moderado 2:activo
  List<String> alergenos = [];  //no ha seleccionado ningun alergeno
}

GlobalVariables globalVariables = GlobalVariables();





