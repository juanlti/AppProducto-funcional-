import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AuthServices extends ChangeNotifier {
  //url base a donde realizar la consulta
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyDjbksoo4x2YC0Myd0iEVeCtcUxkobYxa0';
  bool isLoading = false;

  final storage = FlutterSecureStorage();

// Read value

  //metodo de carga
  //si retornamos algo hay un error y por lo tanto no se creo el usuario
  // pero se retorna void o nada, se creo el usaurio y todo bien
  Future<String?> createUser(String email, String password) async {
    //mandar informacion a un POST

    //a) se envia como un mapa <algo,otroAlgo> CAPICH ? /:
    final Map<String, dynamic> accountSendApiRest = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      //key es del url y no de las llaves del backend
      'key': _firebaseToken,
    });
    print(' ANTES estoy el authServices');
    final receivedFromtheBackend =
        await http.post(url, body: json.encode(accountSendApiRest));
    final Map<String, dynamic> resPreceivedFromtheBackend =
        json.decode(receivedFromtheBackend.body);
    //token del usuario

    print('${resPreceivedFromtheBackend['idToken']}');
    print('estoy el authServices');
    print(
        'valor recibo del backend ${resPreceivedFromtheBackend.containsKey('idToken')}');
    final bool tieneIdTokenUser =
        resPreceivedFromtheBackend.containsKey('idToken');
    if (tieneIdTokenUser) {
      //guardar el tokenIdUser en un lugar seguro
      tieneIdTokenUser;
      storage.write(key: 'token', value: resPreceivedFromtheBackend['idToken']);
      return null;
    } else {
      return resPreceivedFromtheBackend['error']['message'];
    }
  }

//verifico cuenta de usuario

  Future<bool> verificarUsuario(String email, String password) async {
    //mandar informacion a un POST
    bool verificacionFalse = false;
    //a) se envia como un mapa <algo,otroAlgo> CAPICH ? /:
    final Map<String, dynamic> accountSendApiRest = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      //key es del url y no de las llaves del backend
      'key': _firebaseToken,
    });
    final respUserVerified =
        await http.post(url, body: json.encode(accountSendApiRest));
    final Map<String, dynamic> resPreceivedFromtheBackend =
        json.decode(respUserVerified.body);
    print('resultado de verificacion user ${resPreceivedFromtheBackend}');

    final bool tieneIdTokenUser =
        resPreceivedFromtheBackend.containsKey('idToken');
    print('token? ${tieneIdTokenUser}');
    if (tieneIdTokenUser) {
      //guardar el tokenIdUser en un lugar seguro
      //token del usuario

      print('token obtenido ${tieneIdTokenUser}');
      verificacionFalse = true;
      storage.write(key: 'token', value: resPreceivedFromtheBackend['idToken']);
    } else {
      resPreceivedFromtheBackend['error']['message'];
    }
    return verificacionFalse;
  }

  //borrar un token
  Future logout() async {
    print('valor del token ? ${storage}');
    await storage.delete(key: 'token');
    print('valor del null ?  ${storage}');
    //notifyListeners();
  }

  //leer un token
  Future<bool> readToken() async {
    bool res = false;
    String? resultado = await storage.read(key: 'token');

    if (resultado != null) {
      res = true;
    }
    print('estoy logeando ? ${res}');
    return res;
  }
}
