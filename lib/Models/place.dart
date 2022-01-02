class Place {
  late String placeName;
  late String placeId;
  Place.fromJson(Map<String, dynamic> map) {
    placeName = map['placeName'];
    placeId = map['placeId'];
  }
}
