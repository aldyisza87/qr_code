// buat model dari database collections firestore dengan (quicktype.io)
class ProductModel {
  //make all properties is final
  final String code;
  final String name;
  final String productId;
  final int qty;

  ProductModel({
    // make all properties is required
    required this.code,
    required this.name,
    required this.productId,
    required this.qty,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        code: json["code"] ?? "",
        name: json["name"] ?? "",
        productId: json["productId"] ?? "",
        // cek apakah qty produk != null jika null maka nilai default = 0
        qty: json["qty"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "productId": productId,
        "qty": qty,
      };
}
