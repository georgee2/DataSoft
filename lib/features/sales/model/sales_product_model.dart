class SalesProductModel {
  Message? message;

  SalesProductModel({this.message});

  SalesProductModel.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }
}

class Message {
  bool? success;
  List<ProductData> data = [];
  double totalValue = 0.0;
  double totalTarget = 0.0;
  double totalUnit = 0.0;
  double targetUnit = 0.0;

  Message({this.success, required this.data});

  Message.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data.add(ProductData.fromJson(v));
      });
      for (var i = 0; i < data.length; i++) {
        totalValue = totalValue + (data[i].totalValue ?? 0.0);
        totalTarget = totalTarget + (data[i].targetValue ?? 0.0);
        totalUnit = totalUnit + (data[i].totalUnit ?? 0.0);
        targetUnit = targetUnit + (data[i].targetUnit ?? 0.0);
      }
    }
  }
}

class ProductData {
  String? name;
  String? accountType;
  String? accountName;
  String? fromDate;
  String? toDate;
  String? distributionPlaces;
  double? totalUnit;
  double? totalValue;
  double? targetUnit;
  double? targetValue;
  List<Product2> product2 = [];

  ProductData(
      {this.name,
      this.accountType,
      this.accountName,
      this.fromDate,
      this.toDate,
      this.distributionPlaces,
      this.totalUnit,
      this.totalValue,
      this.targetValue,
      required this.product2});

  ProductData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    accountType = json['account_type'];
    accountName = json['account_name'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    distributionPlaces = json['distribution_places'];
    totalUnit = json['total_unit'];
    totalValue = json['total_value'];
    targetValue = json['target_value'];
    targetUnit = json['target_units'];
    if (json['product2'] != null) {
      product2 = <Product2>[];
      json['product2'].forEach((v) {
        product2.add(Product2.fromJson(v));
      });
    }
  }
}

class Product2 {
  String? product;
  String? productName;
  double? quantity;
  double? amount;

  Product2({this.product, this.productName, this.quantity, this.amount});

  Product2.fromJson(Map<String, dynamic> json) {
    product = json['product'];
    productName = json['product_name'];
    quantity = json['quantity'];
    amount = json['amount'];
  }
}
