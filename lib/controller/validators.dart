
class Validators {



  static String validateName(String value) {
    if (value.length < 3)
      return 'Nome deve ter pelo menos tres caracteres';
    else
      return null;
  }

  static String validatePassword(String value) {

    if (value.length <5)
      return 'Palavra passe tem que ter pelo menos 6 digitos';
    else
      return null;
  }

  static String validateMobile(String value) {
    if (value.length <8 )
      return 'Numero do telefone deve ter 9 digit';
    else
      return null;
  }
  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  }

