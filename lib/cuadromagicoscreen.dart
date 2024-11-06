import 'package:flutter/material.dart';

class CuadradoMagicoScreen extends StatefulWidget {
  const CuadradoMagicoScreen({super.key});

  @override
  CuadradoMagicoScreenState createState() => CuadradoMagicoScreenState();
}

class CuadradoMagicoScreenState extends State<CuadradoMagicoScreen> {
  int M = 3; // Valor inicial de M
  List<List<int>> cuadradoMagico = [];

  @override
  void initState() {
    super.initState();
    cuadradoMagico = generarCuadradoMagico(M);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuadrado Mágico de $M x $M'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ingrese un número impar para M',
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                int? nuevoM = int.tryParse(value);
                if (nuevoM != null && nuevoM % 2 != 0 && nuevoM > 0) {
                  setState(() {
                    M = nuevoM;
                    cuadradoMagico = generarCuadradoMagico(M);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor, ingrese un número impar válido."),
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: M,
              ),
              itemCount: M * M,
              itemBuilder: (context, index) {
                int row = index ~/ M;
                int col = index % M;
                return Card(
                  child: Center(
                    child: Text(
                      '${cuadradoMagico[row][col]}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<List<int>> generarCuadradoMagico(int M) {
    // Inicialización del cuadrado mágico con ceros
    List<List<int>> cuadrado = List.generate(M, (_) => List.filled(M, 0));
    int numero = 1;
    int i = 0;
    int j = M ~/ 2;

    // Algoritmo para llenar el cuadrado mágico
    while (numero <= M * M) {
      cuadrado[i][j] = numero;
      numero++;

      int nuevaI = (i - 1 + M) % M;
      int nuevaJ = (j + 1) % M;

      if (cuadrado[nuevaI][nuevaJ] != 0) {
        i = (i + 1) % M;
      } else {
        i = nuevaI;
        j = nuevaJ;
      }
    }

    return cuadrado;
  }
}
