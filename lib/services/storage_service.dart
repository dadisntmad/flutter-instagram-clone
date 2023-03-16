import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram/constants.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  // upload file to storage
  Future<String> uploadFileToStorage(
    String childName,
    Uint8List file,
    bool isPost,
  ) async {
    Reference ref = storage.ref().child(childName).child(auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
