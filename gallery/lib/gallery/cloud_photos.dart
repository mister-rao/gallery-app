import 'package:flutter/material.dart';
import 'package:gallery/gallery/firebase_controller.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FirebasePhotos extends StatefulWidget {
  const FirebasePhotos({super.key});

  @override
  State<FirebasePhotos> createState() => _FirebasePhotosState();
}

class _FirebasePhotosState extends State<FirebasePhotos> {
  static const _pageSize = 10;
  final controller = FirebaseController();

  final _pagingController = PagingController<int, String>(firstPageKey: 0);
  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);

    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();

    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final images = ['Image 1'];
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
      appBar: AppBar(),
      body: PagedGridView(
        pagingController: _pagingController,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        builderDelegate: PagedChildBuilderDelegate<String>(
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
