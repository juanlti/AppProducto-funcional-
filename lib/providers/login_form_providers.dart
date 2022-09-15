import 'package:validator_form_dialog/widgets/widgets.dart';

class LoginFormProvider extends ChangeNotifier {
//Global key, servers for conection with formLogin and jobs data
//GlobalKey<FormFieldState> is need declared which one type. Example: GlobalKey<Scafoold>
  GlobalKey<FormFieldState> formKey = new GlobalKey<FormFieldState>();

  String email = '';
  String password = '';

  bool _isLoading = false;

  bool get isLoadingGet {
    return _isLoading;
  }

  String get getEmail {
    return email;
  }

  String get getClave {
    return password;
  }

  set isLoadingSet(bool newState) {
    _isLoading = newState;
    notifyListeners();
  }

  bool isValidForm() {
    print('validation ${formKey.currentState?.validate().toString()}');
    print('$email - $password');
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
/*
    print('resultado final ${formKey.currentState!.validate()}');
    print('esta cargado? $isLoadingGet');
    return formKey.currentState?.validate() == null ? true : false;
    */
  }
}
