import 'package:flutter/material.dart';

Widget appPrincipal({required Widget child, required String titulo}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
      leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: const Image(image: AssetImage('assets/logo.png'), width: 100),
        ),
      ),
      title: Text(
        titulo,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      centerTitle: true,
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: child,
      ),
    ),
  );
}
