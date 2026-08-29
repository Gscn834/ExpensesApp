import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==========================================
              // BLOQUE 1: LA TARJETA DEL TOTAL
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [ // Quitamos el const general y lo dejamos solo para los textos internos
                    Text(
                      'Total Gastos hoy',
                      // OJO: Si dejas esto en Colors.white sobre el contenedor blanco, ¡será invisible!
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '\$14.250',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // ¡AQUÍ CERRAMOS EL CONTENEDOR! Todo lo de abajo ya está afuera.

              const SizedBox(height: 32),

              // ==========================================
              // BLOQUE 2: EL TÍTULO DE LA LISTA
              // ==========================================
              const Text(
                'Gastos de hoy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // ==========================================
              // BLOQUE 3: LA LISTA DE GASTOS
              // ==========================================
              Expanded(
                  child: ListView(
                    children: const [
                      _GastosCard(icono: '☕', nombre: 'Starbucks', categoria: 'Comidas & Bebidas', precio: '\$ 6.50', hora: '9:15 AM'),
                      _GastosCard(icono: '🚕', nombre: 'Uber', categoria: 'Transporte', precio: '\$2.75', hora: '11:30 AM'),
                      _GastosCard(icono: '🍽️', nombre: 'Almuerzo', categoria: 'Comidas & Bebidas', precio: '\$5.25', hora: '1:30 PM'),
                    ],
                  )
              ),
            ], // Aquí cerramos la columna principal
          ),
        ),
      ),
      // Nota: Aquí te faltó agregar el floatingActionButton que tenías antes, ¿quieres que lo volvamos a poner?
    );
  }
}

class _GastosCard extends StatelessWidget {
  final String icono;
  final String nombre;
  final String categoria;
  final String precio;
  final String hora;

  const _GastosCard({
    required this.icono,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.hora,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Text(
          icono,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(nombre),
        subtitle: Text(categoria),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(precio, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(hora, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}