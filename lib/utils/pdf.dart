import 'dart:io';
import 'package:expediente_clinico/utils/firebase.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PDFUtil {
  static FirebaseUtil _firebaseUtil = FirebaseUtil();

  static Future<Map<String, dynamic>> createPDF(dynamic pdfContent,
      String pathFolderStorage, String nameOfTheFile) async {
    // Directory appDocumentsDirectory;
    // String route;
    // if (Platform.isAndroid) {
    //   PermissionHandlerApp permissionHandlerApp = PermissionHandlerApp();
    //   var res = await permissionHandlerApp.request();
    //   if (res.isGranted) {
    //     route = "/storage/emulated/0/Download";
    //     //android
    //     appDocumentsDirectory = await getExternalStorageDirectory();
    //   } else {
    //     await permissionHandlerApp.request();
    //   }
    // } else {
    //   //ios
    //   appDocumentsDirectory = await getApplicationDocumentsDirectory();
    //   route = "$appDocumentsDirectory";
    // }

    // // final file = File(
    // //     "$route/Cita-${_selectedDate.day.toString().padLeft(2, '0')}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.year.toString().padLeft(2, '0')}.pdf");

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/cita.pdf");

    var res =
        await _processPdf(file, pathFolderStorage, nameOfTheFile, pdfContent);

    return res;
  }

  static Future<Map<String, dynamic>> _processPdf(
      File file, String path, String nameOfTheFile, dynamic content) async {
    pw.Document pdf = pw.Document();

    pdf.addPage(pw.Page(
        orientation: pw.PageOrientation.portrait,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return content;
        }));

    await file.writeAsBytes(await pdf.save());

    var res =
        await _firebaseUtil.uploadFileOrDocument(file, path, '$nameOfTheFile');
    return res;
  }
}
