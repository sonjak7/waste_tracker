import 'post_object.dart';
import 'package:test/test.dart';

void main() {
  test('Initialized post_object should return correct values', () {
    final date = DateTime.now().toString();
    const imageURL = 'randomURL';
    const quantity = 5;
    const latitude = 10.24;
    const longitude = 23.62;

    final newPost = ShowPost(date, imageURL, quantity, latitude, longitude);

    expect(date, newPost.date);
    expect(imageURL, newPost.imageURL);
    expect(quantity, newPost.quantity);
    expect(latitude, newPost.latitude);
    expect(longitude, newPost.longitude);
  });

  test('Expect conversion from/to string does not alter date', () {
    const date = '2022-03-07 19:16:56.026383';
    const imageURL = 'randomURL';
    const quantity = 5;
    const latitude = 10.24;
    const longitude = 23.62;

    final newPost = ShowPost(date, imageURL, quantity, latitude, longitude);

    final newPostDate = DateTime.parse(newPost.date);
    final newPostString = newPostDate.toString();

    expect(date, newPostString);
  });
}