import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SosPage extends StatefulWidget {
  final int workerId; // The worker's ID passed from the previous page

  const SosPage({Key? key, required this.workerId}) : super(key: key);

  @override
  _SosPageState createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _triggerSos() async {
    // Concatenating worker ID with "W"
    String alertId = 'S${widget.workerId}';

    // Inserting into Alert_table without error checking
    await _supabase.from('Alert_table').insert({
      'id': alertId, // Inserting the ID as a text field
    });

    // Showing SOS Sent dialog directly after clicking
    _showSuccessDialog();
  }

  // Method to display the "SOS Sent" success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SOS Sent'),
          content: Text('The SOS alert has been triggered successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _triggerSos,
          child: Text('Trigger SOS'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
