import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:validator_form_dialog/model/product_model.dart';
import 'package:validator_form_dialog/providers/product_form_providers.dart';

import 'package:validator_form_dialog/services/product_services.dart';

import '../UI/input_decorations.dart';
import '../widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productServicesProviders = Provider.of<ProductsServices>(context);
    Product copyTempProduc = productServicesProviders.selectProduc;

    return ChangeNotifierProvider(
        create: (_) {
          return ProductFormProvider(copyTempProduc);
        },
        child: _ProductScreenBody(
          copyTempProduc: copyTempProduc,
        ));
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({Key? key, required this.copyTempProduc})
      : super(key: key);
  final copyTempProduc;
  @override
  Widget build(BuildContext context) {
    //con 'ChangeNotifierProvider' tengo acceso a clase ProductFormProvider en esta pagina
    //es decir, puedo acceder a los metodos con copyTempProduc
    final productServicesProviders = Provider.of<ProductsServices>(context);

    final productFromProvider = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              //Stack for two buttons with row

              children: [
                ProductoImage(
                    urlProducCopyImage:
                        productServicesProviders.selectProduc.picture),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      icon: _IconCustom(true),
                      onPressed: () {
                        //back pages
                        //Navigator.of(context).pop();
                      },
                    )),
                Positioned(
                    top: 60,
                    right: 30,
                    child: IconButton(
                      icon: _IconCustom(false),
                      onPressed: () async {
                        //camara o galeria
                        // Navigator.of(context).pop();
                        final photoPicker = new ImagePicker();
                        final XFile? aPickFile = await photoPicker.pickImage(
                            source: ImageSource.camera, imageQuality: 100);

                        if (aPickFile == null) {
                          return print('no existe ninguna imagen');
                        } else {
                          print('estoy adentro???');
                          productFromProvider.pickerImage(aPickFile.path);
                          print('Tenemos imagen ${aPickFile.path}');
                          productServicesProviders
                              .updateSelectProductImage(aPickFile.path);
                        }
                      },
                    ))
              ],
            ),
            _ProductForm(),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: productServicesProviders.isSaving
              ? null
              : () async {
                  if (productFromProvider.isValidForm()) {
                    //paso la validacion de expresiones regulares

                    final String? imageUrl =
                        await productServicesProviders.uploadImage();
                    print('url secure ${imageUrl}');
                    if (imageUrl != null) {
                      productServicesProviders.selectProduc.picture = imageUrl;
                    }
                    await productServicesProviders.saveOrCreateProduct(
                        productServicesProviders.selectProduc);
                  }
                },
          child: productServicesProviders.isSaving
              ? CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.indigo,
                )
              : Icon(Icons.save_outlined)),
    );
  }

  Widget _IconCustom(bool isBack) {
    return isBack
        ? Icon(
            Icons.arrow_back_ios_new,
            size: 40,
            color: Colors.white,
          )
        : Icon(Icons.camera_alt_outlined, size: 40, color: Colors.white);
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final producCurrent = productForm.productTemp;
//formKeyProductProvider
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Container(
          decoration: _boxDecorationForm(),
          padding: EdgeInsets.only(top: 10),
          child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: productForm.formKeyProductProvider,
              child: Wrap(
                runSpacing: 20,
                children: [
                  //NAME PRODUCTS

                  TextFormField(
                    initialValue: producCurrent.name,
                    onChanged: (value) {
                      producCurrent.name = value;
                    },
                    validator: (value) {
                      if ((value == null) || (value.length < 4))
                        return 'El nombre es obligatorio';
                    },
                    decoration: InputDecorations.authInputDecoration(
                        hintextP: 'Nombre del producto',
                        labelTextP: 'Nombre',
                        IconsP: null),
                  ),

                  //PRICE PRODUCTS

                  TextFormField(
                    initialValue: '${producCurrent.price}',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    onChanged: (value) {
                      if (double.tryParse(value) == null) {
                        producCurrent.price = 0;
                      } else {
                        producCurrent.price = double.parse(value);
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecorations.authInputDecoration(
                        hintextP: '\$150', labelTextP: 'Precio', IconsP: null),
                  ),
                  SwitchListTile(
                      activeColor: Colors.indigo,
                      title: Text('Disponible'),
                      value: producCurrent.available,
                      enableFeedback: true,
                      onChanged: ((value) {
                        productForm.availableProduct(value);
                      })),
                ],
              )),
        ));
  }
}

BoxDecoration _boxDecorationForm() {
  return BoxDecoration(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.005),
            blurRadius: 10,
            offset: Offset(0, 5)),
      ]);
}
