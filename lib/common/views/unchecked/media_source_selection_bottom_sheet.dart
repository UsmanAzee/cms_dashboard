import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum MediaSource {
  photoGallery,
  videoGallery,
  camera,
}

class UserMediaSelection {
  MediaSource? mediaSource;
  bool clearSelections;

  UserMediaSelection({
    this.clearSelections = false,
    this.mediaSource,
  });
}

class MediaSourceSelectionBottomSheet extends StatefulWidget {
  final bool allowPhoto;
  final bool allowVideo;
  final bool showClearOption;

  const MediaSourceSelectionBottomSheet({
    Key? key,
    this.allowPhoto = true,
    this.allowVideo = false,
    this.showClearOption = false,
  }) : super(key: key);

  @override
  State<MediaSourceSelectionBottomSheet> createState() => _MediaSourceSelectionBottomSheetState();
}

class _MediaSourceSelectionBottomSheetState extends State<MediaSourceSelectionBottomSheet> {
  void onSelect(MediaSource? mediaSource, [bool clear = false]) {
    Navigator.pop(context, UserMediaSelection(clearSelections: clear, mediaSource: mediaSource));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    List<Widget> options = [];

    if (widget.allowPhoto && widget.allowVideo) {
      options.addAll([
        ListOption(
          title: 'Gallery (Photo)',
          subtitle: "Select an image from gallery.",
          onTap: () => onSelect(MediaSource.photoGallery),
          icon: Icons.photo_library_outlined,
        ),
        const Divider(),
        ListOption(
          title: 'Gallery (Video)',
          subtitle: "Select a video file from gallery.",
          onTap: () => onSelect(MediaSource.videoGallery),
          icon: Icons.video_file_outlined,
        ),
      ]);
    }

    if (widget.allowPhoto && !widget.allowVideo) {
      options.add(ListOption(
        title: 'Gallery',
        subtitle: "Select an image from gallery.",
        onTap: () => onSelect(MediaSource.photoGallery),
        icon: Icons.photo_library_outlined,
      ));
    }

    if (!widget.allowPhoto && widget.allowVideo) {
      options.add(ListOption(
        title: 'Gallery',
        subtitle: "Select a video file from gallery.",
        onTap: () => onSelect(MediaSource.videoGallery),
        icon: Icons.video_file_outlined,
      ));
    }

    options.addAll([
      const Divider(),
      ListOption(
        title: 'Camera',
        subtitle: "Snap a picture and select.",
        onTap: () => onSelect(MediaSource.camera),
        icon: Icons.photo_camera,
      ),
      const Divider(),
    ]);

    if (widget.showClearOption) {
      options.addAll([
        ListOption(
          title: 'Clear',
          subtitle: "Clear selected media",
          onTap: () => onSelect(null, true),
          icon: Icons.remove_circle_outline,
        ),
        const Divider(),
      ]);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: ListTile(
              contentPadding: const EdgeInsets.all(0),
              visualDensity: VisualDensity.compact,
              title: Text(
                'Select Source',
                textAlign: TextAlign.center,
                style: GoogleFonts.getFont(
                  "Poppins",
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              tileColor: Colors.transparent,
              dense: true,
            ),
          ),
          const Divider(),
          ...options,
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ListOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final IconData icon;

  const ListOption({
    Key? key,
    required this.title,
    this.subtitle,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListTile(
      tileColor: theme.colorScheme.surfaceVariant,
      visualDensity: VisualDensity.compact,
      dense: true,
      onTap: onTap,
      leading: Icon(
        icon,
        size: 32,
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              "Poppins",
              color: theme.colorScheme.tertiary,
              // fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          if (subtitle?.isNotEmpty ?? false)
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: GoogleFonts.getFont(
                "Poppins",
                // color: textColor,
                // fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
