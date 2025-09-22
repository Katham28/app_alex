import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  late Db _db;
  bool _isConnected = false;

Future<void> connect() async {
   const connectionString = 'mongodb://jorgesanchez:Alfresi123@cluster0-shard-00-00.vsbti.mongodb.net:27017,'
                           'cluster0-shard-00-01.vsbti.mongodb.net:27017,'
                           'cluster0-shard-00-02.vsbti.mongodb.net:27017/'
                           'app_corazon?ssl=true&'
                           'replicaSet=atlas-14xs8f-shard-0&'
                           'authSource=admin&'
                           'retryWrites=true&'
                           'w=majority';
   
    try {
      print("Intentando conectar a MongoDB...");
      _db = Db(connectionString);
      
      // Conexión sin parámetros no soportados
      await _db.open();
      
      _isConnected = true;
      print('✅ Conexión a MongoDB establecida correctamente');
      
      // Verificar conexión con un ping
      final pingResult = await _db.runCommand({'ping': 1});
      print('Ping a MongoDB: ${pingResult['ok'] == 1 ? 'Éxito' : 'Fallo'}');
      
    } catch (e) {
      print('❌ Error al conectar a MongoDB: $e');
      
      // Detalles adicionales para diagnóstico
      if (e is MongoDartError) {
        //print('Código de error: ${e.code}');
        print('Mensaje detallado: ${e.message}');
      }
      
      // Cerrar conexión si está abierta parcialmente
      if (_isConnected) {
        await _db.close();
        _isConnected = false;
      }
      
      rethrow;
    }
  }


  Future<void> disconnect() async {
    if (_isConnected) {
      await _db.close();
      _isConnected = false;
      print('Conexión a MongoDB cerrada');
    }
  }

  // InsertOne retorna WriteResult
  Future<WriteResult> insertOne(String collectionName, Map<String, dynamic> document) async {
    _checkConnection();
    try {
      final collection = _db.collection(collectionName);
      return await collection.insertOne(document);
    } catch (e) {
      print('Error al insertar documento: $e');
      rethrow;
    }
  }

  // InsertMany retorna BulkWriteResult
  Future<BulkWriteResult> insertMany(
      String collectionName, List<Map<String, dynamic>> documents) async {
    _checkConnection();
    try {
      final collection = _db.collection(collectionName);
      return await collection.insertMany(documents);
    } catch (e) {
      print('Error al insertar múltiples documentos: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getPacientePorCorreo(String correo) async {
  _checkConnection();
  try {
    final collection = _db.collection('pacientes');
    final paciente = await collection.findOne(where.eq('correo', correo));
    return paciente;
  } catch (e) {
    print('Error al buscar paciente por correo: $e');
    rethrow;
  }
}




Future<WriteResult> updateOne(
    String collectionName, Map<String, dynamic> filter, Map<String, dynamic> update) async {
  _checkConnection();
  final collection = _db.collection(collectionName);

  // Construir el modificador aplicando set() por cada campo
  var m = modify;
  update.forEach((key, value) {
    m = m.set(key, value);
  });

  return await collection.updateOne(
    where.eq('email', filter['email']),
    m,
  );
}





  Future<List<Map<String, dynamic>>> find(
      String collectionName, [Map<String, dynamic>? filter]) async {
    _checkConnection();
    try {
      final collection = _db.collection(collectionName);
      var cursor = collection.find(filter ?? {});
      return await cursor.toList();
    } catch (e) {
      print('Error al buscar documentos: $e');
      rethrow;
    }
  }


Future<WriteResult> agregar_A_listado_Por_Correo(
String collectionName,  String correo, String namelistado,Map<String, dynamic> datos) async {
  _checkConnection();
  try {
    final collection = _db.collection(collectionName);

    return await collection.updateOne(
      where.eq('email', correo),
      modify..addToSet(namelistado, datos),
    );
  } catch (e) {
    print('Error al agregar paciente al médico: $e');
    rethrow;
  }
}


  
  

  // DELETE - MEJORADO
  Future<WriteResult> deleteOne(
      String collectionName, Map<String, dynamic> filter) async {
    _checkConnection();
    try {
      final collection = _db.collection(collectionName);
      return await collection.deleteOne(filter);
    } catch (e) {
      print('Error al eliminar documento: $e');
      rethrow;
    }
  }


  Future<int> count(String collectionName, [Map<String, dynamic>? filter]) async {
    _checkConnection();
    try {
      final collection = _db.collection(collectionName);
      return await collection.count(filter ?? {});
    } catch (e) {
      print('Error al contar documentos: $e');
      rethrow;
    }
  }

  void _checkConnection() {
    if (!_isConnected) {
      throw Exception('No hay conexión a la base de datos');
    }
  }
}