import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/features/poc/view_model.dart/cubit/poc_cubit.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

import '../model/poc_model.dart';

class PocScreen extends StatelessWidget {
  PocScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      endDrawer: const DrawerScreen(
        screenName: "POC",
      ),
      body: Column(
        children: [
          CustAppBar(
            title: "pocTitle".i18n(),
            scaffoldKey: scaffoldKey,
            imageSrc: 'poc_icon',
          ),
          Expanded(
              child: BlocProvider(
            create: (context) => PocCubit()..getPoc(),
            child: BlocBuilder<PocCubit, PocStates>(
              builder: (context, state) {
                var cubit = PocCubit.get(context);
                return ConditionalBuilder(
                  condition: cubit.pocModel != null,
                  builder: (context) => cubit.pocData.isEmpty
                      ? noDataFound(context, type: "POC")
                      : ListView.builder(
                          itemCount: cubit.pocData.length,
                          itemBuilder: (context, areaIndex) {
                            List<POCDataModel> data =
                                cubit.pocData[areaIndex]['data'];
                            return Column(
                              children: [
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(cubit.pocData[areaIndex]['address'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor)),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          cubit.changeItemState(areaIndex);
                                        },
                                        child: RotatedBox(
                                          quarterTurns: cubit.pocData[areaIndex]
                                                      ['isShow'] ==
                                                  true
                                              ? 90
                                              : 0,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: imageSvg(src: 'arrow_down'),
                                          ),
                                        ))
                                  ],
                                ),
                                const SizedBox(height: 15),
                                if (cubit.pocData[areaIndex]['isShow'] == true)
                                  Container(
                                    width: double.infinity,
                                    color: const Color(0xff5FB2DF),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Align(
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          child: Text(
                                            "clientName".i18n(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        )),
                                        SizedBox(
                                          width: 130,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  const Text(
                                                    "POC",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    "month".i18n(),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    "frequency".i18n(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    "visitsTitle".i18n(),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (cubit.pocData[areaIndex]['isShow'] == true)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      POCDataModel pocDataModel = data[index];
                                      return Card(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(30, 15, 40, 15),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Align(
                                                alignment: AlignmentDirectional
                                                    .centerStart,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      pocDataModel.clientName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      pocDataModel
                                                          .medicalSpecialty
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                              SizedBox(
                                                width: 125,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      pocDataModel.poc
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      pocDataModel.frequency
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xff5FB2DF),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                              ],
                            );
                          },
                        ),
                  fallback: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ))
        ],
      ),
    );
  }
}
