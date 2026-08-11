import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Calcula correctamente el total del carrito', () {
    final productos = [
      {
        'nombre': 'Taco de Asada',
        'precio': 25.0,
        'cantidad': 2,
      },
      {
        'nombre': 'Taco de Pastor',
        'precio': 22.0,
        'cantidad': 1,
      },
    ];

    double total = 0;

    for (var producto in productos) {
      total +=
          (producto['precio'] as double) *
          (producto['cantidad'] as int);
    }

    expect(total, 72.0);
  });
}
