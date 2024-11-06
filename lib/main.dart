import 'package:flutter/material.dart';
import 'cuadromagicoscreen.dart';

void main() {
  runApp(const CuadradoMagicoApp());
}

class CuadradoMagicoApp extends StatelessWidget {
  const CuadradoMagicoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuadrado Mágico',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CuadradoMagicoScreen(),
    );
  }
}
