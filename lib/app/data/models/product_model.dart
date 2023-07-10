// buat model dari database collections firestore dengan (quicktype.io)
class ProductModel {
  //make all properties is final
  final String code;
  final String name;
  final String productId;
  final String address;

  ProductModel({
    // make all properties is required
    required this.code,
    required this.name,
    required this.productId,
    required this.address,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        productId: json["productId"] ?? "",
        address: json["address"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "productId": productId,
        "address": address,
      };
}
