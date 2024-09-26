import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  final SupabaseClient _supabase = Supabase.instance.client;
  String workerName = '';
  String userEmail = '';
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _fetchWorkerDetails();
  }

  Future<void> _fetchWorkerDetails() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        userEmail = user.email ?? '';

        // Query to fetch worker details based on the user's email
        final response = await _supabase
            .from('All_workers')
            .select('worker_name, phone_number')
            .eq('email', userEmail)
            .maybeSingle();

        if (response != null) {
          setState(() {
            workerName = response['worker_name'] ?? 'Unknown Worker';
            phoneNumber = response['phone_number'] ?? 'Unknown Phone Number';
          });
        } else {
          setState(() {
            workerName = 'Worker not found';
            phoneNumber = 'Phone number not found';
          });
        }
      }
    } catch (e) {
      print('Error fetching worker details: $e');
      setState(() {
        workerName = 'Error fetching data';
        phoneNumber = 'Error fetching data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: $workerName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: $userEmail',
              style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Phone Number: $phoneNumber',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Designation: Worker',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),
            ),
            
          ],
        ),
      ),
    );
  }
}
