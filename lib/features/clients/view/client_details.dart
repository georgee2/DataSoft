import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/core/media_query_values.dart';
import 'package:data_soft/features/clients/view_model/client_details_cubit.dart';
import 'package:data_soft/features/clients/view_model/clients_cubit.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/app_fonts.dart';
import '../../../core/maps_widget.dart';

class ViewClient extends StatelessWidget {
  ViewClient({super.key, required this.leadName});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final String leadName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
      endDrawer: const DrawerScreen(
        screenName: "Clients",
      ),
      body: BlocProvider(
        create: (context) => ClientDetailsCubit()..getClientDetails(leadName),
        child: BlocBuilder<ClientDetailsCubit, ClientDetailsEvents>(
          builder: (context, state) {
            var cubit = ClientDetailsCubit.get(context);
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 200,
                      ),
                      ConditionalBuilder(
                        condition: cubit.clientDetailsModel != null,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                custCupertinoTextField(
                                    title: "Client",
                                    textInputType: TextInputType.name,
                                    controller: TextEditingController(
                                        text:
                                            cubit.clientDetailsModel!.leadName),
                                    isDisabled: false),
                                custCupertinoTextField(
                                    title: "Medical specialty",
                                    textInputType: TextInputType.text,
                                    controller: TextEditingController(
                                        text: cubit.clientDetailsModel!
                                            .medicalSpecialty),
                                    isDisabled: false),
                                custCupertinoTextField(
                                    title: "Phone Number",
                                    textInputType: TextInputType.phone,
                                    controller: TextEditingController(
                                        text:
                                            cubit.clientDetailsModel!.mobileNo),
                                    isDisabled: false),
                                custCupertinoTextField(
                                    title: "E-mail",
                                    textInputType: TextInputType.emailAddress,
                                    controller: TextEditingController(
                                        text:
                                            cubit.clientDetailsModel!.emailId),
                                    isDisabled: false),
                                const Text("Location",
                                    style: TextStyle(
                                        fontFamily:
                                            FontFamilyStrings.ARIAL_REGULAR,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Color(0xff515C6F))),
                                SizedBox(
                                    height: context.width / 2,
                                    width: context.width,
                                    child: MapWidget(
                                      lat: cubit.clientDetailsModel?.lat,
                                      lng: cubit.clientDetailsModel?.lng,
                                      location:
                                          cubit.clientDetailsModel?.location,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 40),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SecondryButton(
                                        color: primaryColor,
                                        title: "CLOSE",
                                        onTap: () {
                                          Navigator.pop(context);
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        fallback: (context) => Container(
                          height: context.height * 0.5,
                          width: context.width,
                          alignment: Alignment.center,
                          child: const CupertinoActivityIndicator(),
                        ),
                      )
                    ],
                  ),
                ),
                CustAppBarWithClip(
                    title: "Clients",
                    scaffoldKey: scaffoldKey,
                    imageSrc: 'client_icon',
                    widget: custProviderNetWorkImage(
                        image: cubit.clientDetailsModel?.image, radius: 50)),
              ],
            );
          },
        ),
      ),
    );
  }
}
