import 'package:flutter/material.dart';
import 'package:gallery/app/permission_handler.dart';
import 'package:gallery/gallery/cloud_photos.dart';
import 'package:gallery/gallery/gallery_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final permissions = PermissionHandler();
  static const _pageSize = 10;
  final controller = GalleryController();

  final _pagingController = PagingController<int, AssetEntity>(firstPageKey: 0);
  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    permissions.requestPermission();

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();

    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final images = await controller.getImages(pageKey);
      final isLastPage = images.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(images);
      } else {
        final nextPageKey = pageKey + images.length;
        _pagingController.appendPage(images, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await controller.launchCamera().then(
                (value) {
                  _pagingController.refresh();
                },
              );
            },
            icon: const Icon(Icons.camera),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FirebasePhotos()),
              );
            },
            icon: const Icon(Icons.cloud),
          ),
        ],
      ),
      body: PagedGridView(
        pagingController: _pagingController,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        builderDelegate: PagedChildBuilderDelegate<AssetEntity>(
          itemBuilder: (context, item, index) {
            return Container(
              margin: const EdgeInsets.all(1),
              color: Colors.grey,
              child: Image(
                fit: BoxFit.cover,
                image: AssetEntityImageProvider(item, isOriginal: false),
              ),
            );
          },
        ),
      ),
    );
  }
}
