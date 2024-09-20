import 'package:flutter/material.dart';
import 'package:gallery/app/permission_handler.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final permissions = PermissionHandler();
  static const _pageSize = 10;

  final _pagingController = PagingController<int, String>(firstPageKey: 0);
  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    permissions.checkPhotosPermission();
    getPhotos();
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final images = [
        'Image_1',
        'Image_2',
        'Image_3',
        'Image_4',
      ];
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
      body: PagedGridView(
        pagingController: _pagingController,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) {
            return Container(
              margin: const EdgeInsets.all(1),
              color: Colors.grey,
            );
          },
        ),
      ),
    );
  }
}
