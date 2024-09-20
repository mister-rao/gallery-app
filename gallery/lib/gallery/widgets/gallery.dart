import 'package:flutter/material.dart';
import 'package:gallery/app/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final permissions = PermissionHandler();

  @override
  void initState() {
    permissions.checkPhotosPermission();
    getPhotos();
    super.initState();
  }

  Future<void> getPhotos() async {
    final paths = await PhotoManager.getAssetPathList();
    print('paths: $paths');
    final entities =
        await PhotoManager.getAssetListPaged(page: 0, pageCount: 10);
    print(entities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await permissions.checkCameraPermission();
            },
            icon: const Icon(Icons.camera),
          )
        ],
      ),
      body: GridView.builder(
        itemCount: 10,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.all(1),
          color: Colors.grey,
        ),
      ),
    );
  }
}
