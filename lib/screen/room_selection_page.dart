import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pictionis/screen/drawing_page.dart';
import 'package:pictionis/theme.dart';

class RoomSelectionPage extends StatefulWidget {
  const RoomSelectionPage({super.key});

  @override
  State<RoomSelectionPage> createState() => _RoomSelectionPageState();
}

class _RoomSelectionPageState extends State<RoomSelectionPage> {
  final TextEditingController _roomCodeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _roomCodeController.dispose();
    super.dispose();
  }

  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<void> _createRoom() async {
    final roomCode = _generateRoomCode();
    try {
      await _firestore.collection('rooms').doc(roomCode).set({
        'createdAt': FieldValue.serverTimestamp(),
      });
      _navigateToRoom(roomCode);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create room: $e')),
      );
    }
  }

  void _navigateToRoom(String roomID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DrawingPage(roomID: roomID),
      ),
    );
  }

  Future<void> _joinRoom() async {
    final roomCode = _roomCodeController.text.trim().toUpperCase();
    if (roomCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a room code')),
      );
      return;
    }

    try {
      final room = await _firestore.collection('rooms').doc(roomCode).get();
      if (room.exists) {
        _navigateToRoom(roomCode);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Room does not exist')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join room: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _createRoom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                  ),
                  child: const Text(
                    "Create Room",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: 180,
                  child: TextField(
                    controller: _roomCodeController,
                    decoration: InputDecoration(
                      labelText: "Room Code",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _joinRoom,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: const Text(
                    "Join Room",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
