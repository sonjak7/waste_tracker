import 'package:flutter/material.dart';
import '../post_object.dart';

class PostInfo extends StatelessWidget {
  const PostInfo({ Key? key, required this.currPost }) : super(key: key);

  final ShowPost currPost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: showDetails(context)
    );
  }

  Widget showDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Text(currPost.date, style: const TextStyle(fontSize: 32), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          SizedBox(
            height: 375,
            child: Image.network(currPost.imageURL),
          ),
          const SizedBox(height: 20),
          Text('# of wasted items: ${currPost.quantity.toString()}', style: const TextStyle(fontSize: 25), textAlign: TextAlign.center),
          const SizedBox(height: 26),
          Text('Location: (${currPost.latitude.toString()}, ${currPost.longitude.toString()})', 
            style: const TextStyle(fontSize: 20))
        ]
      )
    );
  }
}