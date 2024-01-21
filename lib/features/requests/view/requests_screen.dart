import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/features/requests/widgets/requests_widgets.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants.dart';
import '../../drawer/drawer_sceen.dart';
import '../view_model/cubit/requests_cubit.dart';

class RequestsScreen extends StatelessWidget {
  RequestsScreen({super.key, required this.docType, this.expenseType});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final String docType;
  final String? expenseType;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      endDrawer: const DrawerScreen(
        screenName: "Requests",
      ),
      body: Column(
        children: [
          CustAppBar(
              title: "Requests",
              scaffoldKey: scaffoldKey,
              imageSrc: "requests_icon"),
          Expanded(
            child: BlocProvider(
              create: (contextt) => RequestsCubit()
                ..changeStatus(docType, "Pending", expenseType),
              child: BlocBuilder<RequestsCubit, RequestsState>(
                builder: (contextt, state) {
                  var cubit = RequestsCubit.get(contextt);
                  return Column(
                    children: [
                      Card(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 0, 20, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(contextt);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: imageSvg(
                                            src: "back_icon", size: 20),
                                      )),
                                  Expanded(
                                      child: Text(
                                    "${cubit.requestName(docType, expenseType)} requests",
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: primaryColor),
                                  )),
                                  Text(
                                    state is GetAllRequestsLoadingState
                                        ? ""
                                        : cubit.requestsData.length.toString(),
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: ["Pending", "Approved", "Rejected"]
                                      .map(
                                        (e) => TextButton(
                                            onPressed: () {
                                              cubit.changeStatus(
                                                  docType, e, expenseType);
                                            },
                                            child: Text(
                                              e,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: cubit.screenType == e
                                                      ? secondryColor
                                                      : Colors.grey),
                                            )),
                                      )
                                      .toList())
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: cubit.requestsData.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsetsDirectional.fromSTEB(
                                  15, 10, 10, 10),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20, 8, 20, 8),
                                child: Row(children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cubit.requestsData[index].repName
                                            .toString(),
                                        style: const TextStyle(
                                            fontFamily:
                                                FontFamilyStrings.ROBOTO_BOLD,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        cubit.requestsData[index].postingDate
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )),
                                  Container(
                                      width: 1,
                                      height: 50,
                                      color: primaryColor),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  PrimaryButton(
                                      color: const Color(0xff13B824),
                                      title: "Details",
                                      onTap: () {
                                        requestsDialog(
                                            contextt: contextt,
                                            requestsDetailsModel:
                                                cubit.requestsData[index],
                                            docType: docType);
                                      })
                                ]),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
