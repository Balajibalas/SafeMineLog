import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supervisor/LoginPage.dart';

void main() async {
  // Initialize Supabase (replace with your Supabase URL and API key)
  await Supabase.initialize(
    url: 'https://djgtacpgehthspfctcxv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRqZ3RhY3BnZWh0aHNwZmN0Y3h2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU2MjE4MzcsImV4cCI6MjA0MTE5NzgzN30.-cbzPiA_PtcwQuZjMAKRTT-Vj9kMQcg0BBMENAjuTjQ',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: LoginPage(),
    );
  }
}

