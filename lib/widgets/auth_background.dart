import 'package:flutter/material.dart';

class authBackgound extends StatelessWidget {
  final Widget ShowForm;

  const authBackgound({super.key, required this.ShowForm});

  @override
  Widget build(BuildContext context) {
    final sizePhone = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _PurpleBox(context, sizePhone),
          _HeaderIcon(sizePhone: sizePhone),
          ShowForm,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
    required this.sizePhone,
  }) : super(key: key);

  final Size sizePhone;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        width: sizePhone.height,
        child: Icon(Icons.person_pin, color: Colors.white, size: 100),
      ),
    );
  }
}

Widget _PurpleBox(BuildContext context, Size sizePhone) {
  return Container(
    width: sizePhone.width,
    height: sizePhone.height * 0.4,
    decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
      Color.fromRGBO(63, 63, 156, 1),
      Color.fromRGBO(90, 70, 170, 1),
    ])),
    child: Stack(
      children: [
        //add _buble
        Positioned(child: _bubble(), top: 90, left: 30),
        Positioned(child: _bubble(), top: -40, right: -30),
        Positioned(child: _bubble(), top: -50, left: -30),
        Positioned(child: _bubble(), top: 120, right: 20),
      ],
    ),
  );
}

Widget _bubble() {
  return Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 0.05),
      borderRadius: BorderRadius.circular(100),
    ),
  );
}
