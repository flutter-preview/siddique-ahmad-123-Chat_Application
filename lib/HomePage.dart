import 'package:chatapplication/models/ChatRoomModel.dart';
import 'package:chatapplication/models/Firebase_helper.dart';
import 'package:chatapplication/models/user_model.dart';
import 'package:chatapplication/pages/ChatRoom.dart';
import 'package:chatapplication/pages/LoginPage.dart';
import 'package:chatapplication/pages/Search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage({super.key, required this.userModel, required this.firebaseUser});
  

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey,
        title: Text("Chat Application",style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            onPressed: (() async {
             await FirebaseAuth.instance.signOut();
             Navigator.popUntil(context, (route) => route.isFirst);
             Navigator.pushReplacement(
              context, 
             MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              }),
             );
            }), 
            icon: Icon(Icons.exit_to_app),),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("chatrooms").
            where("participants.${widget.userModel.uid}",isEqualTo:true).
            snapshots(),
            
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.active){
                if(snapshot.hasData){
                   QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

                   return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap
                      (chatRoomSnapshot.docs[index].data() as Map<String,dynamic>);

                      Map<String,dynamic>? participants = chatRoomModel.participants;

                      List<String> participantKeys = participants!.keys.
                      toList();
                      participantKeys.remove(widget.userModel.uid);

                      return FutureBuilder(
                        future: FirebaseHelper.getUserModelById(participantKeys[0]),
                        builder: (context, userData) {
                          if(userData.connectionState == ConnectionState.done){
                            if(userData.data != null){
                                UserModel targetUser = userData.data as UserModel;

                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:(context){
                                    return ChatRoom(targetUser: targetUser, chatRoom: chatRoomModel, userModel: widget.userModel, firebaseUser: widget.firebaseUser);
                                  }
                                  ),
                                  );
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(targetUser.profilepic.toString()),
                            ),
                             title: Text(targetUser.fullname.toString()),
                             subtitle:(chatRoomModel.lastMessage.toString() != "") ? Text(chatRoomModel.lastMessage.toString()): Text("Say Hi to your New Friend !",
                             style: TextStyle(
                              color: Colors.blue,
                             ),),

                          );
                            }
                            else{
                              return Container();
                            }
                            
                          }else{
                            return Container();
                          }
                          
                        },
                      );
                    },
                   );
                }
                else if(snapshot.hasError){

                  return Center(
                    child: Text(snapshot.error.toString()),
                  );

                }else{
                  return Center(
                    child: Text("No Chats"),
                  );
                }

              }else{
                return CircularProgressIndicator();
              }
            },

             ),
        ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey,
          onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context){
                return SearchPage(userModel: widget.userModel, firebaseUser: widget.firebaseUser);
              }
              ),
            );
        },
        child: Icon(Icons.search),
        
        ),
    );
    
  }
}