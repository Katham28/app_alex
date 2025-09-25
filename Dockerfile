# Imagen oficial de Dart
FROM cirrusci/flutter:stable
# Crear directorio de trabajo
WORKDIR /app
# Copiar pubspec y resolver dependencias
COPY pubspec.* ./
RUN flutter pub get
# Copiar el resto del código
COPY . .
# Compilar a ejecutable nativo (opcional pero recomendado)
RUN flutter compile exe bin/server.dart -o bin/server
# Exponer puerto
EXPOSE 8080
# Comando de arranque
CMD ["bin/server"]