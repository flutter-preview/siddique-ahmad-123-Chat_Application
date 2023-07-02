import 'dart:developer';

import 'package:chatapplication/main.dart';
import 'package:chatapplication/models/ChatRoomModel.dart';
import 'package:chatapplication/models/user_model.dart';
import 'package:chatapplication/pages/ChatRoom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchPage({super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

    TextEditingController searchController = TextEditingController(); 

    Future<ChatRoomModel?> getChatroomModel(UserModel targetUser)async {
      ChatRoomModel? ChatRoom;
     QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("chatrooms").where("participants.${widget.userModel.uid}",isEqualTo: true).where("participants.${targetUser.uid}",isEqualTo: true).get();

     if(snapshot.docs.length>0){
      //fetch the Existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as
       Map<String,dynamic>);

       ChatRoom = existingChatroom;
     }
     else{
      // create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        }
      );

      await FirebaseFirestore.instance.collection("chatrooms").
      doc(newChatroom.chatroomid).
      set(newChatroom.toMap());

      ChatRoom = newChatroom;
   log("new chatroom created");

     }

     return ChatRoom;
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Email Address",
                ),
              ),
              SizedBox(height: 20,),

              CupertinoButton(
                color: Colors.blue,
                child: Text("Search"),
                 onPressed: () {
                  setState(() {
                    
                  });
                 }
                   
                 ),
                 SizedBox(height: 20,),

                 StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").where
                  ("email",isEqualTo: searchController.text).where("email",isNotEqualTo: widget.userModel.email).snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.active){
                        if(snapshot.hasData){
                          QuerySnapshot dataSnapshot = snapshot.data as 
                          QuerySnapshot;
                          if(dataSnapshot.docs.length>0){
                             Map<String,dynamic> userMap = dataSnapshot.docs[0].data() as 
                            Map<String,dynamic> ;

                            UserModel searchedUser = UserModel.fromMap(userMap);
                            return ListTile(
                              onTap: () async {
                            ChatRoomModel? chatroomModel =   await
                              getChatroomModel(searchedUser);
                              if(chatroomModel!= null){
                                   Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context){
                                      return ChatRoom(
                                        targetUser: searchedUser,
                                        userModel:  widget.userModel,
                                        firebaseUser: widget.firebaseUser,
                                        chatRoom: chatroomModel,
                                        
                                      );

                                    } )
                                  );
                              }
                               
                              },
                              leading: CircleAvatar(
                                backgroundImage:  NetworkImage(searchedUser.profilepic!),
                              ),
                              title: Text(searchedUser.fullname.toString()),
                              subtitle: Text(searchedUser.email.toString()),
                              trailing: Icon(Icons.keyboard_arrow_right),
                            );
                          }else{
                            return Text("No result found !");
                          } 
                        }
                        else if(snapshot.hasError){
                           return Text("An error occured !");
                        }
                        else{
                          return Text("No result found !");
                        }
                    }
                    else{
                      return CircularProgressIndicator();
                    }
                  }
                  ),
                 
            ],
          ),

        ),
        
        ),
    );
  }
}