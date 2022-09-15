import 'package:flutter/material.dart';
import 'package:validator_form_dialog/model/product_model.dart';

class ProductoCard extends StatelessWidget {
  //aProduct es una instancia de la clase Produc
  final Product aProduct;

  const ProductoCard({super.key, required this.aProduct});
  @override
  Widget build(BuildContext context) {
    final sizeDisplay = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Container(
        width: sizeDisplay.width,
        height: 400,
        decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 7),
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(
              aProduct: aProduct,
            ),
            _boxDetailsBottom(
              subStutle: aProduct.id ?? 'no tiene informacion adicional',
              title: aProduct.name,
            ),
            Align(
                alignment: Alignment.topRight,
                child: _boxPriceTang(
                  aProduct: aProduct,
                )),
            Align(
                alignment: Alignment.topLeft,
                child: aProduct.available
                    ? null
                    : _isAvaible(
                        aProduct: aProduct,
                      )),
          ],
        ),
      ),
    );
  }
}

class _isAvaible extends StatelessWidget {
  final Product aProduct;

  const _isAvaible({super.key, required this.aProduct});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 100,
      child: FittedBox(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          'No Disponible',
          style: TextStyle(
              fontSize: 100, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )),
      decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
    );
  }
}

class _boxPriceTang extends StatelessWidget {
  final Product aProduct;

  const _boxPriceTang({super.key, required this.aProduct});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        color: Colors.indigo,
      ),
      width: 100,
      height: 70,
      child: FittedBox(
        //FittedBox server for responsovi  according to contents
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$${aProduct.price}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  final Product aProduct;

  const _BackgroundImage({super.key, required this.aProduct});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
          height: 400,
          width: 600,
          child: aProduct.picture != null
              ? FadeInImage(
                  placeholder: const AssetImage('assets/jar-loading.gif'),
                  image: NetworkImage('${aProduct.picture}'),
                  fit: BoxFit.cover
                  //fit: BoxFit.cover,
                  )
              : const Image(
                  image: AssetImage('assets/no-image.png'),
                  fit: BoxFit.cover,
                )),
    );
  }
}

class _boxDetailsBottom extends StatelessWidget {
  final String title;
  final String subStutle;

  const _boxDetailsBottom(
      {super.key, required this.title, required this.subStutle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 60),
      child: Container(
        padding: EdgeInsets.only(right: 150, top: 10),
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                topRight: Radius.circular(25))),
        child: Column(
          //BUSCAR LAS CONDICIONES DE TEXTOS
          children: [
            Text(
              '${title}',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.left,
            ),
            Text(
              '${subStutle}',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
