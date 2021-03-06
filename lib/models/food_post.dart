class FoodPost {
  DateTime? date;
  String? imageURL;
  int? quantity;
  double? latitude;
  double? longitude;

  FoodPost();

  FoodPost.fromMap(Map map) {
    date = map["date"];
    imageURL = map["imageURL"];
    quantity = map["quantity"];
    latitude = map["latitude"];
    longitude = map["longitude"];
  }
}
