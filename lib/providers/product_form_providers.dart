import 'package:flutter/material.dart';
import 'package:validator_form_dialog/model/product_model.dart';

class ProductFormProvider extends ChangeNotifier {
//estado global de producForm para llenar el formulario del producto
  GlobalKey<FormState> formKeyProductProvider = GlobalKey<FormState>();

//produc es una copia de la instancia selecionada
//por lo tanto las modificaciones en product no afectara a su copia, pq comparten diferentes referencias.
  late Product productTemp;

  ProductFormProvider(Product producSelect) {
    productTemp = producSelect;
  }
  String get nameProduc {
    return productTemp.name;
  }

  pickerImage(String imageSelect) {
    productTemp.picture = imageSelect;
    notifyListeners();
  }

/*
  set nameProduct(String pName) {
    productTemp.name = pName;
    notifyListeners();
  }
*/
  availableProduct(bool aValue) {
    print('valor inicial ${productTemp.available}');
    productTemp.available = aValue;
    notifyListeners();
    print('valor posterior ${productTemp.available}');
  }

  bool isValidForm() {
    print(
        'verifcacion correcta ? ${formKeyProductProvider.currentState?.validate()}');
    return formKeyProductProvider.currentState?.validate() ?? false;
  }
}
