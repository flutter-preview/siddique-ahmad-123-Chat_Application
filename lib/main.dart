import 'package:chatapplication/models/Firebase_helper.dart';
import 'package:chatapplication/models/user_model.dart';
import 'package:chatapplication/pages/LoginPage.dart';
import 'package:chatapplication/pages/completeProfilepage.dart';
import 'package:chatapplication/pages/signupPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'HomePage.dart';

var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await  Firebase.initializeApp();

  User? currentUser =FirebaseAuth.instance.currentUser;
 if(currentUser!=null) {
  //logged in
  UserModel? thisUserModel = await FirebaseHelper.getUserModelById
  (currentUser.uid);

  if(thisUserModel!=null) {
    runApp(MyAppLoggedIn(userModel:thisUserModel , firebaseUser: currentUser));
  } else{
  //not loggedin
  runApp(const MyApp());
 }

 }
 else{
  //not loggedin
  runApp(const MyApp());
 }

  
}

//NOT LOGGED IN
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

//ALREADY LOGGED IN:

class MyAppLoggedIn extends StatelessWidget {
 final UserModel userModel;
final User firebaseUser;

  const MyAppLoggedIn({super.key, required this.userModel, required this.firebaseUser});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: HomePage(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}
