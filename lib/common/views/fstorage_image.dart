import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/services/fb_storage_provider.dart';

class FStorageImage extends ConsumerStatefulWidget {
  final String cloudImagePath;

  const FStorageImage({Key? key, required this.cloudImagePath}) : super(key: key);

  @override
  ConsumerState<FStorageImage> createState() => _FStorageImageState();
}

class _FStorageImageState extends ConsumerState<FStorageImage> {
  @override
  Widget build(BuildContext context) {
    final fbStorage = ref.watch(fbStorageProvider.notifier);

    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            {
              return const LinearProgressIndicator();
            }
          case ConnectionState.done:
            {
              if (!snapshot.hasData) {
                return const ImagePlaceholder();
              }
              final File imageFile = snapshot.data!;

              return Image.file(imageFile);
            }
          default:
            return const SizedBox.shrink();
        }
      },
      future: fbStorage.getFileDataFromFirebaseStorage(widget.cloudImagePath, false),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
