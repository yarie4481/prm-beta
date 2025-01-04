import 'dart:convert';

class Property {
  final String id;
  final String title;
  final String description;
  final String address;
  final int price;
  final int rentPrice;
  final int numberOfUnits;
  final String propertyType;
  final String floorPlan;
  // final List<String> amenities;
  // final List<String> photos;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.price,
    required this.rentPrice,
    required this.numberOfUnits,
    required this.propertyType,
    required this.floorPlan,
    // required this.amenities,
    // required this.photos,
  });
  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? "",
      address: json['address'] ?? "",
      price: json['price'] ?? "",
      rentPrice: json['rentPrice'] ?? "",
      numberOfUnits: json['numberOfUnits'] ?? "",
      propertyType: json['propertyType'] ?? "",
      floorPlan: json['floorPlan'] ?? "",
      // amenities:
      //     json['amenities'] != null && json['amenities'].isNotEmpty
      //         ? List<String>.from(jsonDecode(json['amenities'][0]))
      //         : [],
      // photos: json['photos'] != null ? List<String>.from(json['photos']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'address': address,
      'price': price,
      'rentPrice': rentPrice,
      'numberOfUnits': numberOfUnits,
      'propertyType': propertyType,
      'floorPlan': floorPlan,
      // 'amenities': amenities,
      // 'photos': photos,
    };
  }
}
