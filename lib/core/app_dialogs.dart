import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';
import '../features/clients/view_model/clients_cubit.dart';
import 'widgets/shared_widgets.dart';
import 'app_datetime.dart';
import 'app_fonts.dart';
import 'constants.dart';

dialogFrameSingleButton({
  required BuildContext context,
  required String title,
  required String buttonTitle,
  required Widget child,
  required Color buttonColor,
  required Function() onTap,
  required colors,
}) {
  showDialog(
      context: context,
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
                          width: 350,
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
                                    colors: colors,
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
                                    Text(
                                      title,
                                      style: const TextStyle(
                                          fontFamily:
                                              FontFamilyStrings.ARIAL_REGULAR,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 0,
                                      width: 25,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: child,
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: onTap,
                          child: Container(
                            height: 50,
                            width: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: buttonColor,
                            ),
                            child: Text(
                              buttonTitle,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
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

dialogFrameSingleButton2({
  required BuildContext context,
  required String title,
  required String buttonTitle,
  required Widget child,
  required Widget action,
  required Color buttonColor,
  required Function() onTap,
  required colors,
}) {
  showDialog(
      context: context,
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
                          width: 350,
                          margin: const EdgeInsets.only(bottom: 25),
                          padding: const EdgeInsets.only(bottom: 25),
                          decoration: BoxDecoration(
                              borderRadius: borderRadius, color: bgColor),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            children: [
                              Container(
                                height: 85,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: colors,
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
                                    Text(
                                      title,
                                      style: const TextStyle(
                                          fontFamily:
                                              FontFamilyStrings.ARIAL_REGULAR,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          end: 20),
                                      child: action,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: child,
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: onTap,
                          child: Container(
                            height: 50,
                            width: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: buttonColor,
                            ),
                            child: Text(
                              buttonTitle,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
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

activitiesAndSettlementAndExpensesDetails(
    {required BuildContext context,
    required String title,
    required String taskName,
    required String stateText,
    required String type,
    required String typeValue,
    required String buttonTitle,
    required String? attachedFile,
    String? clientName,
    required String amount,
    required String comment,
    required Color color,
    required List<Color> colors,
    required String dateTime,
    bool ishaveClient = true}) {
  dialogFrameSingleButton(
    context: context,
    title: title,
    buttonTitle: buttonTitle,
    buttonColor: color,
    onTap: () {
      Navigator.pop(context);
    },
    colors: colors,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 10,
              color: color,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                stateText,
                style: TextStyle(
                    fontFamily: FontFamilyStrings.ARIAL_REGULAR,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: color),
              ),
            )),
            Text(
                DateTimeFormating.formatCustomDate(
                    date: dateTime, formatType: 'd MMM yyyy'),
                style: const TextStyle(
                    fontFamily: FontFamilyStrings.ARIAL_REGULAR,
                    fontSize: 16,
                    color: Color(0xff515C6F)))
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              type,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: FontFamilyStrings.ARIAL_REGULAR,
                color: Color(0xff515C6F),
              ),
            ),
            Text(
              typeValue,
              style: const TextStyle(
                  fontFamily: FontFamilyStrings.ARIAL_REGULAR,
                  fontSize: 16,
                  color: Color(0xffA8ACAF)),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "amount".i18n(),
          style: const TextStyle(
            fontFamily: FontFamilyStrings.ARIAL_REGULAR,
            fontSize: 16,
            color: Color(0xff515C6F),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                  child: CupertinoTextField(
                      decoration: decorationOfTextFeild,
                      controller: TextEditingController(text: amount),
                      enabled: false,
                      style: const TextStyle(
                          fontFamily: FontFamilyStrings.ARIAL_LIGHT,
                          fontWeight: FontWeight.w300,
                          fontSize: 14))),
              const SizedBox(
                width: 5,
              ),
              Container(
                width: 90,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(9),
                decoration: decorationOfTextFeild,
                child: const Text("LE",
                    style: TextStyle(
                        fontFamily: FontFamilyStrings.ARIAL_LIGHT,
                        fontWeight: FontWeight.w300)),
              ),
            ],
          ),
        ),
        custCupertinoTextField(
            title: "name".i18n(),
            textInputType: TextInputType.name,
            fontSize: 16.0,
            isDisabled: false,
            controller: TextEditingController(text: taskName)),
        if (ishaveClient)
          custCupertinoTextField(
              title: "client".i18n(),
              textInputType: TextInputType.name,
              fontSize: 16.0,
              isDisabled: false,
              controller: TextEditingController(text: clientName)),
        CustCommentTextField(
          onTap: null,
          controller: TextEditingController(text: comment),
          isClickable: false,
          showAttachFile: attachedFile != null &&
              attachedFile.isNotEmpty &&
              attachedFile != "null",
          attachedFile: attachedFile,
        ),
      ],
    ),
  );
}

newActivityAndNewExpensesDialog(
    {required BuildContext context,
    required String title,
    required Widget stateText,
    required String type,
    required List typeValue,
    required Widget commentAndAttachFile,
    required Function(String) onSelection,
    required Function(String) onSelectedClient,
    required String buttonTitle,
    TextEditingController? amount,
    TextEditingController? client,
    required TextEditingController typeName,
    required Color color,
    required List<Color> colors,
    required Function() onTap}) {
  dialogFrameSingleButton(
    context: context,
    title: title,
    buttonTitle: buttonTitle,
    buttonColor: color,
    onTap: onTap,
    colors: colors,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              type,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: FontFamilyStrings.ARIAL_REGULAR,
                color: Color(0xff515C6F),
              ),
            ),
            Row(
              children: [
                stateText,
                const SizedBox(
                  width: 10,
                ),
                PopupMenuButton(
                  child: imageSvg(src: "arrow_down", size: 23),
                  itemBuilder: (context) => typeValue
                      .map((e) => PopupMenuItem(
                          onTap: () {
                            onSelection(e.name);
                          },
                          child: Text(e.name.toString())))
                      .toList(),
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "amount".i18n(),
          style: const TextStyle(
            fontSize: 16,
            fontFamily: FontFamilyStrings.ARIAL_REGULAR,
            color: Color(0xff515C6F),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                  child: CupertinoTextField(
                      decoration: decorationOfTextFeild,
                      controller: amount,
                      style: const TextStyle(
                          fontFamily: FontFamilyStrings.ARIAL_LIGHT,
                          fontWeight: FontWeight.w300,
                          fontSize: 14))),
              const SizedBox(
                width: 5,
              ),
              Container(
                width: 90,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(9),
                decoration: decorationOfTextFeild,
                child: const Text("LE",
                    style: TextStyle(
                        fontFamily: FontFamilyStrings.ARIAL_LIGHT,
                        fontWeight: FontWeight.w300,
                        fontSize: 14)),
              ),
            ],
          ),
        ),
        Text(
          title == "NEW EXPENSES" ? "Expense Name" : "Activity Name",
          style: const TextStyle(
            fontSize: 16,
            fontFamily: FontFamilyStrings.ARIAL_REGULAR,
            color: Color(0xff515C6F),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: CupertinoTextField(
              decoration: decorationOfTextFeild,
              controller: typeName,
              style: const TextStyle(
                  fontFamily: FontFamilyStrings.ARIAL_LIGHT,
                  fontWeight: FontWeight.w300,
                  fontSize: 14)),
        ),
        if (title != "NEW EXPENSES")
          BlocProvider(
            create: (context) => ClientsCubit()..getClients(),
            child: BlocBuilder<ClientsCubit, ClientsEvents>(
              builder: (context, state) {
                var cubit = ClientsCubit.get(context);
                return PopupMenuButton(
                  child: custCupertinoTextField(
                      title: "client".i18n(),
                      textInputType: TextInputType.text,
                      fontSize: 16.0,
                      controller: TextEditingController(
                          text: cubit.clientSelected ?? "chooseClient".i18n()),
                      isDisabled: false),
                  itemBuilder: (context) => cubit.clientsModel!.clients
                      .map((e) => PopupMenuItem(
                          onTap: () {
                            cubit.addNewExpenseAndActivitedSelectedClient(
                                e.name);
                            cubit.addNewExpenseAndActivitedSelectedClient(
                                e.leadName);
                            onSelectedClient(e.name!);
                          },
                          child: Text(e.leadName.toString())))
                      .toList(),
                );
              },
            ),
          ),
        commentAndAttachFile
      ],
    ),
  );
}

locationDialog(context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "We need access to your location",
            style: TextStyle(
              fontFamily: 'STCB',
            ),
          ),
          content: const Text(
            "Turn on location from settings",
            style: TextStyle(
              fontFamily: 'STCR',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                try {
                  await GeolocatorPlatform.instance.openAppSettings();
                  // ignore: empty_catches
                } catch (e) {}
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue[700]),
              ),
              child: const Text(
                "GO TO SETTINGS",
                style: TextStyle(
                  fontFamily: 'STCR',
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "NO THANKS",
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontFamily: 'STCR',
                  ),
                ))
          ],
        );
      });
}
