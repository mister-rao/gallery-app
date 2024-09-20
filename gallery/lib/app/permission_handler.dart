import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
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
  }

  Future<void> checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      print('Camera permission granted');
    }
  }
}
