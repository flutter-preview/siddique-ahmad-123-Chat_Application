import 'dart:developer';

import 'package:chatapplication/main.dart';
import 'package:chatapplication/models/ChatRoomModel.dart';
import 'package:chatapplication/models/MessageRoomModel.dart';
import 'package:chatapplication/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoom({super.key, required this.targetUser, required this.chatRoom, required this.userModel, required this.firebaseUser});

  

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  TextEditingController messageController = TextEditingController();

  void sendMessage() async{
  String msg = messageController.text.trim();
  messageController.clear();
  if(msg!=" "){
    //send message
    MessageModel newMessage = MessageModel(
      messageid: uuid.v1(),
      sender: widget.userModel.uid,
      createdon: DateTime.now(),
      text: msg,
      seen: false,
         
    );
    FirebaseFirestore.instance.collection("chatrooms").doc(
      widget.chatRoom.chatroomid).
      collection("messages").doc(newMessage.messageid).
      set(newMessage.toMap());

      widget.chatRoom.lastMessage = msg;
      FirebaseFirestore.instance.collection("chatrooms").
      doc(widget.chatRoom.chatroomid).
      set(widget.chatRoom.toMap());

      log("messsage sent!");
    
  }
  

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [

            CircleAvatar(
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(widget.targetUser.profilepic.toString()),
            ),
            SizedBox(width: 20,),
            Text(widget.targetUser.fullname.toString()),

          ],
        ) ,
      ),
      body: SafeArea(
        child: Container(
          child:Column(children: [
         //This is where the chat message will go 
         Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                    horizontal: 10
                  ),
             child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("chatrooms")
              .doc(widget.chatRoom.chatroomid).
              collection("messages").orderBy("createdon",descending: true).snapshots(),

              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.active) {
                  if(snapshot.hasData){
                       QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;

                       return ListView.builder(
                        reverse: true,

                        itemCount: datasnapshot.docs.length,

                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromMap(datasnapshot.docs[index].
                          data() as Map<String,dynamic>);
                          return Row(
                                mainAxisAlignment: (currentMessage.sender == widget.userModel.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  Container(
                        
                                    margin: EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (currentMessage.sender == widget.userModel.uid) ? Colors.grey : Theme.of(context).colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      currentMessage.text.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ),
                                ],
                              );



                        },
                        );
                  }else if(snapshot.hasError){
                       return Center(
                        child: Text("An Error occured! Please check your internet connection."),
                       );
                  }
                  else{
                    return Center(
                      child: Text("Say Hi to your new Friend"),
                    );
                  }

                }else{
                  Center(
                  child: CircularProgressIndicator(),
                  );
                }
                return Container();
              
              },
              
               ),
         ),
         ),
          
          Container(
          color: Color.fromARGB(255, 194, 187, 187),
          padding: EdgeInsets.symmetric(horizontal: 15,
          vertical: 5),
          child: Row(
            children: [
             Flexible(child: TextField(
              maxLines: null,
              controller: messageController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter message",
              ),
             ),),
             IconButton(
              onPressed: (() {
                sendMessage();
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