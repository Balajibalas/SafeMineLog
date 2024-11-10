import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SosPage extends StatefulWidget {
  final int workerId;

  const SosPage({Key? key, required this.workerId}) : super(key: key);

  @override
  _SosPageState createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _triggerSos() async {
    String alertId = 'W${widget.workerId}';

    await _supabase.from('Alert_table').insert({
      'id': alertId,
    });

    _showSuccessDialog();
  }

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
                Navigator.of(context).pop();
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Overlay for opacity
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // SOS Button
          Center(
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
        ],
      ),
    );
  }
}
