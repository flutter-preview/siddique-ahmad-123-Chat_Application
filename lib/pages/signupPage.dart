
import 'package:chatapplication/models/UIhelper.dart';
import 'package:chatapplication/models/user_model.dart';
import 'package:chatapplication/pages/LoginPage.dart';
import 'package:chatapplication/pages/completeProfilepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController emailController =TextEditingController();
  TextEditingController passwordController =TextEditingController();
  TextEditingController CpasswordController =TextEditingController();

  void checkValues(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String Cpassword = CpasswordController.text.trim();

    if(email == "" || password == ""||Cpassword==""){
     UIhelper.showAlertDialog(context, "Incomplete Data", "Please fill all the fields.");
    }
    else if(password != Cpassword){
      UIhelper.showAlertDialog(context, "Password Mismatch", "The Password You entered do not match.");
    }

    else{
      signUp(email, password);
    }


  }

  void signUp(String email,String password) async {
     UserCredential? Credential;

     UIhelper.showLoadingDialog(context, "Creating New Account..");
  try{
     Credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, password: password);
  } on FirebaseAuthException catch(ex){
    Navigator.pop(context);
    
    UIhelper.showAlertDialog(context, "An Error occured.", ex.message.toString());
    
  }
  
  if(Credential!= null){
    String uid = Credential.user!.uid;
    UserModel newUser = UserModel(
       uid: uid,
       email: email,
       fullname: "",
       profilepic: "",
    );

    await FirebaseFirestore.instance.collection("users").doc(uid).set(newUser.toMap()).then((value) {
      print("new user created");
       Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CompletePage(userModel: newUser, firebaseUser: Credential!.user!);
          }
           ),
        );
    });
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
               SizedBox(height: 10,),
              TextField(
                controller: CpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm password",
                ),
              ),
              SizedBox(height: 20,),

              ElevatedButton(
                onPressed: () {

                  checkValues();
                 /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder : (context) {
                      return CompletePage();
                      }
                      ),
                      );*/
                },
                
                 child: Text(
                  "Sign Up",
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
          Text("Already have an account?",
          style: TextStyle(
            fontSize: 16,
          ),
          ),
          CupertinoButton(
            child: Text("Log In",
            style: TextStyle(
              fontSize: 16,
            ),), 
            onPressed: () {
              Navigator.pop(context);
            
            },
            )
        ],
      ),
     ),

    );
  }
}