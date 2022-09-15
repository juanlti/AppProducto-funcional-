import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:validator_form_dialog/screens/home_screen.dart';
import 'package:validator_form_dialog/screens/login_screen.dart';
import 'package:validator_form_dialog/services/auth_services.dart';

class CheckAuthScreen extends StatelessWidget {
  CheckAuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Se redibuja ? No.
    final providerAuthUser = Provider.of<AuthServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cargando sistema, porfavor espere'),
      ),
      body: FutureBuilder(
        future: providerAuthUser.readToken(),
        //recordar que, FutureBuilder tiene que retornar(o terminar la construccion del mismo), con Widget, para navagar a otro lugar, como venimos haciendo
        //va dar error porque  ejemplo Navigagor.pop,
        //la app se va a romper porque, el widget en este Navigator se va ejecutar miliismas de secundos antes de que terminar
        //el Future builder
        //en otras palabras se va ejecutar una navegacion sin haber terminado la ejecucion del FutureBuilder

        // SOlucion?
        // Future.microtask, este sirve para ejecutar una navegacion a otro widget, apenas termine el  FutureBuilder.
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          // recordar que,  snapshot.hasData accedo al contenido, es null o objetct
          //recordar que , snapshot.data accede al contenido que se le asigno en el metodo de readToken(), siendo este un true/false

          //tiene datos? null o obtject

          if (!snapshot.hasData) {
            //!snapshot.hasData es igual a null, es decir no tiene datos, ento
            // Navigator.pushReplacementNamed(context, 'login');
           return  Center(child: Text('Espereeee'));
          
                
                //  providerAuthUser.logout();

                //opc n: 2
                // pushReplacementNamed poco agradable,
                // Navigator.pushReplacementNamed(context, 'home');
              
            
          }

          //!snapshot.hasData es igual a un Object, es decir tiene datos

          
          if (snapshot.data! == true) {
            Duration(seconds: 10);
            //el usuario estaba logeado previamiente
            // snapshot.data tiene un token, faltaria validar si ese token esta caducado o modicado
            Future.microtask(
              () {
                //opc n: 1
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => HomeScreen(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );
                //  providerAuthUser.logout();

                //opc n: 2
                // pushReplacementNamed poco agradable,
                // Navigator.pushReplacementNamed(context, 'home');
              },
            );
          }
          if (snapshot.data! == false) {
            Duration(seconds: 10);
            //el usuario no estaba logeado, debe hacerlo!
            // snapshot.data no tiene un token, faltaria validar si ese token esta caducado o modicado
            //login

            Future.microtask(
              () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => LoginScreen(),
                    transitionDuration: Duration(seconds: 0),
                  ),
                );

                // Navigator.pushReplacementNamed(context, 'login');
              },
            );
          }
          //este ultimo return no se ejecuta, se encuentra implementado para darle ejecucion al Future.Builder
          return Container();
        },
      ),
    );
  }
}
