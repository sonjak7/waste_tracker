import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../post_object.dart';
import '../screens/post_info.dart';
import '../screens/preview_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listPosts(),
      appBar: AppBar(
        title: const Text('Waste Tracker'),
      ),
      floatingActionButton: addPostButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }

  Widget listPosts() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var post = snapshot.data!.docs[index];
              final currPost = ShowPost(
                timestampToString(post['date']),
                post['imageURL'],
                post['quantity'],
                post['latitude'],
                post['longitude']
              );
              return ListTile(
                title: Text(currPost.date, style: const TextStyle(fontSize: 22)),
                trailing: Text(currPost.quantity.toString(),
                  style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 223, 223, 223))),
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PostInfo(currPost: currPost)
                  )) 
                }
              );
            }
          );
        }
        else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget addPostButton() {
    return Semantics(
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const PreviewPost()
          ));
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.camera_alt),
      ),
      button: true,
      enabled: true,
      onTapHint: 'Select an image to post',
    );
  }

  String timestampToString(Timestamp timestamp) {
    final dateTime = DateTime.parse(timestamp.toDate().toString());
    return DateFormat('EEEE, MMMM d, yyyy').format(dateTime);
  }
}
