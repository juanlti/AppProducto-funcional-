import 'package:provider/provider.dart';
import 'package:validator_form_dialog/model/product_model.dart';
import 'package:validator_form_dialog/screens/loading_screen.dart';
import 'package:validator_form_dialog/services/auth_services.dart';
import 'package:validator_form_dialog/services/product_services.dart';

import '../widgets/widgets.dart';
import 'check_auth_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // primer uso de productServicesProviders
    final providerAuthUser = Provider.of<AuthServices>(context, listen: false);
    final productServicesProviders = Provider.of<ProductsServices>(context);
    //isLoading  == true => se esta preparando el entorno visual con los datos obtenidos del servidor
    //por lo tanto la pantalla se encuentra en modo de carga
    print(productServicesProviders.isLoading);

    if (productServicesProviders.isLoading)
      return LoadingScreen(); //cambia de true/false automaticamente porque esta siendo escuchado por  notifyListeners();
    //isLoading  == false => el entorno visual ya esta listo para mostrar al usuario
    //por lo tanto se muestra los datos.
    print(productServicesProviders.isLoading);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        leading: IconButton(
          tooltip: 'Salirr',
          icon: const Icon(Icons.login_outlined),
          onPressed: () async {
            //espero a que la funcion .logout(), borre el token
            await providerAuthUser.logout();
            //una vez terminado, sigue la ejucion

            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: ListView.builder(
          itemCount: productServicesProviders.products.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              child: ProductoCard(
                aProduct: productServicesProviders.products[index],
              ),
              onTap: () {
                productServicesProviders.selectProduc =
                    productServicesProviders.products[index].copy();
                print(
                    'imagen ? ${productServicesProviders.selectProduc.picture}');

                Navigator.pushNamed(context, 'product');
              },
            );
          })),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          //creo una copia del producto que selecione
          productServicesProviders.selectProduc =
              Product(available: false, name: '', price: 00.00);

          Navigator.pushNamed(context, 'product');
          print('boton de +');
        },
      ),
    );
  }
}
