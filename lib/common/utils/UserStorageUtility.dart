import 'package:file_picker/file_picker.dart';

Future<FilePickerResult?> selectFile({
  FileType type = FileType.any,
  bool allowMultiple = false,
  String title = "Please select a file",
  Function(FilePickerStatus)? onFileLoading,
}) async {
  return await FilePicker.platform.pickFiles(
      type: type,
      allowMultiple: allowMultiple,
      onFileLoading: onFileLoading,
      allowedExtensions: null,
      dialogTitle: title,
      initialDirectory: null,
      lockParentWindow: true,
      // Weather to load file data in memory
      withData: true);
}
