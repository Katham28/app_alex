import 'package:flutter/material.dart';
import '../screens/Pantalla_Menu_Principal.dart';
//import '../screens/Pantalla_recuperar_cuenta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación_Alex',
      debugShowCheckedModeBanner: false,
      home: MenuPrincipal(),
      
    );
  }
}
