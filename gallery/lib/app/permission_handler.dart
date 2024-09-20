import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class PermissionHandler {
  Future<void> requestPermission() async {
    await [
      Permission.storage,
      Permission.camera,
      Permission.photos,
    ].request();
  }

  Future<void> checkStoragePermission() async {
    final status = await Permission.photos.status;
    if (status.isDenied) {
      print('Photos permission granted');
    }
  }

  Future<void> checkPhotosPermission() async {
    final status = await Permission.photos.status;
    if (status.isDenied) {
      print('Photos permission granted');
    }

    final ps = await PhotoManager
        .requestPermissionExtend(); // the method can use optional param `permission`.
    if (ps.isAuth) {
      final entities =
          await PhotoManager.getAssetListPaged(page: 0, pageCount: 10);
      print(entities);
    } else if (ps.hasAccess) {
      // Access will continue, but the amount visible depends on the user's selection.
    } else {
      await PhotoManager.openSetting();
    }
  }

  Future<void> checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      print('Camera permission granted');
    }
  }
}
