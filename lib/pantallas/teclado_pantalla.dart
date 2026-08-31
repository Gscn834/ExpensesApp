import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../modelos/gastos.dart';

class TecladoPantalla extends StatefulWidget {
  const TecladoPantalla({super.key});

  @override
  State<TecladoPantalla> createState() => _TecladoPantallaState();
}

class _TecladoPantallaState extends State<TecladoPantalla> {
  // Estado: Esta variable guarda que categoría está activa
  // 0 = Alimentacion, 1 = Transporte, 2 = Servicios, 3 = Otros
  int categoriaSeleccionada = 0;

  // 1. Nuestra memoria: Guardamos el monto ingresado en una variable de estado
  String montoIngresado = '0';

  // Variables nuevas para el formulario
  final conceptoController = TextEditingController();
  String categoriaSeleccionadaTexto = 'Otros'; // Valor por defecto

  @override
  void dispose() {
    conceptoController.dispose();
    super.dispose();
  }

  // 2. Logica: Funcion pra agregar numeros

  void agregarNumero(String numero) {
    setState(() {
      if (montoIngresado == '0' && numero != '.') {
        montoIngresado = numero; // Reemplaza el 0 con el primer numero ingresado
      } else if (montoIngresado.contains('.')&& numero == '.') {
        return; // Evita agregar un segundo punto decimal
      } else {
        // montoIngresado = montoIngresado + numero; // Agrega el nuevo número al final del monto ingresado
        montoIngresado += numero;
      }
    });
  }

  // 3. Logica: Funcion para borrar el ultimo numero
  void borrarUltimoNumero() {
    setState(() {
      if (montoIngresado.length > 1) {
        montoIngresado = montoIngresado.substring(0, montoIngresado.length - 1); // Elimina el último carácter
      } else {
        montoIngresado = '0'; // Si solo queda un dígito, lo reemplaza con 0
      }
    });
  }

  Widget _buildBotonTeclado(String texto) {
    return Expanded(
      child: TextButton(
          onPressed: () {
            if (texto == '⌫') {
              borrarUltimoNumero();
            } else {
              agregarNumero(texto);
            }
          },
          child: Text(
            texto,
            style: const TextStyle(fontSize: 28, color: Colors.black87),
          ),
        ),
      );
    }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Agregar Gasto',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),

            // Cantidad grande

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$ $montoIngresado',
                  style: const TextStyle(fontSize: 70, fontWeight: FontWeight.bold, height: 1),
                ),
                SizedBox(width: 8),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'USD',
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Categorías horizontales
            // Inicio Nuevo Formulario HIVE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: conceptoController,
                decoration: const InputDecoration(
                  labelText: 'Concepto',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: DropdownButtonFormField(
                initialValue: categoriaSeleccionadaTexto,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Alimentación', child: Text('Alimentación')),
                  DropdownMenuItem(value: 'Transporte', child: Text('Transporte')),
                  DropdownMenuItem(value: 'Servicios', child: Text('Servicios')),
                  DropdownMenuItem(value: 'Salud', child: Text('Salud')),
                  DropdownMenuItem(value: 'Otros', child: Text('Otros')),
                ],
                onChanged: (valor) {
                  if (valor != null) {
                    setState(() {
                      categoriaSeleccionadaTexto = valor;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 40),
            // Contenedor del teclado numérico gris
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(children: [_buildBotonTeclado('1'), _buildBotonTeclado('2'), _buildBotonTeclado('3')]),
                          Row(children: [_buildBotonTeclado('4'), _buildBotonTeclado('5'), _buildBotonTeclado('6')]),
                          Row(children: [_buildBotonTeclado('7'), _buildBotonTeclado('8'), _buildBotonTeclado('9')]),
                          Row(children: [_buildBotonTeclado('.'), _buildBotonTeclado('0'), _buildBotonTeclado('⌫')])
                        ],
                      ),
                    ),
                    // Botones con UX
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            // 1 Accion Principal
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final monto = double.tryParse(montoIngresado);
                                  if (monto == null || monto <= 0) return; // Validación simple: no permitir monto <= 0
                                  
                                  final concepto = conceptoController.text.trim().isEmpty
                                      ? 'Gasto'
                                      : conceptoController.text.trim();

                                  final caja = Hive.box<Gasto>('caja_gastos');
                                  final gasto = Gasto(
                                    concepto: concepto,
                                    monto: monto,
                                    categoria: categoriaSeleccionadaTexto,
                                    fecha: DateTime.now(),
                                  );

                                  await caja.add(gasto); // Guarda en Disco

                                  if (!context.mounted) return; // Verifica si el contexto sigue montado antes de navegar
                                  Navigator.pop(context); // Cierra la pantalla del teclado

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  '+ Agregar gasto',
                                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // 2 Accion Secundaria
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(fontSize: 18, color: Colors.black54),
                                ),
                              ),
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}