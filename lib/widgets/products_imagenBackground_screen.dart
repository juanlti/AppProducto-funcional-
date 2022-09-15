import 'dart:io';

import 'package:flutter/material.dart';

class ProductoImage extends StatelessWidget {
  final String? urlProducCopyImage;

  const ProductoImage({super.key, this.urlProducCopyImage});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Container(
        height: 450,
        decoration: _boxDecorationProductImage(),
        width: double.infinity,
        child: Opacity(
          opacity: 0.8,
          child: ClipRRect(
            //ClipRect sirve para mantener los bordes redondeados
            borderRadius: _borderRadiusImagenProduct(),
            child: getImage(urlProducCopyImage),
          ),
        ),
      ),
    );
  }

  BorderRadius _borderRadiusImagenProduct() {
    return BorderRadius.only(
        topLeft: Radius.circular(45), topRight: Radius.circular(45));
  }

  BoxDecoration _boxDecorationProductImage() {
    return BoxDecoration(
        color: Colors.red,
        borderRadius: _borderRadiusImagenProduct(),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5)),
        ]);
  }
}

//method
Widget getImage(String? urlProducCopyImage) {
  if (urlProducCopyImage == null) {
    return Image(
      image: AssetImage('assets/no-image.png'),
      fit: BoxFit.cover,
    );
  } else {
    if (urlProducCopyImage.startsWith('http')) {
      //imagen proveniente del servidor
      return FadeInImage(
        image: NetworkImage(urlProducCopyImage),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover,
      );
    }

    //imagen proveniente de la memoria del telefono

    return Image.file(
      File(urlProducCopyImage),
      fit: BoxFit.cover,
    );
  }
}
