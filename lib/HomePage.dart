import 'package:chatapplication/models/user_model.dart';
import 'package:chatapplication/pages/Search_page.dart';
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
      ),
      body: SafeArea(
        child: Container(
          
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