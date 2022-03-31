import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class PreviewPost extends StatefulWidget {
  const PreviewPost({ Key? key }) : super(key: key);

  @override
  State<PreviewPost> createState() => _PreviewPostState();
}

class _PreviewPostState extends State<PreviewPost> {

  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Tracker'),
      ),
      body: postDetails(),
    );
  }

  Widget postDetails() {
    if(image != null) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 360,
              child: Image.file(image!)
            ),
            const SizedBox(height: 16),
            QuantityForm(image: image)
          ],
        )
      );
    }
    else{
      getImage();
      return Container();
    }
  }

  void getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if(pickedFile != null){
      image = File(pickedFile.path);
      setState(() {});
    }
    else{
      Navigator.of(context).pop(); 
    }
  }
}

class QuantityForm extends StatefulWidget {
  const QuantityForm({ Key? key, required this.image }) : super(key: key);

  final File? image;

  @override
  State<QuantityForm> createState() => _QuantityFormState(image);
}

class _QuantityFormState extends State<QuantityForm> {

  int quantity = 0;
  final formKey = GlobalKey<FormState>();
  File? image;

  _QuantityFormState(this.image);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 8),
            quantityField(context),
            const SizedBox(height: 8),
            saveButton(context),
          ],
        ),
      )
    );
  }

  Widget quantityField(BuildContext context){
    return TextFormField(
      keyboardType: TextInputType.number,
      autofocus: true,
      decoration: const InputDecoration(
        labelText: 'Number of Items', border: OutlineInputBorder()
      ),
      onSaved: (value) {
        final intVal = int.parse(value!);
        quantity = intVal;
        setState( () {} );
      },
      validator: (value) {
        if(value == null || value == '') {
          return 'Please enter a value';
        }
        else {
          return null;
        }
      },
    );
  }

  Widget saveButton(BuildContext context){
    return SizedBox(
      width: double.infinity,
      height: 90,
      child: Semantics(
        child: ElevatedButton(
          child: const Icon(Icons.cloud_upload_outlined, size: 80),
          onPressed: () async {
            if(formKey.currentState!.validate()) {
              formKey.currentState!.save();
              FirebaseStorage storage = FirebaseStorage.instance;
              Reference ref = storage.ref().child("img" + DateTime.now().toString());
              UploadTask uploadTask = ref.putFile(image!);
              uploadTask.then((res) async {
                String imageURL = await res.ref.getDownloadURL();
                pushToFirestore(imageURL, quantity);
              });
              Navigator.of(context).pop();
            }
          }
        ),
        button: true,
        enabled: true,
        onTapHint: 'Upload post',
      )
    );
  }

  void pushToFirestore(String imageURL, int quantity) async {
    final date = DateTime.now();
    LocationData locationData = await Location().getLocation();
    final latitude = locationData.latitude;
    final longitude = locationData.longitude;

    FirebaseFirestore.instance.collection('posts').add({
      'date': date,
      'imageURL': imageURL,
      'latitude': latitude,
      'longitude': longitude,
      'quantity': quantity
    });
  }
}