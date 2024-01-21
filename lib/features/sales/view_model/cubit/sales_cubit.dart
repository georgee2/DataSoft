// ignore_for_file: iterable_contains_unrelated_type

import 'package:data_soft/core/end_points.dart';
import 'package:data_soft/core/networks/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../core/app_datetime.dart';
import '../../model/distributions_model.dart';
import '../../model/product_filtered_model.dart';
import '../../model/sales_product_model.dart';
part 'sales_state.dart';

class SalesCubit extends Cubit<SalesStates> {
  SalesCubit() : super(SalesInitialState());
  static SalesCubit get(BuildContext context) => BlocProvider.of(context);
  SalesProductModel? salesProductModel;
  DistributionModel? distributionModel;
  List<ProductsFilterModel> productsFilterModel = [];
  String? timeSelected;
  Product2? product2;
  String? birckSelected;
  String? distributionSelected;
  bool dataIsGot = false;
  bool isUintData = false;
  DateTime? fromDate;
  DateTime? toDate;

  changeProductState(index1) {
    productsFilterModel[index1].isOpen = !productsFilterModel[index1].isOpen!;
    emit(ChangeProductState());
  }

  getDistributions() async {
    Response response =
        await DioHelper.getData(url: EndPoints.GET_SALES_DISTRIBUTION);
    distributionModel = DistributionModel.fromJson(response.data);
    distributionSelected = distributionModel?.message?.data[0];
  }

  getProducts({bool? isFilttering}) async {
    if (isFilttering == null) {
      timeSelected = null;
      product2 = null;
      birckSelected = null;
      distributionSelected = null;
      fromDate = null;
      toDate = null;
    }
    salesProductModel = null;
    productsFilterModel = [];
    try {
      emit(GetSalesLoadingState());
      Map<String, dynamic> data = {
        "product": product2?.product,
        "account_type": timeSelected,
        "account_name": birckSelected,
        "from_date": fromDate == null
            ? null
            : DateTimeFormating.sendFormatDate(fromDate),
        "to_date":
            toDate == null ? null : DateTimeFormating.sendFormatDate(toDate)
      };
      Response response = await DioHelper.getData(
          url: EndPoints.GET_SALES, queryParameters: data);
      salesProductModel = SalesProductModel.fromJson(response.data);
      if (salesProductModel!.message != null) {
        productsFiltering();
        emit(GetSalesSuccessState());
        if (!dataIsGot) {
          getProductsList();
        }
      } else {
        emit(GetSalesErrorState());
      }
    } catch (e) {
      emit(GetSalesErrorState());
    }
  }

  changeDate(context) {
    showDialog(
      context: context,
      builder: (context) {
        dynamic start, end;
        return Dialog(
          child: SizedBox(
            height: 370,
            width: 350,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: SfDateRangePicker(
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      start = args.value.startDate;
                      end = args.value.endDate;
                    },
                    selectionMode: DateRangePickerSelectionMode.extendableRange,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        if (start != null && end != null) {
                          fromDate = start;
                          toDate = end;
                          getProducts(isFilttering: false);
                          Navigator.pop(context);
                          emit(ChangeDateTimeState());
                        }
                      },
                    ),
                    TextButton(
                      child: const Text("CANCEL"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  productsFiltering() {
    bool fiteringSwitch = false;
    if (salesProductModel != null) {
      for (var element in salesProductModel!.message!.data) {
        if (productsFilterModel.isNotEmpty) {
          for (var i = 0; i != productsFilterModel.length; i++) {
            if (productsFilterModel[i].area == element.distributionPlaces) {
              productsFilterModel[i].data.add(element);
              productsFilterModel[i].units =
                  productsFilterModel[i].units + (element.totalUnit ?? 0.0);
              break;
            } else if (fiteringSwitch == false &&
                i != productsFilterModel.length) {
              productsFilterModel.add(ProductsFilterModel(
                  units: element.totalUnit ?? 0.0,
                  area: element.distributionPlaces,
                  data: [element],
                  isOpen: false));
              fiteringSwitch = true;
              break;
            }
          }
        } else {
          productsFilterModel.add(ProductsFilterModel(
              units: element.totalUnit ?? 0.0,
              area: element.distributionPlaces,
              data: [element],
              isOpen: false));
        }
      }
    }
  }

  List<Product2> productsList = [Product2(productName: "All")];
  List brickList = ["All"];
  getProductsList() {
    dataIsGot = true;
    for (var a = 0; a < productsFilterModel.length; a++) {
      for (var b = 0; b < productsFilterModel[a].data.length; b++) {
        if (!brickList.contains(productsFilterModel[a].data[b].accountName)) {
          brickList.add(productsFilterModel[a].data[b].accountName);
        }
        for (var c = 0;
            c < productsFilterModel[a].data[b].product2.length;
            c++) {
          if (productsFilterModel[a].data[b].product2[c].productName != null &&
              !productsList.contains(
                  productsFilterModel[a].data[b].product2[c].productName)) {
            productsList.add(productsFilterModel[a].data[b].product2[c]);
          }
        }
      }
    }
  }

  changeFilterTime(val) {
    if (val == "AM Only") {
      timeSelected = "AM";
    } else if (val == "PM Only") {
      timeSelected = "PM";
    } else {
      timeSelected = null;
    }
    emit(ChangeTimeState());
  }

  changeUintsData(val) {
    isUintData = val;
    emit(ChangeUintsState());
  }

  changeFilterProduct(Product2 val) {
    if (val.productName == "All") {
      product2 = null;
    } else {
      product2 = val;
    }
    emit(ChangeFilterProductState());
  }

  changeFilterBrick(val) {
    if (val == "All") {
      birckSelected = null;
    } else {
      birckSelected = val;
    }
    emit(ChangeFilterBrickState());
  }

  changeFilterDistributor(val) {
    if (distributionSelected == "All") {
      distributionSelected = null;
    } else {
      distributionSelected = val;
    }
    emit(ChangeFilterDistributorsState());
  }
}
