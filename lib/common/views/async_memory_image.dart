import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../providers/services/temp_storage_provider.dart';

File? tempFile;

class AsyncImageM extends ConsumerStatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final String name; // Unique name for this image

  const AsyncImageM({
    Key? key,
    required this.name,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 20,
    this.fit = BoxFit.fitWidth,
  }) : super(key: key);

  @override
  ConsumerState<AsyncImageM> createState() => _AsyncImageMState();
}

class _AsyncImageMState extends ConsumerState<AsyncImageM> {
  bool _loadingImage = true;
  Uint8List? imageData;
  final List<int> bytesData = List.empty(growable: true);
  double downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    // _loadImage();
    _downloadImage();
    // _downloadImageNew();
  }

  Future<void> _loadImage() async {
    setState(() => _loadingImage = true);

    if (tempFile != null) {
      imageData = await tempFile!.readAsBytes();
      setState(() => _loadingImage = false);
      return;
    }

    Uint8List bytes = (await NetworkAssetBundle(Uri.parse(widget.imageUrl)).load(widget.imageUrl)).buffer.asUint8List();
    saveDataToTempFileStorage(bytes);

    debugPrint("save file reference");

    setState(() {
      _loadingImage = false;
      imageData = bytes;
    });
  }

  void saveDataToTempFileStorage(Uint8List data) {
    final tempStorageUtil = ref.read(tempStorageProvider.notifier);
    tempStorageUtil.saveDataToLocalStorage(data).listen(
      (Map<String, dynamic> event) {
        tempFile = event['file'];
      },
      onDone: () {
        debugPrint("File saved");
      },
      onError: (error) {
        debugPrint("Error saving temp file: ${error.toString()}");
      },
    );
  }

  //
  Future<void> _downloadImage() async {
    setState(() => _loadingImage = true);

    if (tempFile != null) {
      imageData = await tempFile!.readAsBytes();
      bytesData.addAll(imageData!.toList());
      downloadProgress = 0;
      _loadingImage = false;
      setState(() {});
      return;
    }

    try {
      final request = http.Request('GET', Uri.parse(widget.imageUrl));
      final response = await http.Client().send(request);

      if (response.statusCode == 200) {
        response.stream.listen(
          (chunk) {
            setState(() {
              bytesData.addAll(chunk);
              if (response.contentLength != null) {
                downloadProgress += (chunk.length / response.contentLength!);
              }
            });
          },
          onError: (e) => debugPrint('Error occurred while downloading image: $e'),
          onDone: () {
            setState(() {
              _loadingImage = false;
              downloadProgress = 0;
            });
            saveDataToTempFileStorage(Uint8List.fromList(bytesData));
            debugPrint("Image data fetch success");
          },
        );
      } else {
        debugPrint('Image download failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error occurred while downloading image: $e');
    }
  }

  Future<void> _downloadImageNew() async {
    setState(() => _loadingImage = true);

    try {
      final response = await http.get(Uri.parse(widget.imageUrl));

      if (response.statusCode == 200) {
        setState(() {
          bytesData.addAll(response.bodyBytes);
          downloadProgress += response.bodyBytes.length;
          _loadingImage = false;
        });
        debugPrint("Image data fetch success");
      } else {
        debugPrint('Image download failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error occurred while downloading image: $e');
    }
  }

  @override
  void didUpdateWidget(AsyncImageM oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius - 1),
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: !_loadingImage && bytesData.isNotEmpty
                  ? Image.memory(
                      Uint8List.fromList(bytesData),
                      width: widget.width,
                      height: widget.height,
                      fit: widget.fit,
                    )
                  : Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: downloadProgress > 0
                            ? LinearProgressIndicator(
                                value: downloadProgress,
                              )
                            : const CircularProgressIndicator(),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
