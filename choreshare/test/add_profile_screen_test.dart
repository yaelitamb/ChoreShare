import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:choreshare/database.dart';
import 'package:choreshare/models/profile.dart';
import 'package:choreshare/screens/add_profile.dart';

// Mock del servicio de base de datos
class MockChoreShareDatabase extends Mock implements ChoreShareDatabase {}

void main() {
  group('AddProfileScreen', () {
    testWidgets('Save Profile Test', (WidgetTester tester) async {
  // Mockear el servicio de base de datos
  final mockDatabase = MockChoreShareDatabase();

  // Configurar un directorio temporal para las imágenes (opcional)
  final Directory directory = await getTemporaryDirectory();
  final String tempImagePath = path.join(directory.path, 'temp_image.png');
  final File tempImageFile = File(tempImagePath);
  tempImageFile.createSync(recursive: true);

  // Construir el widget de prueba
  await tester.pumpWidget(
    MaterialApp(
      home: AddProfileScreen(),
    ),
  );

  // Interactuar con el botón 'Add Profile'
  await tester.tap(find.text('Add Profile'));
  await tester.pumpAndSettle(); // Esperar a que aparezca el diálogo

  // Completar los campos del diálogo
  await tester.enterText(find.byType(TextField), 'John Doe');
  await tester.tap(find.text('Red').last);
  await tester.pumpAndSettle();

  // Mockear la respuesta de insertProfile del servicio de base de datos
  when(mockDatabase.insertProfile(any)).thenAnswer((_) async => true);

  // Tocar el botón 'Save'
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();

  // Verificar que insertProfile fue llamado con los datos correctos del perfil
  verify(mockDatabase.insertProfile(Profile(
    id: anyNamed('id'), // Puedes usar 'anyNamed' para cualquier valor
    name: 'John Doe',
    color: 'Red',
    photo: tempImagePath, // Esto debería ser la ruta de la imagen seleccionada
  ))).called(1); // Verificar que insertProfile fue llamado exactamente una vez
});

}
