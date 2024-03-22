import 'package:cybernet/helpers/widget_helpers.dart';
import 'package:flutter/material.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  @override
  Widget build(BuildContext context) {
    return appPrincipal(
      titulo: 'Bienvenido a Cybernet',
      child: const Center(
        child: Text('Principal Page'),
      ),
    );
  }
}
