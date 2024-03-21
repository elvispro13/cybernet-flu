import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, required this.titulo});
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 50),
        width: 170,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: const Image(image: AssetImage('assets/logo.png')),
            ),
            AutoSizeText(
              titulo,
              maxLines: 1,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
