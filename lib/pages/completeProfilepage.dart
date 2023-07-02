
import 'dart:io';

import 'package:chatapplication/HomePage.dart';
import 'package:chatapplication/models/UIhelper.dart';
import 'package:chatapplication/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CompletePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompletePage({super.key, required this.userModel, required this.firebaseUser});
  

  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {

   CroppedFile? imageFile;

  TextEditingController fullnameController = TextEditingController();

  void SelectImage(ImageSource source)async{
   XFile? pickedFile = await ImagePicker().pickImage(source: source);

   if(pickedFile!=null){
    CropImage(pickedFile);
   }
  }

  void CropImage(XFile file) async {
    CroppedFile? croppedImage =  await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 15,
      );
     
     if(croppedImage!=null){
      setState(() {
        imageFile = croppedImage;
      });
     }
  }

  void showPhotoOption(){
    showDialog(context: context, builder: (context){
       return AlertDialog(
        title: Text("Upload Profile Picture"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.pop(context);
                SelectImage(ImageSource.camera);
              },
              leading: Icon(Icons.camera_alt),
              title: Text("Take a Photo"),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                SelectImage(ImageSource.gallery);
              },
              leading: Icon(Icons.photo_album),
              title: Text("Choose from Gallery"),
            ),
          ],
        ),
       );
    });
  }

  void checkValues() {
    String fullname = fullnameController.text.trim();

    if(fullname == "" || imageFile == ""){
      //print("please fill all the fields !!");
      UIhelper.showAlertDialog(context, "Incomplete Data", "please uploade profilepic and write fullname");
    }
     else{
       UploadData();
     }
  }

  void UploadData() async{
    UIhelper.showLoadingDialog(context, "Uploading Image..");
       UploadTask uploadTask = FirebaseStorage.instance.ref("profilePictures").child(widget.userModel.uid.toString()).putFile(File(imageFile!.path));
      
      TaskSnapshot snapshot = await uploadTask;

      String? imageUrl = await snapshot.ref.getDownloadURL();
      String? fullname = fullnameController.text.trim();

      widget.userModel.fullname = fullname;
      widget.userModel.profilepic = imageUrl;

      await FirebaseFirestore.instance.collection("users").doc(widget.userModel.uid).set(widget.userModel.toMap()).then((value) {
        //data uploaded!!
         Navigator.popUntil(context, (route) => route.isFirst);
       Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context){
              return HomePage(userModel: widget.userModel, firebaseUser: widget.firebaseUser);
            }
            )
          
          );
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Complete profile"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric( horizontal: 40),
          child: ListView(
            children: [
              SizedBox(height: 30,),
        CupertinoButton(
          onPressed: () {
            showPhotoOption();
          },
              child: CircleAvatar(
                radius: 60,
                backgroundImage:(imageFile != null) ? FileImage(File(imageFile!.path)):null,
                child: (imageFile == null)? Icon(Icons.person_add_alt_1_outlined,size: 60) : null,
              ),
          ),
              TextFormField(
                controller: fullnameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  checkValues();
                },
                
                 child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  
                  ) 
                 
                 ),
            ],
          ),
        ),
        ),
    );
  }
}