import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_manager/photo_manager.dart';

class FirebaseController {
  final storage = FirebaseStorage.instance;
  Future<void> upload(AssetEntity assetFile) async {
    final storageRef = storage.ref('images');
    final imageRef = storageRef.child(assetFile.relativePath!);
    final file = await assetFile.file;
    await imageRef.putFile(file!);
  }

  Future<void> getPhotos() async {
    final storageRef = storage.ref('images');

    final listResult = await storageRef.listAll();
    print(listResult);
  }
}
