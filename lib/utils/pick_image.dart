import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
  print('No file selected');
}
