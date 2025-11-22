import 'package:depi_project/views/screens/prodcut_screen.dart';
import 'package:depi_project/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarcodeProvider extends ChangeNotifier {
  String? scannedBarcode;

  Future<void> scanBarcode(BuildContext context) async {
    // Request camera permission
    final status = await Permission.camera.request();
    
    if (status.isGranted) {
      final barcode = await SimpleBarcodeScanner.scanBarcode(
        context,
        barcodeAppBar: const BarcodeAppBar(
          appBarTitle: 'Scan a Barcode',
          centerTitle: true,
          enableBackButton: true,
          backButtonIcon: Icon(Icons.arrow_back),
        ),
        isShowFlashIcon: true,
        delayMillis: 2000,
        cameraFace: CameraFace.back,
      );

      if (!context.mounted) return;

      if (barcode != null && barcode.isNotEmpty && barcode != '-1') {
        // Valid barcode scanned
        scannedBarcode = barcode;
        notifyListeners();

        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductScreenBuilder(barcode: barcode),
          ),
        );

        scannedBarcode = null;
        notifyListeners();
      } else {
        // User cancelled the scan or invalid barcode
        scannedBarcode = null;
        notifyListeners();
        
        // Navigate back to main screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Camera permission is required to scan barcodes',
            ),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: openAppSettings,
            ),
          ),
        );
      }
    }
  }
}