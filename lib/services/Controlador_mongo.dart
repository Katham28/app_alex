import 'package:mongo_dart/mongo_dart.dart';
import '../services/mongo.dart';
import '../models/Peticion.dart';

class Controlador_Mongo {
  final MongoService mongoService = MongoService();

  Future<void> connect() async {
    await mongoService.connect();
  }

  Future<void> disconnect() async {
    await mongoService.disconnect();
  }

  Future<WriteResult> insertOne(
      String collectionName, Map<String, dynamic> document) async {
    return await mongoService.insertOne(collectionName, document);
  }














  Future<int> findExistingUsuario2(String correo,String type) async {
    int band=0;
    print("buscando si existe: $correo en $type");
    if (type == 'paciente') {
        final resultadoPaciente = await mongoService.find('Paciente', {
        'email': correo,
        });

      if (resultadoPaciente.isNotEmpty) {
        band=1;
    }}
    else if (type == 'medico') {
      final resultadoMedico= await mongoService.find('Medico', {
        'email': correo,
      });

      if ( resultadoMedico.isNotEmpty) {
        band=1;
        }
    }


    return await band;
  }



  Future<int> findExistingUsuario(String correo) async {
    int band=0;

   final resultadoPaciente = await mongoService.find('Paciente', {
        'email': correo,
      });

      final resultadoMedico= await mongoService.find('Medico', {
        'email': correo,
      });



      if (resultadoPaciente.isNotEmpty || resultadoMedico.isNotEmpty) {
       // print('❌ Usuario preexistente');
        band=1;
      } else   {
        band=0; 
      }

    return await band;
  }

Future<bool> findClave_confirmacion(String clave) async {
  bool band=false;
  // Busca documentos donde 'clavesMedico' contenga el valor de 'clave'
      print("buscando si existe: $clave");
  final resultadoPaciente = await mongoService.find('Claves', {
    'clavesMedico': { '\$in': [clave] }  // convertir clave a string
  });

  print ("Resultado clave: $resultadoPaciente");

  if (resultadoPaciente != null && resultadoPaciente.isNotEmpty){
    print ("coincidencia de claves");
    band=true;
  }
  else{
    print ("NO coincidencia de claves");
    band=false;

  }


  return band;
}











  
  Future<BulkWriteResult> insertMany(
      String collectionName, List<Map<String, dynamic>> documents) async {
    return await mongoService.insertMany(collectionName, documents);
  }

  Future<List<Map<String, dynamic>>> find(
      String collectionName, [Map<String, dynamic>? filter]) async {
    return await mongoService.find(collectionName, filter);
  }

  Future<WriteResult> deleteOne(
      String collectionName, Map<String, dynamic> filter) async {
    return await mongoService.deleteOne(collectionName, filter);
  }

  Future<int> count(String collectionName, [Map<String, dynamic>? filter]) async {
    return await mongoService.count(collectionName, filter);
  }
}