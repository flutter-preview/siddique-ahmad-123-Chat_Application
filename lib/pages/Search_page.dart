import 'package:chatapplication/models/user_model.dart';
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
                decoration: InputDecoration(
                  labelText: "Email Address",
                ),
              ),
              SizedBox(height: 20,),

              CupertinoButton(
                color: Colors.blue,
                child: Text("Search"),
                 onPressed: () {}

                 ),
                 SizedBox(height: 20,),

                 //StreamBuilder(),
            ],
          ),

        ),
        
        ),
    );
  }
}