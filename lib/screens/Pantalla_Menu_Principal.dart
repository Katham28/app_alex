import 'package:flutter/material.dart';
//import '../screens/Pantalla_Crear_cuenta.dart';
import '../services/mongo.dart';
import '../services/AlexaConnector.dart';
import '../services/BackendConnector.dart';
class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  // Lista de filas (puede ser objetos o mapas)
    late AlexaConnector connector;
    String lastCommand = 'Ningún comando recibido aún';
    BackendConnector backendConnector = BackendConnector();



    @override
@override
void initState() {
  super.initState();
  backendConnector.start();

  backendConnector.peticionesStream.listen((lista) {
    setState(() {

    });
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text( 'Panel de enfermería', 
                              style: TextStyle( color: Colors.white, 
                              fontWeight: FontWeight.bold, 
                              fontSize: 20, letterSpacing: 1.2,
                              ), 
                               ), 
                      centerTitle: true, 
                      backgroundColor: Colors.blueAccent, 
                      elevation: 10, 
                      shadowColor: Colors.blue, 

                      toolbarHeight: 70, 
                      actions: [
                           /* IconButton(
                              icon: const Icon(Icons.refresh),
                              tooltip: 'Actualizar',
                              onPressed: () {
                                setState(() {
                                  // Ejemplo: recargar la lista de filas desde MongoDB o refrescar datos
                                   refrescar();
                                });
                              },
                            ), */
                          ],
                    ),
      body: SingleChildScrollView(
        child: Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: [
            // Encabezado
            TableRow(
              decoration: BoxDecoration(color: Colors.blueAccent.shade100),
              children: [
                buildCell("Usuario"),
                buildCell("Prioridad"),
                buildCell("Petición"),
                buildCell("Habitación"),
                buildCell("*"),
              ],
            ),
            // Filas dinámicas
            for (int i = 0; i < backendConnector.peticiones.length; i++)
              buildRow(
                backendConnector.peticiones[i].name,
                backendConnector.peticiones[i].prioridad,
                backendConnector.peticiones[i].peticion,
                backendConnector.peticiones[i].habitacion,
                onDelete: () {
                  setState(() {
                    backendConnector.peticiones.removeAt(i); // elimina la fila


                    if (backendConnector.peticiones.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No hay más peticiones.'),
                          backgroundColor: Colors.orange,
                        )
                      );
                    }
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Padding buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  TableRow buildRow(String nombre, int prioridad, String peticion, String habitacion,
      {required VoidCallback onDelete}) {
    String prioridadTexto = '';
    Color prioridadColor;

    if (prioridad == 0) {
      prioridadTexto = 'Alta';
      prioridadColor = Colors.redAccent;
    } else if (prioridad == 1) {
      prioridadTexto = 'Media';
      prioridadColor = Colors.yellowAccent;
    } else {
      prioridadTexto = 'Baja';
      prioridadColor = Colors.greenAccent;
    }

    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        // Nombre
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(nombre),
              const Icon(Icons.person, color: Colors.blueAccent, size: 30),
            ],
          ),
        ),
        // Prioridad
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(prioridadTexto),
              Icon(Icons.circle, color: prioridadColor, size: 30),
            ],
          ),
        ),
        // Petición
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(peticion),
        ),
        // Habitación
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(habitacion),
        ),
        // Botón borrar
        Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            onPressed: onDelete,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Icon(Icons.check, size: 20),
          ),
        ),
      ],
    );
  }
}
