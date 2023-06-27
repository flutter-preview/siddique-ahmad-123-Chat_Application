

import 'package:chatapplication/HomePage.dart';
import 'package:chatapplication/models/user_model.dart';
import 'package:chatapplication/pages/signupPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController= TextEditingController();

void checkValues(){
String email= emailController.text.trim();
String password= passwordController.text.trim();

if(email == "" || password== ""){
  print("please enter detail !!");
}
else {
  login(email, password);
}

}

void login(String email, String password) async{
   UserCredential? credential;

   try{
    credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, password: password);
   }on FirebaseAuthException catch(ex){
    print(ex.code.toString());
   }

   if(credential!=null){
    String uid = credential.user!.uid;

    DocumentSnapshot userData = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    UserModel userModel = UserModel.fromMap(userData.data() as Map<String, dynamic>);

// go to home page:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context){
          return HomePage(userModel:userModel, firebaseUser: credential!.user! );
        }
        )
    );
   }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:
         Center(
            child: SingleChildScrollView(
              child:Container(
                padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(    
                "Chat Application",
                  style: TextStyle(
                    color: Color.fromARGB(255, 57, 53, 53),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,

                  ),
                  ),
                  SizedBox(height: 20,),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "password",
                ),
              ),
              SizedBox(height: 20,),

              ElevatedButton(
                onPressed: (() {
                  checkValues();
                }),
                
                 child: Text(
                  "log In",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  
                  ) 
                 
                 ),


                ],
              ),
              ),
            ),
        ),
     ),

     bottomNavigationBar: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?",
          style: TextStyle(
            fontSize: 16,
          ),
          ),
          CupertinoButton(
            child: Text("Sign Up",
            style: TextStyle(
              fontSize: 16,
            ),), 
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) {
                    return SignUp();
                  },
                  ),
              ); 

            },
            )
        ],
      ),
     ),

    );
  }
}