import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});

  @override
  QRCodeScannerState createState() => QRCodeScannerState();
}

class QRCodeScannerState extends State<QRCodeScanner> {
  // MobileScannerController cameraController = MobileScannerController();
  // final bool _isNavigated = false; // Flag pour éviter les multiples navigations

  @override
  void dispose() {
    // cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner un QR code'),
      ),
      body: const Text('Scanner un QR code'),
      // MobileScanner(
      //   controller: cameraController,
      //   onDetect: (BarcodeCapture barcodes) {
      //     final String? code = barcodes.barcodes.firstOrNull!.displayValue;  // Utilisez Barcode et non BarcodeCapture
      //     if (code != null && !_isNavigated) {
      //       _isNavigated = true;

      //       // Arrêter la caméra pour éviter des scans multiples
      //       cameraController.stop();

      //       // Retourner le code scanné et fermer le scanner
      //       Navigator.of(context).pop(code);
      //     }
      //   },
      // ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QRCodeScanner extends StatefulWidget {
//   const QRCodeScanner({super.key});

//   @override
//   QRCodeScannerState createState() => QRCodeScannerState();
// }

// class QRCodeScannerState extends State<QRCodeScanner> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode? result;
//   QRViewController? controller;
//   bool _isNavigated = false; // Flag pour empêcher les multiples pop

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Scanner un QR code')),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           const Expanded(
//             flex: 1,
//             child: Center(
//               child: Text('Scanner un QR code'),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       if (!_isNavigated) {  // Empêcher les multiples appels
//         setState(() {
//           result = scanData;
//         });

//         // Arrêter la caméra après la lecture pour éviter les scans multiples
//         controller.stopCamera();

//         if (mounted && Navigator.canPop(context)) {
//           _isNavigated = true; // Mettre à jour le flag pour bloquer les autres pops
//           Navigator.of(context).pop(scanData.code);
//         }
//       }
//     });
//   }
// }




// Arrêter la caméra après la lecture pour éviter les scans multiples
        // controller.stopCamera();

        // if (mounted && Navigator.canPop(context)) {
        //   _isNavigated = true; // Mettre à jour le flag pour bloquer les autres pops
        //   Navigator.of(context).pop(scanData.code);
        // }