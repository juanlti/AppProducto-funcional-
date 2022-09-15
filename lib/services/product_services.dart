import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:validator_form_dialog/model/product_model.dart';
import 'package:http/http.dart' as http;

class ProductsServices extends ChangeNotifier {
  final String _baseUrl =
      'my-first-proyect-products-default-rtdb.firebaseio.com';

  final List<Product> products = [];
  bool isLoading = true;
  bool isSaving = false;

  final storage = FlutterSecureStorage();

// selectProduc es la instancia de una copia del producto selecionado
  late Product selectProduc;
  File? newPicturFile;
  ProductsServices() {
    this.loadProducts();
  }
  //cargar la instancia
  Future<List<Product>> loadProducts() async {
    this.isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl, 'products.json', {
      //SI NECESITO ENVIAR PARAMETROS DENTRO DE LA URL A DONDE VAMOS A REALIZAR LA CONSULTA,
      'auth': await storage.read(key: 'token') ?? ''
    });

    //first commit
    final resp = await http.get(url);
    final Map<String, dynamic> productMap = jsonDecode(resp.body);
    //productMap es la primera respuesta de nuestra peticion htpp
    //productMap es un mapa

    print('informaccion de base de datos ${productMap}');

    productMap.forEach((key, value) {
      //key : CoCaCola and value: Price, Name, picture
      //utilizo el consutructor de .fromMap porque  productMap es de tipo Mapa
      //otro ejemplo: si mi productMap es json entonces utilizo el constructor de .fromJson
      //voy a crear una instancia de Produc en la viariable unProducto, y la voy a inicializar con el metodo fromMap
      //fromMap inicializa los datos crudos recibidos desde la peticion htpps a los atributos de Product

      final unProducto = Product.fromMap(value);

      unProducto.id = key;
      products.add(unProducto);
    });
    this.isLoading = false;
    notifyListeners();
    print(this.products[0].name);
    return this.products;
  }

  Future saveOrCreateProduct(Product unProducSelect) async {
    isSaving = true;
    notifyListeners();

    if (unProducSelect.id != null) {
      //entonces modifico un producto

      await upDateProduct(unProducSelect);
    } else {
      // entonces debo crear un producto
      await createIdProducNew(unProducSelect);
    }
    isSaving = false;
    notifyListeners();
  }

  //realiza la peticion al backEnd
  //https://my-first-proyect-products-default-rtdb.firebaseio.com/products/
  Future<String> upDateProduct(Product unProduct) async {
    final url = Uri.https(_baseUrl, 'products/${unProduct.id}.json');
    final productCommit = await http.put(url, body: unProduct.toJson());
    final productCommitToMap = productCommit.body;

    print('producto: ${productCommitToMap}');

    final idIndexProducEncontrado =
        this.products.indexWhere((element) => element.id == unProduct.id);

    //actualizado

    this.products[idIndexProducEncontrado] = unProduct;

    return unProduct.id!;
  }

  //realiza la peticion al backEnd
  //este metodo recibe  del backEnd un id para un producto nuevo
  //recordar que un producto nuevo no tiene id, hay que generarlo
  Future<String> createIdProducNew(Product unProductNew) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final productCommit = await http.post(url, body: unProductNew.toJson());
    final newId = productCommit.body;
    print('id generado para el nuevo producto ${newId}}');

    unProductNew.id = newId;
    this.products.add(unProductNew);

    return '';
  }

  void updateSelectProductImage(String path) {
    // this.selectProduct.picture almacena internamente su imagen de path
    this.selectProduc.picture = path;

    //newPictuFile almacena la imagen en la nube
    newPicturFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPicturFile == null) return null;

    isSaving = true;
    notifyListeners();

    //una forma de peticion
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/products-app/image/upload?upload_preset=producsApp');

//cloudinary, exige que se indique el tipo de peticion y la dirrecion
//tipo de peticion: POST
//donde va a realizar la peticion ? url

//imageUpLoadRequest es la peticion a realizar
//file es el archivo

    final imageUpLoadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', newPicturFile!.path);

//ahora junto las los archivos, peticion + archivo

    imageUpLoadRequest.files.add(file);

    //realizo la activacion de la peticion, es decir enviar imageUpLoadRequest
    //metodo n: 1
    final streamResponse = await imageUpLoadRequest.send();
    final productCommit = await http.Response.fromStream(streamResponse);

    print(
        'informacion del archivo cargado en cloudinary:  ${productCommit.body}');
    print('estado ? ${productCommit.statusCode} ');

    this.newPicturFile = null;

    //mapeo la informacion recibida del backend para mostrarla en el telefono
    final decodeData = json.decode(productCommit.body);
    return decodeData['secure_url'];
  }
}
