import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_project/views/screens/prodcut_screen.dart';
import 'package:depi_project/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarcodeProvider extends ChangeNotifier {
  String? scannedBarcode;
  int _scannedCount = 0;
  String? _currentUserId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int get scannedCount => _scannedCount;

  Future<void> loadScannedCount(String? userId) async {
    print("BarcodeProvider: Loading scanned count for user: $userId");
    _currentUserId = userId;
    if (userId == null) {
      _scannedCount = 0;
      notifyListeners();
      return;
    }

    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        _scannedCount = doc.data()?['scannedCount'] ?? 0;
        print("BarcodeProvider: Loaded count: $_scannedCount");
      } else {
        _scannedCount = 0;
        print("BarcodeProvider: No existing doc, count set to 0");
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading scanned count: $e');
    }
  }

  Future<void> _incrementScannedCount() async {
    _scannedCount++;
    notifyListeners();

    print(
      "BarcodeProvider: Incrementing count to $_scannedCount. UserID: $_currentUserId",
    );
    if (_currentUserId == null) {
      print("BarcodeProvider: UserID is null, NOT saving to Firestore");
      return;
    }

    try {
      await _firestore.collection('users').doc(_currentUserId).set({
        'scannedCount': _scannedCount,
      }, SetOptions(merge: true));
      print("BarcodeProvider: Saved count to Firestore");
    } catch (e) {
      debugPrint('Error saving scanned count: $e');
    }
  }

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
        await _incrementScannedCount();
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
