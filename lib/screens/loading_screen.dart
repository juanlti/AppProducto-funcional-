import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cargando, porfavor espere...'),
      ),
      body: Center(
        child: Container(
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Colors.red,
            value: 10,
          ),
        ),
      ),
    );
  }
}
