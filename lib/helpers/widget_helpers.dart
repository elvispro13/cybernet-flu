import 'package:flutter/material.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

Widget appPrincipal({required Widget child, required String titulo}) {
  return Scaffold(
    key: _scaffoldKey,
    drawer: Drawer(
      child: Container(
        color: Colors.white,
      ),
    ),
    appBar: AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer();
        },
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: const Image(image: AssetImage('assets/logo.png'), width: 50),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: child,
      ),
    ),
  );
}
