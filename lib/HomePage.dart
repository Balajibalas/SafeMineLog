import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:supervisor/Generator.dart';
import 'package:supervisor/LoginPage.dart';
import 'package:supervisor/Me.dart';
import 'package:supervisor/AddWorkerPage.dart';
import 'package:supervisor/chat.dart';
import 'package:supervisor/sos.dart'; // Import the new page

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  String supervisorName = '';
  String userEmail = '';
  String allocatedShiftvar = '';
  String allocatedShift = '';
  String timing = '';
  int id = 0; // Supervisor ID

  @override
  void initState() {
    super.initState();
    _fetchSupervisorDetails();
  }

  Future<void> _fetchShift() async {
    DateTime now = DateTime.now();
    String today = DateFormat('EEE').format(now); 
    final response = await _supabase
        .from('Supervisor_shift')
        .select(today) 
        .eq('id', id) // Fetch shift using supervisor id
        .maybeSingle();

    setState(() {
      allocatedShiftvar = response?[today] ?? 'No Shift Allocated';

      if (allocatedShiftvar == 'A') {
        allocatedShift = 'Morning';
        timing = '8.00 - 16.00';
      } else if (allocatedShiftvar == 'B') {
        allocatedShift = 'Evening';
        timing = '16.00 - 0.00';
      } else if (allocatedShiftvar == 'C') {
        allocatedShift = 'Night';
        timing = '0.00 - 8.00';
      } else {
        allocatedShift = allocatedShiftvar;
      }
    });
  }

  Future<void> _fetchSupervisorDetails() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        userEmail = user.email ?? '';

        final response = await _supabase
            .from('All_supervisor')
            .select('supervisor_name, id') // Fetch both name and ID
            .eq('email', userEmail)
            .maybeSingle();

        if (response != null) {
          setState(() {
            supervisorName = response['supervisor_name'] ?? 'Unknown Supervisor';
            id = response['id'] ?? 0; // Fetch supervisor id
          });
          
          // Call _fetchShift after successfully fetching supervisor details
          await _fetchShift();
        } else {
          setState(() {
            supervisorName = 'Supervisor not found';
          });
        }
      }
    } catch (e) {
      print('Error fetching supervisor details: $e');
      setState(() {
        supervisorName = 'Error fetching data';
      });
    }
  }

  Future<void> _logout() async {
    await _supabase.auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SafeMineLog Supervisor'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
              decoration: BoxDecoration(
                color: Color.fromARGB(26, 84, 78, 78),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Color.fromARGB(26, 84, 78, 78),
                        backgroundImage: AssetImage('assets/images/wlogo.png'), // Replace with your image asset
                      ),
                      SizedBox(height: 10),
                      Text(
                        "  SafeMineLog",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Me'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Me()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('About'),
                      content: Text('SafeMineLog Supervisor is a safety management app developed by the team Tech Conquerors'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Stack(
        children:[ 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $supervisorName!',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
               GestureDetector(
  onTap: () {
    if (allocatedShiftvar.isNotEmpty && allocatedShiftvar != 'No Shift Allocated') {
      // If shift is allocated, navigate to Generator page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Generator(allocatedShiftvar: allocatedShiftvar),
        ),
      );
    } else {
      // Show SnackBar if no shift is allocated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No shift has been allocated.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: Container(
    width: 800,
    height: 100,
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.green, // Keep the original green color
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(color: Colors.black, width: 2.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 4),
          blurRadius: 8.0,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Allocated Shift: $allocatedShift',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (timing != '') // Checking if timing is not null and not empty
          SizedBox(height: 8.0), // Adding some space between the texts
        if (timing != '')
          Text(
            'Shift Timing: $timing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
      ],
    ),
  ),
),

                SizedBox(height: 20),
               Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: GestureDetector( // Added GestureDetector for navigation
        onTap: () {
          // Navigate to the SOS page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SosPage(workerId: id,)),
          );
        },
        child: Container(
          height: 200,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.black, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 8.0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
    SizedBox(width: 20),
    Expanded(
      child: GestureDetector( // Added GestureDetector for navigation
        onTap: () {
          // Navigate to the Talking Realm page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        child: Container(
          height: 200,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.black, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 8.0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Talking \n Realm',
              textAlign: TextAlign.center, // Center the text for better appearance
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  ],
),

                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddWorkerPage()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.black, width: 2.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Add Worker',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
