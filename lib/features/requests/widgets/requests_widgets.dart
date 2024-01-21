import 'package:data_soft/features/requests/view_model/cubit/requests_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_soft/core/app_enums.dart';
import 'package:data_soft/core/app_switches.dart';
import '../../../core/app_datetime.dart';
import '../../../core/app_fonts.dart';
import '../../../core/constants.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../model/request_details_model.dart';

requestsDialog(
    {required BuildContext contextt,
    required RequestsDetailsModel requestsDetailsModel,
    required String docType}) {
  showDialog(
      context: contextt,
      builder: (context) => Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          width: 300,
                          margin: const EdgeInsets.only(bottom: 25),
                          padding: const EdgeInsets.only(bottom: 25),
                          decoration: BoxDecoration(
                              borderRadius: borderRadius, color: bgColor),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: selectGradientColor(
                                        SelectColor.APPROVED),
                                    begin: const FractionalOffset(0.5, 0.5),
                                    end: const FractionalOffset(0.0, 0.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            imageSvg(src: "arrow_left_circle"),
                                      ),
                                    ),
                                    const Text(
                                      'REQUESTS DETAILS',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 0,
                                      width: 30,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Applicant",
                                            style: TextStyle(
                                              fontFamily: FontFamilyStrings
                                                  .ARIAL_REGULAR,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            docType == "Opportunity"
                                                ? DateTimeFormating
                                                    .formatCustomDate(
                                                        date:
                                                            requestsDetailsModel
                                                                .postingDate,
                                                        formatType:
                                                            "dd MMM yyyy")
                                                : requestsDetailsModel
                                                    .postingDate!,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Color(0xff515C6F)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: CupertinoTextField(
                                            decoration: decorationOfTextFeild,
                                            enabled: false,
                                            style: const TextStyle(
                                                fontFamily: FontFamilyStrings
                                                    .ARIAL_LIGHT,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 14),
                                            controller: TextEditingController(
                                                text: requestsDetailsModel
                                                    .repName),
                                          )),
                                          const SizedBox(
                                            width: 60,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Request Type",
                                            style: TextStyle(
                                                fontFamily: FontFamilyStrings
                                                    .ARIAL_REGULAR,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Color(0xff515C6F)),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                requestsDetailsModel.type ?? "",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xffA8ACAF),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      if (requestsDetailsModel.amount != null)
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      if (requestsDetailsModel.amount != null)
                                        const Text(
                                          "Amount",
                                          style: TextStyle(
                                              fontFamily: FontFamilyStrings
                                                  .ARIAL_REGULAR,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                              color: Color(0xff515C6F)),
                                        ),
                                      if (requestsDetailsModel.amount != null)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: CupertinoTextField(
                                                decoration:
                                                    decorationOfTextFeild,
                                                enabled: false,
                                                style: const TextStyle(
                                                    fontFamily:
                                                        FontFamilyStrings
                                                            .ARIAL_LIGHT,
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 14),
                                                controller:
                                                    TextEditingController(
                                                        text:
                                                            requestsDetailsModel
                                                                .amount),
                                              )),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                width: 90,
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.all(9),
                                                decoration:
                                                    decorationOfTextFeild,
                                                child: const Text(
                                                  "LE",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          FontFamilyStrings
                                                              .ARIAL_REGULAR,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16,
                                                      color: Color(0xff515C6F)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (requestsDetailsModel.clientName !=
                                          null)
                                        custCupertinoTextField(
                                            title: "Client",
                                            controller: TextEditingController(
                                                text: requestsDetailsModel
                                                    .clientName),
                                            isDisabled: false,
                                            textInputType: TextInputType.none,
                                            fontSize: 16),
                                      if (requestsDetailsModel.comment != null)
                                        CustCommentTextField(
                                          onTap: null,
                                          controller: TextEditingController(
                                              text:
                                                  requestsDetailsModel.comment),
                                          isClickable: false,
                                          showAttachFile: false,
                                        ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        BlocProvider.value(
                          value: BlocProvider.of<RequestsCubit>(contextt),
                          child: BlocBuilder<RequestsCubit, RequestsState>(
                            builder: (contextt, state) {
                              var cubit = RequestsCubit.get(contextt);
                              return SizedBox(
                                width: 280,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          cubit.updateRequests(context,
                                              docTypeName: docType,
                                              requestsDetailsModel:
                                                  requestsDetailsModel,
                                              status: true);
                                        },
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: selectColor(
                                                SelectColor.APPROVED),
                                          ),
                                          child: const Text(
                                            "ACCEPT",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          cubit.updateRequests(context,
                                              docTypeName: docType,
                                              requestsDetailsModel:
                                                  requestsDetailsModel,
                                              status: false);
                                        },
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: selectColor(
                                                SelectColor.REJECTED),
                                          ),
                                          child: const Text(
                                            "REJECTED",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
}
