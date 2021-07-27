class Medicine {
  String id;
  String category;
  String product;
  String stock;

  Medicine({this.id, this.category, this.product, this.stock});

  factory Medicine.fromJsonResponse(Map<String, dynamic> response) {
    return Medicine(
        id: response['_id'],
        category: response['category'],
        product: response['product'],
        stock: response['stock']);
  }
}
