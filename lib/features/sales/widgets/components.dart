import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import '../../../core/constants.dart';
import '../view_model/cubit/sales_cubit.dart';

class HeaderContent extends StatelessWidget {
  const HeaderContent({
    super.key,
    required this.title,
    required this.countName,
    required this.count,
    required this.onTap,
    required this.isOpen,
  });

  final String title;
  final String countName;
  final String count;
  final bool isOpen;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(top: 15),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  countName,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(
              width: 30,
            ),
            GestureDetector(
              onTap: onTap,
              child: RotatedBox(
                quarterTurns: isOpen ? 90 : 0,
                child: const CircleAvatar(
                  radius: 12.5,
                  backgroundColor: Color(0xff727C8E),
                  child: Icon(Icons.keyboard_arrow_down_outlined,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class bodyContent extends StatelessWidget {
  const bodyContent(
      {super.key,
      required this.index,
      required this.title,
      required this.subTitle,
      required this.count,
      this.isEnd = false});
  final int index;
  final String title;
  final String subTitle;
  final String count;
  final bool isEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 17.5),
      child: Row(
        children: [
          SizedBox(
            height: 70.0,
            child: TimelineNode.simple(
              drawEndConnector: !isEnd,
              color: primaryColor,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(subTitle,
                          style: TextStyle(
                              color: const Color(0xff172735).withOpacity(0.7))),
                    ],
                  ),
                ),
                SizedBox(
                  width: 85,
                  child: Text(
                    count,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: secondryColor),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DistrictPharmacies extends StatelessWidget {
  const DistrictPharmacies({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<SalesCubit>(context),
      child: BlocBuilder<SalesCubit, SalesStates>(
        builder: (context, state) {
          var cubit = SalesCubit.get(context);
          return Padding(
            padding: const EdgeInsets.fromLTRB(12.5, 0, 15, 15),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cubit.productsFilterModel.length,
              itemBuilder: (context, index1) => Column(
                children: [
                  HeaderContent(
                    title: cubit.productsFilterModel[index1].area.toString(),
                    countName: cubit.isUintData ? "Total Units" : "Accounts",
                    count: cubit.isUintData
                        ? numbersFormat(cubit.productsFilterModel[index1].units)
                        : cubit.productsFilterModel[index1].data.length
                            .toString(),
                    isOpen: cubit.productsFilterModel[index1].isOpen == true,
                    onTap: () {
                      cubit.changeProductState(index1);
                    },
                  ),
                  if (cubit.productsFilterModel[index1].isOpen!)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cubit.productsFilterModel[index1].data.length,
                      itemBuilder: (context, index2) {
                        return Column(
                          children: [
                            bodyContent(
                              index: index2,
                              title: cubit.productsFilterModel[index1]
                                  .data[index2].accountName
                                  .toString(),
                              subTitle: cubit.productsFilterModel[index1]
                                  .data[index2].accountType
                                  .toString(),
                              count: numbersFormat(cubit.isUintData
                                  ? cubit.productsFilterModel[index1]
                                      .data[index2].totalUnit
                                  : cubit.productsFilterModel[index1]
                                      .data[index2].totalValue),
                              isEnd: false,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: cubit.productsFilterModel[index1]
                                  .data[index2].product2.length,
                              itemBuilder: (context, index3) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    verticalLine(
                                        height: index1 == 0 &&
                                                index2 == 2 &&
                                                index3 == 2
                                            ? 100
                                            : 40,
                                        color: primaryColor),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 10,
                                            height: 2,
                                            color: Colors.blue,
                                            margin: EdgeInsets.zero,
                                          ),
                                          const Icon(
                                            Icons.circle,
                                            color: Colors.blue,
                                            size: 15,
                                          ),
                                          Expanded(
                                            child: Text(
                                              cubit
                                                  .productsFilterModel[index1]
                                                  .data[index2]
                                                  .product2[index3]
                                                  .productName
                                                  .toString(),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 95,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                  numbersFormat(cubit.isUintData
                                                      ? cubit
                                                          .productsFilterModel[
                                                              index1]
                                                          .data[index2]
                                                          .product2[index3]
                                                          .quantity
                                                      : cubit
                                                          .productsFilterModel[
                                                              index1]
                                                          .data[index2]
                                                          .product2[index3]
                                                          .amount),
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.red)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// class PharmaciesMedicinesBody extends StatelessWidget {
//   const PharmaciesMedicinesBody({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
//       child: ListView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: 5,
//         itemBuilder: (context, index) => Column(
//           children: [
//             HeaderContent(
//               title: "One-Alpha® 0.5 mcg Caps",
//               countName: "Total Units",
//               count: '1400',
//               isOpen: false,
//               onTap: () {},
//             ),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: 3,
//               itemBuilder: (context, index) => bodyContent(
//                   index: index,
//                   title: "El-Ezaby Pharmacy",
//                   subTitle: "Nasr city 1",
//                   count: "1400"),
//             ),
//             const Divider(
//               thickness: 2,
//               height: 20,
//             ),
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Total Value",
//                   style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                 ),
//                 Text(
//                   "70,200.00",
//                   style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: primaryColor),
//                 ),
//                 Text(
//                   "Target Value",
//                   style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black),
//                 ),
//                 SizedBox(
//                   width: 0,
//                   height: 0,
//                 ),
//                 Text(
//                   "75,000.00",
//                   style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: primaryColor),
//                 ),
//                 SizedBox(
//                   width: 0,
//                   height: 0,
//                 ),
//                 Wrap(
//                   children: [
//                     Text(
//                       "%",
//                       style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black),
//                     ),
//                     Text(
//                       "107",
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: primaryColor),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//             const Divider(
//               thickness: 2,
//               height: 20,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

numbersFormat(number) {
  var f = NumberFormat.compact();
  return f.format(number);
}
