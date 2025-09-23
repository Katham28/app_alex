# Imagen oficial de Dart
FROM dart:stable

# Crear directorio de trabajo
WORKDIR /app

# Copiar pubspec y resolver dependencias
COPY pubspec.* ./
RUN dart pub get

# Copiar el resto del código
COPY . .

# Compilar a ejecutable nativo (opcional pero recomendado)
RUN dart compile exe bin/server.dart -o bin/server

# Exponer puerto
EXPOSE 8080

# Comando de arranque
CMD ["bin/server"]
