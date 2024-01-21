import 'package:data_soft/features/sales/model/sales_product_model.dart';

class ProductsFilterModel {
  String? area;
  List<ProductData> data = [];
  double units = 0.0;
  bool? isOpen;

  ProductsFilterModel({
    required this.area,
    required this.data,
    required this.isOpen,
    required this.units,
  });
}
