import 'package:flutter/material.dart';

void main() {
  runApp(const TacoExpressApp());
}

class TacoExpressApp extends StatelessWidget {
  const TacoExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TacoExpress',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
        useMaterial3: true,
      ),
      home: const InicioPage(),
    );
  }
}

// ==================== INICIO ====================

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.restaurant,
                  size: 100,
                  color: Colors.orange,
                ),

                const SizedBox(height: 20),

                const Text(
                  'TacoExpress',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  '¡Los mejores tacos hasta tu mesa!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MenuPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'VER MENÚ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== MENÚ ====================

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<Map<String, dynamic>> tacos = [
    {
      'nombre': 'Taco de Asada',
      'precio': 25.0,
      'icono': Icons.lunch_dining,
    },
    {
      'nombre': 'Taco de Pastor',
      'precio': 22.0,
      'icono': Icons.restaurant,
    },
    {
      'nombre': 'Taco de Pollo',
      'precio': 20.0,
      'icono': Icons.fastfood,
    },
    {
      'nombre': 'Taco de Chorizo',
      'precio': 23.0,
      'icono': Icons.local_fire_department,
    },
  ];

  final List<Map<String, dynamic>> carrito = [];

  void agregarAlCarrito(Map<String, dynamic> taco) {
    setState(() {
      final indice = carrito.indexWhere(
        (producto) => producto['nombre'] == taco['nombre'],
      );

      if (indice != -1) {
        carrito[indice]['cantidad']++;
      } else {
        carrito.add({
          'nombre': taco['nombre'],
          'precio': taco['precio'],
          'icono': taco['icono'],
          'cantidad': 1,
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${taco['nombre']} agregado al carrito'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  int cantidadTotalCarrito() {
    int cantidad = 0;

    for (var producto in carrito) {
      cantidad += producto['cantidad'] as int;
    }

    return cantidad;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menú TacoExpress',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        carrito: carrito,
                      ),
                    ),
                  );

                  setState(() {});
                },
              ),

              if (cantidadTotalCarrito() > 0)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cantidadTotalCarrito()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tacos.length,
        itemBuilder: (context, index) {
          final taco = tacos[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.all(15),

              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade100,
                child: Icon(
                  taco['icono'],
                  color: Colors.orange,
                ),
              ),

              title: Text(
                taco['nombre'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                '\$${taco['precio'].toStringAsFixed(2)} MXN',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),

              trailing: ElevatedButton(
                onPressed: () {
                  agregarAlCarrito(taco);
                },
                child: const Text('Agregar'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ==================== CARRITO ====================

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> carrito;

  const CartPage({
    super.key,
    required this.carrito,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void aumentarCantidad(int index) {
    setState(() {
      widget.carrito[index]['cantidad']++;
    });
  }

  void disminuirCantidad(int index) {
    setState(() {
      if (widget.carrito[index]['cantidad'] > 1) {
        widget.carrito[index]['cantidad']--;
      } else {
        widget.carrito.removeAt(index);
      }
    });
  }

  double calcularTotal() {
    double total = 0;

    for (var producto in widget.carrito) {
      total +=
          (producto['precio'] as double) *
          (producto['cantidad'] as int);
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Carrito',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: widget.carrito.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.carrito.length,
                    itemBuilder: (context, index) {
                      final producto = widget.carrito[index];

                      final double precio =
                          producto['precio'] as double;

                      final int cantidad =
                          producto['cantidad'] as int;

                      final double subtotal =
                          precio * cantidad;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 3,

                        child: Padding(
                          padding: const EdgeInsets.all(12),

                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor:
                                    Colors.orange.shade100,
                                child: Icon(
                                  producto['icono'],
                                  color: Colors.orange,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      producto['nombre'],
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      '\$${precio.toStringAsFixed(2)} MXN',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Text(
                                      'Subtotal: \$${subtotal.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.orange,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  disminuirCantidad(index);
                                                },
                                                icon: const Icon(
                                                  Icons.remove,
                                                  size: 18,
                                                ),
                                                color: Colors.orange,
                                              ),

                                              Text(
                                                '$cantidad',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),

                                              IconButton(
                                                onPressed: () {
                                                  aumentarCantidad(index);
                                                },
                                                icon: const Icon(
                                                  Icons.add,
                                                  size: 18,
                                                ),
                                                color: Colors.orange,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black12,
                      ),
                    ],
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        '\$${calcularTotal().toStringAsFixed(2)} MXN',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
