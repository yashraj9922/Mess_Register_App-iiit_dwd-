// ignore: file_names
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  final Function(String) onScannedQRCode;

  const QRViewExample({Key? key, required this.onScannedQRCode}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

    void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final scannedDataParts = scanData.code!.split(',');
      if (scannedDataParts.length > 3) {
        final rollNumber = scannedDataParts[3];
        widget.onScannedQRCode(rollNumber);
        setState(() {
          controller.pauseCamera();
        });
      }
    });
  }
}