import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/media_query_values.dart';
import 'package:data_soft/features/clients/view_model/clients_cubit.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

import '../../../core/constants.dart';

class ClientScreen extends StatelessWidget {
  ClientScreen({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      endDrawer: const DrawerScreen(
        screenName: "Clients",
      ),
      body: BlocProvider(
        create: (contextt) => ClientsCubit()
          ..getClients()
          ..getMedicalSpecialties(),
        child: BlocBuilder<ClientsCubit, ClientsEvents>(
          builder: (contextt, state) {
            var cubit = ClientsCubit.get(contextt);
            return Column(
              children: [
                CustAppBar(
                  title: "clientsTitle".i18n(),
                  scaffoldKey: scaffoldKey,
                  imageSrc: 'client_icon',
                ),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              textAlign: TextAlign.left,
                              controller: cubit.search,
                              onChanged: (val) {
                                cubit.searchForClients();
                              },
                              decoration: InputDecoration(
                                hintText: "searchSomething".i18n(),
                                prefixIcon: const Icon(Icons.search),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 8),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => ClientFilteringContent(
                                      contextt: contextt),
                                );
                              },
                              child: imageSvg(src: "filter_icon", size: 20)),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ConditionalBuilder(
                    condition: cubit.clientsModel != null,
                    builder: (context) {
                      return cubit.clientsModel!.clients.isEmpty
                          ? noDataFound(context, type: "Clients")
                          : cubit.search.text.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: ListView.builder(
                                      itemCount:
                                          cubit.clientsModel!.clients.length,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ClientsContent(
                                          doctorImage: cubit.clientsModel!
                                              .clients[index].image
                                              .toString(),
                                          title: cubit.clientsModel!
                                              .clients[index].leadName,
                                          subTitle: cubit.clientsModel!
                                              .clients[index].medicalSpecialty,
                                        );
                                      }),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: ListView.builder(
                                      itemCount: cubit.searchList.length,
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ClientsContent(
                                          doctorImage: cubit
                                              .searchList[index].image
                                              .toString(),
                                          title:
                                              cubit.searchList[index].leadName,
                                          subTitle: cubit.searchList[index]
                                              .medicalSpecialty,
                                        );
                                      }),
                                );
                    },
                    fallback: (context) => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ClientFilteringContent extends StatelessWidget {
  const ClientFilteringContent({super.key, required this.contextt});
  final BuildContext contextt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.topRight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 150,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: (context.height - 200) * 0.85,
                    width: context.width * 0.2,
                    color: Colors.transparent,
                  ),
                ),
                BlocProvider.value(
                  value: BlocProvider.of<ClientsCubit>(contextt),
                  child: BlocBuilder<ClientsCubit, ClientsEvents>(
                    builder: (contextt, state) {
                      var cubit = ClientsCubit.get(contextt);
                      return Container(
                        height: (context.height - 200) * 0.85,
                        width: context.width * 0.8,
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 25),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "refineResult".i18n(),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                TextButton(
                                    onPressed: () {
                                      cubit.getClients();
                                    },
                                    child: Text("clear".i18n(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: secondryColor)))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FilterContent(
                                title: "time".i18n(),
                                result: cubit.timeSelected ?? "All",
                                onSelect: (value) {
                                  cubit.changeClientTimeFiltering(value);
                                },
                                items: ["all".i18n(), "amOnly".i18n(), "pmOnly".i18n()]),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "medicalSpecialty".i18n(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: PopupMenuButton(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  cubit.medicalSpecialtySelected ??
                                                      "All",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: imageSvg(
                                                  src: 'arrow_down', size: 20),
                                            ),
                                          ],
                                        ),
                                        itemBuilder: (context) => cubit
                                            .medicalSpecialtyModel!.message
                                            .map((e) => PopupMenuItem(
                                                onTap: () {
                                                  cubit
                                                      .changeClientMedicalSpecialtyFiltering(
                                                          e.name);
                                                },
                                                child: Text(e.name.toString())))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                            FilterContent(
                                title: "location".i18n(),
                                result: cubit.citySelected ?? "All",
                                onSelect: (value) {
                                  cubit.changeClientLocationSelectedFiltering(
                                      value);
                                },
                                items: cubit.clientsModel?.city ?? []),
                            Expanded(
                                child: Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () {
                                  cubit.getClients(
                                      leadTime: cubit.timeSelected,
                                      medicalSpecialty:
                                          cubit.medicalSpecialtySelected,
                                      city: cubit.citySelected);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    height: 45,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: secondryColor),
                                    child: Row(children: [
                                      Expanded(
                                          child: Align(
                                        alignment: Alignment.center,
                                        child: Text("applyFilters".i18n(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white)),
                                      )),
                                      imageSvg(
                                          src: "apply_filter_icon", size: 25)
                                    ])),
                              ),
                            ))
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
