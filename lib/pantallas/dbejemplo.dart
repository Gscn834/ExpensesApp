import 'package:hive_flutter/hive_flutter.dart';

void demostracionHive() async {
    // 1. Abrir la Caja
    var caja = await Hive.openBox('gastos');

    //2. Guardar un gasto
    caja.put('nombre_usuario', 'Carlos');
    caja.put('saldo_actual', 150.50);

    //3. Leer un gasto
    String usuario = caja.get('nombre_usuario');

    // ignore: avoid_print
    print("Bienvenido $usuario, tu saldo actual es: ${caja.get('saldo_actual')}");
}
