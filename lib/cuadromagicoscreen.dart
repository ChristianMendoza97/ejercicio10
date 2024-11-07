import 'package:flutter/material.dart';

class CuadradoMagicoScreen extends StatefulWidget {
  const CuadradoMagicoScreen({super.key});

  @override
  CuadradoMagicoScreenState createState() => CuadradoMagicoScreenState();
}

class CuadradoMagicoScreenState extends State<CuadradoMagicoScreen> {
  int M = 3;
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
                      content:
                          Text("Por favor, ingrese un número impar válido."),
                    ),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    M + 1,
              ),
              itemCount: (M * M) +
                  M +
                  1,
              itemBuilder: (context, index) {
                int row = index ~/ (M + 1);
                int col = index % (M + 1);

                if (col == M) {
                  int sumFila = cuadradoMagico[row].reduce((a, b) => a + b);
                  return Container(
                    color: Colors.blue[100],
                    child: Center(
                      child: Text(
                        '$sumFila',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }

                if (row == M) {
                  int sumColumna = 0;
                  for (int i = 0; i < M; i++) {
                    sumColumna += cuadradoMagico[i][col];
                  }
                  return Container(
                    color: Colors.green[100],
                    child: Center(
                      child: Text(
                        '$sumColumna',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () => _mostrarSumas(context, row, col),
                  child: Card(
                    child: Center(
                      child: Text(
                        '${cuadradoMagico[row][col]}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.orange[100],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Diagonal principal: ${sumarDiagonalPrincipal()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  color: Colors.purple[100],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Diagonal secundaria: ${sumarDiagonalSecundaria()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<List<int>> generarCuadradoMagico(int M) {
    List<List<int>> cuadrado = List.generate(M, (_) => List.filled(M, 0));
    int numero = 1;
    int i = 0;
    int j = M ~/ 2;

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

  int sumarDiagonalPrincipal() {
    int suma = 0;
    for (int i = 0; i < M; i++) {
      suma += cuadradoMagico[i][i];
    }
    return suma;
  }

  int sumarDiagonalSecundaria() {
    int suma = 0;
    for (int i = 0; i < M; i++) {
      suma += cuadradoMagico[i][M - i - 1];
    }
    return suma;
  }

  void _mostrarSumas(BuildContext context, int row, int col) {
    String filaSuma = '';
    int sumaFila = 0;
    for (int i = 0; i < M; i++) {
      filaSuma += '${cuadradoMagico[row][i]}';
      sumaFila += cuadradoMagico[row][i];
      if (i < M - 1) filaSuma += ' + ';
    }

    String columnaSuma = '';
    int sumaColumna = 0;
    for (int i = 0; i < M; i++) {
      columnaSuma += '${cuadradoMagico[i][col]}';
      sumaColumna += cuadradoMagico[i][col];
      if (i < M - 1) columnaSuma += ' + ';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sumas de la Fila y Columna'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fila ${row + 1}: $filaSuma = $sumaFila'),
              const SizedBox(height: 10),
              Text('Columna ${col + 1}: $columnaSuma = $sumaColumna'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
