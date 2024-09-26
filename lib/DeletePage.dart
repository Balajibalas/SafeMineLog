import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worker/HomePage.dart';

class DeletePage extends StatefulWidget {
  final int id;

  DeletePage({required this.id});

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _deleteWorker() async {
    // Delete record from database
    await _supabase
        .from('Curr_Workers')
        .delete()
        .eq('id', widget.id);

    // Navigate to HomePage and show success snackbar
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Record successfully deleted.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Record'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to delete your record?',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteWorker,
                child: Text('Yes, Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
