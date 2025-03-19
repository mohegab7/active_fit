import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan with Camera")),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;

          if (barcodes.isNotEmpty) {
            final String code = barcodes.first.rawValue ?? "No Data";
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Scanned: $code")),
            );
          }
        },
      ),
    );
  }
}
