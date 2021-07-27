import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUtil {
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> uploadFileOrDocument(
      var file, String pathFolder, String nameDocument) async {
    Map<String, dynamic> resultUpload;
    TaskSnapshot snapshot = await storage
        .ref()
        .child('/$pathFolder/$nameDocument.pdf')
        .putFile(file);
    if (snapshot.state == TaskState.success) {
      resultUpload = {
        'url': await snapshot.ref.getDownloadURL(),
        'state': 'success'
      };
    } else {
      resultUpload = {'url': 'No url', 'state': 'error'};
    }

    return resultUpload;
  }
}
