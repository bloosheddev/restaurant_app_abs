class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      pictureId: json["pictureId"],
      city: json["city"],
      rating: json["rating"].toString(),
    );
  }
  factory Restaurant.fromDBJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      pictureId: json["picture_id"],
      city: json["city"],
      rating: json["rating"].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "description": description,
      "pictureId": pictureId,
      "city": city,
      "rating": rating,
    };
  }
}

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String rating;
  final String address;
  final List foods;
  final List drinks;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.address,
    required this.foods,
    required this.drinks,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      pictureId: json["pictureId"],
      city: json["city"],
      rating: json["rating"].toString(),
      address: json["address"],
      foods: json["menus"]["foods"],
      drinks: json["menus"]["drinks"],
    );
  }
  factory RestaurantDetail.fromDBJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      pictureId: json["picture_id"],
      city: json["city"],
      rating: json["rating"],
      address: "",
      foods: [],
      drinks: [],
    );
  }

  Map<String, dynamic> toDBJson() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "description": description,
      "picture_id": pictureId,
      "city": city,
      "rating": rating,
    };
  }
}
