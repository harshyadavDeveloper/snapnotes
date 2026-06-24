// import 'dart:io';

// import 'package:image_cropper/image_cropper.dart';

// class ImageCropperService {
//   Future<File?> cropImage(File image) async {
//     final cropped = await ImageCropper().cropImage(
//       sourcePath: image.path,
//       compressQuality: 100,
//       uiSettings: [
//         AndroidUiSettings(
//           toolbarTitle: 'Crop Document',
//           lockAspectRatio: false,
//         ),
//       ],
//     );

//     if (cropped == null) {
//       return null;
//     }

//     return File(cropped.path);
//   }
// }
