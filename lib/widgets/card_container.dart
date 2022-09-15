import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({Key? key, required this.fieldText}) : super(key: key);
  final Widget fieldText;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: _createCardShape(),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: fieldText,
      ),
    );
  }

  BoxDecoration _createCardShape() {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 15,
          offset: Offset(5, 25),
        ),
      ],
      borderRadius: BorderRadius.all(Radius.circular(15)),
      color: Colors.white,
    );
  }
}
