import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class Generator extends StatefulWidget {
  final String allocatedShiftvar;

  Generator({required this.allocatedShiftvar});

  @override
  State<Generator> createState() => _GeneratorState();
}

class _GeneratorState extends State<Generator> {
  GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String data = widget.allocatedShiftvar.trim(); // Access allocatedShiftvar from widget

    return Scaffold(
      appBar: AppBar(
        title: Text('QR Generator'),
      ),
      body: Center( // Center the QR code on the page
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding to avoid too close edges
          child: RepaintBoundary(
            key: globalKey,
            child: Container(
              color: Colors.white,
              child: data.isEmpty
                  ? Text('Error loading QR code')
                  : QrImageView(
                      data: data,
                      version: QrVersions.auto,
                      size: MediaQuery.of(context).size.width * 0.8, // Dynamically adjust size to 80% of the screen width
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
