import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'HomePage.dart'; // Import the homepage

class QRViewExample extends StatefulWidget {
  final int id;
  final String allocatedShiftvar; // Pass the allocatedShiftvar

  QRViewExample({required this.allocatedShiftvar, required this.id});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final SupabaseClient _supabase = Supabase.instance.client; // Initialize Supabase client

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scanner')),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to insert id and timestamp into Curr_Workers table
  Future<void> _insertCurrWorker(int id) async {
    try {
      DateTime now = DateTime.now(); // Get the current timestamp

      final response = await _supabase
          .from('Curr_Workers')
          .insert({
            'id': id,
            'timestamp': now.toIso8601String() // Insert timestamp in ISO format
          });

      if (response.error != null) {
        print('Error inserting into Curr_Workers: ${response.error!.message}');
      } else {
        print('Data inserted successfully into Curr_Workers');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null) {
        // Stop the camera
        controller.pauseCamera();

        // Check if the scanned data matches the allocatedShiftvar
        bool isMatching = result!.code == widget.allocatedShiftvar;

        // Show a snackbar indicating whether it matches or not
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isMatching
                ? 'QR Code matches the allocated shift!'
                : 'QR Code does not match the allocated shift!'),
            backgroundColor: isMatching ? Colors.green : Colors.red,
            duration: Duration(seconds: 2), // Set duration for the Snackbar
          ),
        );

        // Insert id and timestamp into the Curr_Workers table
        if (isMatching) {
          _insertCurrWorker(widget.id);
        }

        // After showing the snackbar, navigate back to the HomePage
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Navigate to homepage
          );
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
