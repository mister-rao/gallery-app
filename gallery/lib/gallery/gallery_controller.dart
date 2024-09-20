import 'package:gallery/gallery/firebase_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryController {
  final firebase = FirebaseController();
  static const pageSize = 20;
  final ImagePicker picker = ImagePicker();
  Future<List<AssetEntity>> getImages(int page) async {
    return PhotoManager.getAssetListPaged(page: 0, pageCount: pageSize);
  }

  Future<void> launchCamera() async {
    final file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      final image = await PhotoManager.editor.saveImage(
        await file.readAsBytes(),
        title: 'write_your_own_title.jpg',
        filename: getFileName(),
      );
      await firebase.upload(image!);
    }
  }

  String getFileName() {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);
    return 'gallery_$date';
  }
}
