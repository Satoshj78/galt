import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FirebaseApi {
  static Future<String> uploadImage(XFile image) async {
    try {
      final file = File(image.path);
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Upload the file to Firebase Storage
      await imageRef.putFile(file);

      // Get the download URL
      final downloadUrl = await imageRef.getDownloadURL();
      return downloadUrl; // Return the download URL of the uploaded image
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
