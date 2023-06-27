import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          child:Column(children: [
         //This is where the chat message will go 
         Expanded(child: Container(),),
          
          Container(
          color: Color.fromARGB(255, 194, 187, 187),
          padding: EdgeInsets.symmetric(horizontal: 15,
          vertical: 5),
          child: Row(
            children: [
             Flexible(child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter message",
              ),
             ),),
             IconButton(
              onPressed: (() {
                
              }), icon: Icon(Icons.send, color: Colors.blue,))
            ],
          ),
        ),
          
        ],
          ),
        ),
        ),
    );
  }
}