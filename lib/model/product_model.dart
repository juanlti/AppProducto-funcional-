import 'dart:convert';

class Product {
  Product(
      {required this.available,
      required this.name,
      this.picture,
      required this.price,
      this.id});

  bool available;
  String name;
  String? picture;
  double price;
  String? id;
/*
  factory Product.fromJson(String str) {
    return Product.fromMap(json.decode(str));
  }


*/
  factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"].toDouble(),
      );

  // creo  un constructor de   Product para que me devuelva una copia de la misma instancia selecionada,
  // por lo tanto son referencias distintas.

  Product copy() {
    return Product(
      available: this.available,
      name: this.name,
      price: this.price,
      id: this.id,
      picture: this.picture,
    );
  }

//El meotod toJson sirve para realizar el envio de un product y guardarlo en la bd

  //Orden de ejecucion n: 1
  //recibe un String y retorna un Json.String
  String toJson() => json.encode(toMap());

  //Orden de ejecucion n: 2
  //recibe un Json.String y retorna un toMapa

  Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
      };
}
