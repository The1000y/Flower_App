import 'package:flower_app/core/services/image_picker_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  late MockImagePicker picker;
  late ImagePickerServiceImpl service;

  setUp(() {
    picker = MockImagePicker();
    service = ImagePickerServiceImpl(picker);
  });

  test('returns the picked file path', () async {
    when(() => picker.pickImage(source: ImageSource.gallery))
        .thenAnswer((_) async => XFile('/tmp/me.jpg'));

    expect(await service.pickFromGallery(), '/tmp/me.jpg');
  });

  test('returns null when the user cancels', () async {
    when(() => picker.pickImage(source: ImageSource.gallery))
        .thenAnswer((_) async => null);

    expect(await service.pickFromGallery(), isNull);
  });

  test('returns null when the plugin throws', () async {
    when(() => picker.pickImage(source: ImageSource.gallery))
        .thenThrow(Exception('plugin failure'));

    expect(await service.pickFromGallery(), isNull);
  });
}