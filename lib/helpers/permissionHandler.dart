import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerApp {
  Future<PermissionStatus> request() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();

      print(statuses[
          Permission.storage]); // it should print PermissionStatus.granted
    }
    return status;
  }
}
