import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:worker/LoginPage.dart';
import 'package:worker/Me.dart';
import 'package:intl/intl.dart';
import 'package:worker/QRViewExample.dart';
import 'package:worker/DeletePage.dart';
import 'package:worker/chat.dart';
import 'package:worker/sos.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  String workerName = '';
  String userEmail = '';
  String allocatedShiftvar = '';
  String allocatedShift = '';
  String timing = '';
  int id = 0;

  @override
  void initState() {
    super.initState();
    _fetchWorkerDetails();
  }

  Future<void> _fetchShift() async {
    DateTime now = DateTime.now();
    String today = DateFormat('EEE').format(now); 
    final response = await _supabase
        .from('Worker_shift')
        .select(today) 
        .eq('id', id)
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

  Future<void> _fetchWorkerDetails() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        userEmail = user.email ?? '';

        final response = await _supabase
            .from('All_workers')
            .select('worker_name, id')
            .eq('email', userEmail)
            .maybeSingle();

        if (response != null) {
          setState(() {
            workerName = response['worker_name'] ?? 'Unknown Worker';
            id = response['id'] ?? 0;
          });
          
          await _fetchShift();
        } else {
          setState(() {
            workerName = 'Worker not found';
          });
        }
      }
    } catch (e) {
      print('Error fetching worker details: $e');
      setState(() {
        workerName = 'Error fetching data';
      });
    }
  }

  Future<void> _checkIdInCurrWorkers() async {
    try {
      final response = await _supabase
          .from('Curr_Workers')
          .select('id')
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DeletePage(id: id)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QRViewExample(
            allocatedShiftvar: allocatedShiftvar,
            id: id,
          )),
        );
      }
    } catch (e) {
      print('Error checking ID in Curr_Workers: $e');
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
  extendBodyBehindAppBar: true, 
  appBar: AppBar(
   title: Text(
    'SafeMineLog Worker',
    style: TextStyle(color: Colors.white,fontSize: 30.0),),
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(
    color: Colors.white, 
  ),
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
                    backgroundImage: AssetImage('assets/images/wlogo.png'),
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
                  content: Text('SafeMineLog Worker is a safety management app developed by the team Tech Conquerors'),
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
    children: [
      Positioned.fill(
        child: Image.asset(
          'assets/images/background.png',
          fit: BoxFit.cover,
        ),
      ),
      // Dark overlay for text visibility
      Positioned.fill(
        child: Container(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kToolbarHeight + 30), // Offset to account for the AppBar
            Text(
              'Hi, $workerName!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () async {
                await _checkIdInCurrWorkers();
              },
              child: Container(
                width: 500,
                height: 100,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
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
                    if (timing != '') 
                      SizedBox(height: 8.0),
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SosPage(workerId: id)),
                      );
                    },
                    child: Container(
                      height: 200,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.8),
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
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen()),
                      );
                    },
                    child: Container(
                      height: 200,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.8),
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
                          textAlign: TextAlign.center,
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
          ],
        ),
      ),
      Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton(
          onPressed: () {
            // Add your customer care action here
          },
          child: Icon(Icons.support_agent),
        ),
      ),
    ],
  ),
);

  }
}
