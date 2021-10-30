import 'package:flutter/material.dart';

class UserModel {
  final String? name, image,uid;

  UserModel({@required this.name, @required this.image, this.uid});

  static UserModel fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] as String,
      image: data['image'] as String,
      uid: data["uid"] as String,
    );
  }
}

// Demo List of Top Travelers
List<UserModel> topTravelers = [user1, user2, user3, user4];

// demo user
UserModel user1 = UserModel(name: "James", image: "assets/images/james.png");
UserModel user2 = UserModel(name: "John", image: "assets/images/John.png");
UserModel user3 = UserModel(name: "Marry", image: "assets/images/marry.png");
UserModel user4 = UserModel(name: "Rosy", image: "assets/images/rosy.png");
