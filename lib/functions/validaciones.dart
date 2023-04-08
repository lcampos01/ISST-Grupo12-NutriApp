/*Función para validar si una contraseña tiene 
mínimo 8 carácteres de los cuáles mínimo uno de 
ellos sea un número y otro una mayúscula
*/

bool validatePassword(String value) {
  final regex = RegExp(r'^(?=.*[A-Z])(?=.*[0-9]).{8,}$');
  return regex.hasMatch(value);
}

/*Función para validar si un correo y su dominio son válidos*/

bool validateEmail(String email) {
  // Validación básica para asegurarse de que el correo electrónico tenga una dirección y un dominio separados por un @
  if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
    return false;
  }

  // Dividir el correo electrónico en dirección y dominio
  final parts = email.split('@');
  final address = parts[0];
  final domainParts = parts[1].split('.');
  final domain = '${domainParts[0]}.${domainParts[1]}';

  // Validar la dirección y el dominio
  final addressRegExp = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  final domainRegExp = RegExp(r'^[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$');
  return addressRegExp.hasMatch(address) && domainRegExp.hasMatch(domain);
}
