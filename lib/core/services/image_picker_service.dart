import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract interface class ImagePickerService {
  Future<String?> pickFromGallery();
}

@LazySingleton(as: ImagePickerService)
class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker;

  ImagePickerServiceImpl(this._picker);

  @override
  Future<String?> pickFromGallery() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      return picked?.path;
    } catch (_) {
      return null;
    }
  }
}

@module
abstract class ImagePickerModule {
  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();
}