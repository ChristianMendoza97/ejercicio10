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
                    M + 1, // Agregar una columna extra para las sumas
              ),
              itemCount: (M * M) +
                  M +
                  1, // Número total de celdas incluyendo las sumas
              itemBuilder: (context, index) {
                int row = index ~/ (M + 1); // Número de fila
                int col = index % (M + 1); // Número de columna

                // Mostrar las sumas de las filas a la derecha
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

                // Mostrar las sumas de las columnas al final de la última fila
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

                // Mostrar el número del cuadrado mágico
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
          // Aquí añadimos la suma de las diagonales
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Suma de la diagonal principal
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
                // Suma de la diagonal secundaria
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

  // Método para generar el cuadrado mágico
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

  // Método para sumar los elementos de la diagonal principal
  int sumarDiagonalPrincipal() {
    int suma = 0;
    for (int i = 0; i < M; i++) {
      suma += cuadradoMagico[i][i];
    }
    return suma;
  }

  // Método para sumar los elementos de la diagonal secundaria
  int sumarDiagonalSecundaria() {
    int suma = 0;
    for (int i = 0; i < M; i++) {
      suma += cuadradoMagico[i][M - i - 1];
    }
    return suma;
  }

  // Método para mostrar las sumas de la fila y columna al hacer clic
  void _mostrarSumas(BuildContext context, int row, int col) {
    // Sumar los valores de la fila
    String filaSuma = '';
    int sumaFila = 0;
    for (int i = 0; i < M; i++) {
      filaSuma += '${cuadradoMagico[row][i]}';
      sumaFila += cuadradoMagico[row][i];
      if (i < M - 1) filaSuma += ' + ';
    }

    // Sumar los valores de la columna
    String columnaSuma = '';
    int sumaColumna = 0;
    for (int i = 0; i < M; i++) {
      columnaSuma += '${cuadradoMagico[i][col]}';
      sumaColumna += cuadradoMagico[i][col];
      if (i < M - 1) columnaSuma += ' + ';
    }

    // Mostrar el cuadro emergente con las sumas
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sumas de la Fila y Columna'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fila ${row + 1}: $filaSuma = $sumaFila'),
              SizedBox(height: 10),
              Text('Columna ${col + 1}: $columnaSuma = $sumaColumna'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
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
