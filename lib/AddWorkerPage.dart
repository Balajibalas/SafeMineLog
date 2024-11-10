import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddWorkerPage extends StatefulWidget {
  @override
  _AddWorkerPageState createState() => _AddWorkerPageState();
}

class _AddWorkerPageState extends State<AddWorkerPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Future<void> _addWorker() async {
    try {
      // Fetch the maximum id from the table
      final response = await _supabase
          .from('All_workers')
          .select('id')
          .order('id', ascending: false)
          .limit(1)
          .maybeSingle();

      int newId = 1; // Default value if no workers exist

      if (response != null && response['id'] != null) {
        final maxId = response['id'] as int;
        newId = maxId + 1; // Increment the max id by 1
      }

      await _supabase.from('All_workers').insert({
        'id': newId,
        'worker_name': _nameController.text,
        'phone_number': _phoneController.text,
      });

      
        print('Worker added successfully!');

        // Show SnackBar on successful addition
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Worker added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Clear the text fields
        _nameController.clear();
        _phoneController.clear();
      
    } catch (e) {
      print('Error adding worker: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding worker'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Worker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Worker Name'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addWorker,
              child: Text('Add Worker'),
            ),
          ],
        ),
      ),
    );
  }
}
