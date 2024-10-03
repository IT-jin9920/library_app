// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart' as picker;
// import 'package:image_cropper/image_cropper.dart';
//
// class Demo extends StatefulWidget {
//   const Demo({super.key});
//
//   @override
//   State<Demo> createState() => _DemoState();
// }
//
// class _DemoState extends State<Demo> {
//   File? _image;
//   final picker.ImagePicker _picker = picker.ImagePicker();
//
//   Future<void> _pickImage() async {
//     final picker.XFile? pickedFile = await _picker.pickImage(
//       source: picker.ImageSource.camera, // Open camera instead of gallery
//     );
//     if (pickedFile != null) {
//       _cropImage(pickedFile.path);
//     }
//   }
//
//   Future<void> _cropImage(String imagePath) async {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: imagePath,
//
//       androidUiSettings: AndroidUiSettings(
//         toolbarTitle: 'Cropper',
//         toolbarColor: Colors.deepOrange,
//         toolbarWidgetColor: Colors.white,
//         initAspectRatio: CropAspectRatioPreset.original,
//         lockAspectRatio: false,
//       ),
//       // uiSettings: IOSUiSettings(
//       //   minimumAspectRatio: 1.0,
//       // ),
//     );
//
//     if (croppedFile != null) {
//       setState(() {
//         _image = File(croppedFile.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Image Editor Demo')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _image == null
//                 ? const Text('No image selected.')
//                 : Image.file(_image!),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: const Text('Take Picture'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
