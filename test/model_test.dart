import 'package:test/test.dart';
import 'package:wasteagram/models/food_post.dart';

void main() {
  test("Post built from map should have appropriate values", () {
    final date = DateTime.parse("2022-02-02");
    const imageURL = "url";
    const quantity = 5;
    const latitude = 1.2;
    const longitude = 3.4;

    final post = FoodPost.fromMap({
      "date": date,
      "imageURL": imageURL, 
      "quantity": quantity,
      "latitude": latitude,
      "longitude": longitude
    });

    expect(post.date, date);
    expect(post.imageURL, imageURL);
    expect(post.quantity, quantity);
    expect(post.latitude, latitude);
    expect(post.longitude, longitude);
  });

  test("Post built with manual setters should have appropriate values", () {
    final date = DateTime.parse("2022-02-02");
    const imageURL = "url";
    const quantity = 5;
    const latitude = 1.2;
    const longitude = 3.4;

    final post = FoodPost();
    post.date = date;
    post.imageURL = imageURL;
    post.quantity = quantity;
    post.latitude = latitude;
    post.longitude = longitude;

    expect(post.date, date);
    expect(post.imageURL, imageURL);
    expect(post.quantity, quantity);
    expect(post.latitude, latitude);
    expect(post.longitude, longitude);
  });
}
