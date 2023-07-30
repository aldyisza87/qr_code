// buat model dari database collections firestore dengan (quicktype.io)
class ProductModel {
  //make all properties is final
  final String code;
  final String name;
  final String merek;
  final String kondisi;
  final String productId;
  final String address;
  final String note;

  ProductModel({
    // make all properties is required
    required this.code,
    required this.name,
    required this.merek,
    required this.kondisi,
    required this.productId,
    required this.address,
    required this.note,
  });
  // Konversi dari Firestore DocumentSnapshot ke Model Aset
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        merek: json["merek"] ?? "",
        kondisi: json["kondisi"] ?? "",
        productId: json["productId"] ?? "",
        address: json["address"] ?? "",
        note: json["note"] ?? "",
      );
// Konversi Model Aset ke Json untuk ditambahkan ke Firestore
  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "merek": merek,
        "kondisi": kondisi,
        "productId": productId,
        "address": address,
        "note": note,
      };
}
