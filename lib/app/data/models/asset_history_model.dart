class AssetHistory {
  String name;
  String address;

  AssetHistory({required this.name, required this.address});

  factory AssetHistory.fromJson(Map<String, dynamic> json) => AssetHistory(
        name: json["name"] ?? "",
        address: json["address"] ?? "",
      );
// Konversi Model Aset ke Json untuk ditambahkan ke Firestore
  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
      };
}
