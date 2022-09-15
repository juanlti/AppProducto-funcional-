import 'package:provider/provider.dart';
import 'package:validator_form_dialog/UI/input_decorations.dart';
import 'package:validator_form_dialog/providers/login_form_providers.dart';

import 'package:validator_form_dialog/screens/screens.dart';
import 'package:validator_form_dialog/services/auth_services.dart';
import 'package:validator_form_dialog/services/notifications_services.dart';

import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: authBackgound(
        ShowForm: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: 200,
          ),
          CardContainer(
            fieldText: Column(
              children: [
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline4,
                ),
                ChangeNotifierProvider(
                  create: (_) {
                    return LoginFormProvider();
                  },
                  child: _loginForm(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 180,
          ),
          //RegisterScreen
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'register');
            },
            child: const Text('crear otra cuenta'),
          )
        ])),
      ),
    );
  }
}

class _loginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginFormValidator = Provider.of<LoginFormProvider>(context);
    final providerAuthUser = Provider.of<AuthServices>(context, listen: true);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: loginFormValidator.formKey,
        onChanged: () {},
        child: Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: InputDecorations.authInputDecoration(
                  IconsP: Icon(Icons.alternate_email_sharp,
                      color: Colors.deepPurple),
                  hintextP: 'Ejemplo: juan@hotmail.com',
                  labelTextP: 'correo electronico'),
              onChanged: (value) => loginFormValidator.email = value,
              validator: (value) {
                print('correo ingresado ${value}');
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = new RegExp(pattern);
                //her validator with regExp, if value is correct then regExp == null, also !=null ('vuelva a ingresar su email)
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'vuelva a ingresar su email';
              },
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: true,
              decoration: InputDecorations.authInputDecoration(
                  IconsP:
                      Icon(Icons.lock_clock_sharp, color: Colors.deepPurple),
                  hintextP: 'Ejemplo: juan12345',
                  labelTextP: 'clave'),
              onChanged: (value) {
                loginFormValidator.password = value;
                print('correcto? ${loginFormValidator.getClave}');
              },
              validator: (value) {
                return (value != null && value.length > 2)
                    ? null
                    : 'La clave es de ser 6 caracteres';
              },
            ),
            SizedBox(
              height: 30,
            ),
            MaterialButton(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                    child: loginFormValidator.isLoadingGet
                        ? CircularProgressIndicator(
                            color: Colors.deepPurple,
                          )
                        : Text(
                            'Ingresar',
                            style: TextStyle(color: Colors.white),
                          )),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.purple,
                onPressed: loginFormValidator.isLoadingGet
                    ? null
                    : () async {
                        final bool token =
                            await providerAuthUser.verificarUsuario(
                                loginFormValidator.email,
                                loginFormValidator.password);

                        if (token) {
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          print('estoy en login ${token}');
                          NotificationsSerices.showSnackbar(
                              'ERROR DE EMAIL, PORFAVOR INGRESE NUEVAMENTE');
                        }

                        print(
                            'esta validado ${loginFormValidator.formKey.currentState?.validate()}');
                        if (!loginFormValidator.isValidForm()) return;
                        print(
                            'correcto ${loginFormValidator.formKey.currentState}');
                        loginFormValidator.isLoadingSet = true;
                        print('correcto x2 ');
                        await Future.delayed(Duration(seconds: 2));

                        loginFormValidator.isLoadingSet = false;
                        print('estoy en login');
                      }),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
