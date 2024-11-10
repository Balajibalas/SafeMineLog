import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _subscribeToMessages();
  }

  Future<void> _fetchMessages() async {
    final response = await Supabase.instance.client
        .from('messages')
        .select()
        .order('created_at', ascending: true);

    // The response is already a list, no need to access `.data`
    if (response != null && response is List) {
      setState(() {
        _messages.clear();
        _messages.addAll(response
            .map((message) => message as Map<String, dynamic>)
            .toList());
      });
    } else {
      print('Error fetching messages');
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final message = {
      'content': _controller.text,
      'sender_id': 'user-id', // Replace with actual user ID
    };

    final response = await Supabase.instance.client
        .from('messages')
        .insert(message)
        .select(); // No need for `.execute()`

    if (response != null) {
      _controller.clear();
      _fetchMessages(); // Refresh the message list after sending
    } else {
      print('Error sending message');
    }
  }

  void _subscribeToMessages() {
    Supabase.instance.client
        .from('messages')
        .stream(primaryKey: ['id']) // Use stream for real-time updates
        .order('created_at')
        .listen((payload) {
          setState(() {
            _messages.addAll(payload
                .map((message) => message as Map<String, dynamic>)
                .toList());
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message['content']),
                  subtitle: Text(message['sender_id'] ?? 'Unknown'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Send a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
