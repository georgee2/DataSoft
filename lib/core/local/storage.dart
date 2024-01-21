import 'package:file_picker/file_picker.dart';

// This function to get attach file from device and this function used in lib/core/networks/attach_file.dart
Future<PlatformFile?> getAttachFileFromDevice() async {
  try {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowCompression: false);
    if (result != null) {
      PlatformFile file = result.files.first;
      return file;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
