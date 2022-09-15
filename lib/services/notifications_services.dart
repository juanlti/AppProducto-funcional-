import 'package:flutter/material.dart';

class NotificationsSerices {
//la classe NotificationsSerices, no necesita redibujar a nadie.
//por esa razon no se extiende de ningun tipo

//messengerKey va ser globalKey es decir que cualquier lugar se puede llamar y se va a compar de forma unico
//por ser key.

  static GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final SnackBar snackBar = SnackBar(
        content: Text(
      message,
      style: TextStyle(color: Colors.red, fontSize: 20),
    ));
    //snackBar es el contenido  y este puede ser customizado segun quien lo llame

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
