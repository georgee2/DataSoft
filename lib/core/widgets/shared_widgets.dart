import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_chart/d_chart.dart';
import 'package:data_soft/core/app_fonts.dart';
import 'package:data_soft/core/media_query_values.dart';
import 'package:data_soft/features/chat/view/manager_chat.dart';
import 'package:data_soft/features/registration/model/registration_model.dart';
import 'package:data_soft/core/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localization/localization.dart';
import '../external_sharing.dart';
import '../../features/chat/view/view_chat.dart';
import '../../features/clients/view/client_details.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../features/notifications/widgets/notification_widget.dart';

// Normal AppBar
class CustAppBar extends StatelessWidget {
  const CustAppBar({
    super.key,
    required this.title,
    required this.scaffoldKey,
    required this.imageSrc,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final String imageSrc;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 100,
      color: primaryColor,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: imageSvg(src: imageSrc, size: 25),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
                fontFamily: FontFamilyStrings.ROBOTO_BOLD,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white),
          ),
          const Spacer(),
          verticalLine(),
          const Spacer(),
          const NotificationWidget(),
          GestureDetector(
            onTap: () {
              if (managerData!.isManager!) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagerChat(),
                    ));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          employeeId: hubData!.userData!.employeeId!),
                    ));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: imageSvg(src: "chat_icon", size: 25),
            ),
          ),
          GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openEndDrawer();
              },
              child: imageSvg(src: "drawer_icon", size: 25)),
        ],
      ),
    );
  }
}

// AppBar With Clipper(Path)
class CustAppBarWithClip extends StatelessWidget {
  const CustAppBarWithClip({
    super.key,
    required this.title,
    required this.scaffoldKey,
    required this.widget,
    required this.imageSrc,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final String? imageSrc;
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipPath(
              clipper: CustomClip(),
              child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                margin: const EdgeInsets.only(bottom: 50),
                height: 150,
                color: primaryColor,
                width: double.infinity,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: imageSvg(src: imageSrc, size: 25),
                      ),
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                          fontFamily: FontFamilyStrings.ROBOTO_BOLD,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const Spacer(),
                    const NotificationWidget(),
                    GestureDetector(
                      onTap: () {
                        if (managerData!.isManager!) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManagerChat(),
                              ));
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                      employeeId:
                                          hubData!.userData!.employeeId!)));
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: imageSvg(src: "chat_icon", size: 20),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState!.openEndDrawer();
                        },
                        child: imageSvg(src: "drawer_icon", size: 25)),
                  ],
                ),
              ),
            ),
            widget
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 30),
              color: Colors.white,
              width: 1,
              height: 35,
            ),
          ],
        ),
      ],
    );
  }
}

// Clipper class
class CustomClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 100);
    path.lineTo(size.width / 5, 100);
    path.quadraticBezierTo(
        size.width / 2, 200, size.width - size.width / 5, 100);
    path.lineTo(size.width, 100);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

// This vertical line or small container used in the AppBar class and another screens
Widget verticalLine({double height = 35, Color color = Colors.white}) {
  return Container(
    width: 2,
    height: height,
    color: color,
  );
}

// This is the primary button
class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.color,
      required this.title,
      required this.onTap});
  final String title;
  final Color color;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.zero,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(5), color: color),
        child: FittedBox(
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// Secondary button used in (Client detils, Planning, visits)
class SecondryButton extends StatelessWidget {
  const SecondryButton({
    super.key,
    required this.color,
    required this.title,
    required this.onTap,
  });
  final String title;
  final Color color;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 230,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: borderRadius, color: color),
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

// This is a (from date and to date) widget
class FromAndToDateTimeContainer extends StatelessWidget {
  const FromAndToDateTimeContainer(
      {super.key, required this.onTap, required this.time});
  final Function() onTap;
  final String time;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: const Color(0xffD7DBEC)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            imageSvg(src: "calendar_event"),
            const SizedBox(width: 10),
            Text(time,
                style: const TextStyle(
                    fontFamily: FontFamilyStrings.ROBOTO_REGULAR,
                    fontWeight: FontWeight.w400))
          ],
        ),
      ),
    );
  }
}

// This is a normal network image, but it's using by CachedNetworkImage package
Widget custDefaultNetWorkImage(String image, {BoxFit fit = BoxFit.fill}) {
  return CachedNetworkImage(
    imageUrl: image,
    fit: fit,
    height: double.infinity,
    width: double.infinity,
    placeholder: (context, url) =>
        const Center(child: CupertinoActivityIndicator()),
    errorWidget: (context, url, error) => const Center(
        child: Icon(
      Icons.error,
      color: Colors.red,
    )),
  );
}

// This is a image avatar, but it's using by CachedNetworkImage package
Widget custProviderNetWorkImage(
    {required String? image, double radius = 25.0}) {
  if (image == "null" ||
      image == null ||
      image == "http://154.38.165.213:1212null") {
    return Image.asset("assets/images/user_avatar_icon.png",
        height: radius * 2, width: radius * 2);
  } else {
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.fill,
      height: radius * 2,
      alignment: Alignment.center,
      placeholder: (context, url) => Container(
          height: radius,
          width: radius,
          alignment: Alignment.center,
          child: const Center(child: CupertinoActivityIndicator())),
      errorWidget: (context, url, error) => Image.asset(
          "assets/images/user_avatar_icon.png",
          height: radius * 2,
          width: radius * 2),
      imageBuilder: (BuildContext context, imageUrl) => CircleAvatar(
        backgroundImage: imageUrl,
        radius: radius,
      ),
    );
  }
}

// This class to show the date style on the item style. (that's the same the plan screen)
class DateWidgets extends StatelessWidget {
  const DateWidgets(
      {super.key, required this.day, required this.year, required this.month});
  final String day;
  final String year;
  final String month;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: [
        Container(
          height: context.height * 0.1,
          width: 70,
          margin: const EdgeInsetsDirectional.only(top: 10),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
              borderRadius: borderRadius, border: border, color: bgColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Text(
                day,
                style: const TextStyle(
                    fontSize: 41,
                    fontFamily: FontFamilyStrings.ROBOTO_BOLD,
                    color: primaryColor,
                    fontWeight: FontWeight.w900),
              )),
              Text(
                month,
                style: const TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                    fontFamily: FontFamilyStrings.ROBOTO_MEDIUM,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(start: 10),
          decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(5),
              color: bgColor),
          child: Text(
            year,
            style: const TextStyle(
                fontFamily: FontFamilyStrings.ROBOTO_LIGHT,
                fontSize: 14,
                color: primaryColor,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

// This is the primary item content, but it will need to use dateWigets or Svg picture widget(imageSvg)
class ContentWidget extends StatelessWidget {
  const ContentWidget(
      {super.key,
      required this.buttonTitle,
      required this.buttonColor,
      required this.onTap,
      required this.widget,
      this.topText,
      this.centerText,
      this.bottomText,
      this.bottomTextColor,
      this.centerTitleType = "Days"});
  final String buttonTitle;
  final Color? buttonColor;
  final Function() onTap;
  final Widget widget;
  final String? topText;
  final String? centerText;
  final String? centerTitleType;
  final String? bottomText;
  final Color? bottomTextColor;
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    getBottomText() {
      switch(bottomText) {
        case "Approved" :
          return "approved".i18n();
        case "Partially Approved" :
          return "partiallyApproved".i18n();
        case "In Review" :
          return "In Review";
        case "Rejected" :
          return "reject".i18n();
        case "Pending" :
          return "pending".i18n();
        default :
          return bottomText;
      }
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(width: 0.2, color: const Color(0xff2699FB)),
          color: bgColor,
          boxShadow: [
            BoxShadow(
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(0, 5),
              color: Colors.grey.withOpacity(0.5),
            )
          ]),
      child: Row(
        children: [
          widget,
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: SizedBox(
              height: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.circle,
                          size: 10,
                          color: secondryColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          " ${topText ?? "planned".i18n()}",
                          style: const TextStyle(
                              fontSize: 14,
                              color: primaryColor,
                              fontFamily: FontFamilyStrings.ROBOTO_MEDIUM,
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 15),
                    child: Text(
                      "${centerText.toString()} $centerTitleType",
                      style: const TextStyle(
                          fontFamily: FontFamilyStrings.ROBOTO_LIGHT,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xffA8ACAF)),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 10,
                        color: bottomTextColor,
                      ),
                      Expanded(
                        child: Text(getBottomText()!,
                            style: TextStyle(
                                fontSize: locale == const Locale("ar") ? 12 : 16,
                                color: bottomTextColor,
                                fontFamily: FontFamilyStrings.ROBOTO_REGULAR,
                                fontWeight: FontWeight.w400)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          if (buttonColor != null)
            PrimaryButton(
              title: buttonTitle,
              color: buttonColor!,
              onTap: onTap,
            )
        ],
      ),
    );
  }
}

// This is a svg picture..
SvgPicture imageSvg(
    {required src, double size = 30, Color? color, BoxFit fit = BoxFit.fill}) {
  return SvgPicture.asset(
    "assets/images/$src.svg",
    height: size,
    width: size,
    color: color,
    fit: fit,
  );
}

// ClientsContent that to show the clients, this used in (Clinet, Reports).
class ClientsContent extends StatelessWidget {
  const ClientsContent({
    super.key,
    required this.title,
    required this.subTitle,
    this.doctorImage,
  });
  final String title;
  final String subTitle;
  final String? doctorImage;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final locale = Localizations.localeOf(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewClient(leadName: title),
            ));
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Card(
            child: Padding(
              padding:
                  EdgeInsets.fromLTRB(doctorImage != null ? 65 : 20, 8, 20, 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: locale == const Locale("ar") ? CrossAxisAlignment.center  : CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontFamily: FontFamilyStrings.ROBOTO_MEDIUM,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          subTitle,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: FontFamilyStrings.ROBOTO_REGULAR,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )),
                    Container(width: 2, height: 50, color: primaryColor),
                    SizedBox(
                      width: size.width * 0.07,
                    )
                  ]),
            ),
          ),
          if (doctorImage != null)
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              // margin: EdgeInsets.only(left: locale == const Locale("ar") ? 30 : 0),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                custProviderNetWorkImage(
                  image: doctorImage,
                )
              ]),
            )
        ],
      ),
    );
  }
}

// this d_chart package
DChartPie donutChart({red, green, blue}) {
  red ??= "0";
  green ??= "0";
  blue ??= "0";
  return DChartPie(
    data: [
      {'type': "red", 'value': double.parse(red.toString())},
      {'type': "blue", 'value': double.parse(blue.toString())},
      {'type': "green", 'value': double.parse(green.toString())},
    ].map((e) {
      return {'domain': e['type'], 'measure': e['value']};
    }).toList(),
    fillColor: (pieData, index) {
      switch (pieData['domain']) {
        case 'red':
          return Colors.red;
        case 'green':
          return const Color(0xff21D59B);
        default:
          return primaryColor;
      }
    },
    showLabelLine: false,
    donutWidth: 10,
    pieLabel: (pieData, index) => "",
    strokeWidth: 0.0,
  );
}

// this custom CupertinoTextField clickable and unclickable
Widget custCupertinoTextField(
    {required String title,
    required TextInputType textInputType,
    bool isDisabled = true,
    controller,
    double fontSize = 14}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontFamily: FontFamilyStrings.ARIAL_REGULAR,
              fontWeight: FontWeight.w400,
              fontSize: fontSize,
              color: const Color(0xff515C6F)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: CupertinoTextField(
            decoration: decorationOfTextFeild,
            style: const TextStyle(
                fontFamily: FontFamilyStrings.ARIAL_LIGHT,
                fontWeight: FontWeight.w300,
                fontSize: 14),
            padding: const EdgeInsets.all(10),
            controller: controller,
            keyboardType: textInputType,
            enabled: isDisabled,
          ),
        ),
      ],
    ),
  );
}

// Custon Floating action button
Widget custFloatingAction({required Function() onTap}) {
  return GestureDetector(onTap: onTap, child: imageSvg(src: 'add', size: 70));
}

// this custom CupertinoTextField for comment and using in it the attach file widget
// ignore: must_be_immutable
class CustCommentTextField extends StatelessWidget {
  CustCommentTextField(
      {super.key,
      required this.onTap,
      this.showAttachFile = true,
      this.isClickable = true,
      this.controller,
      this.attachedFile});
  final Function()? onTap;
  final bool showAttachFile;
  final bool isClickable;
  final String? attachedFile;
  TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "comment".i18n(),
          style: const TextStyle(fontSize: 16, color: Color(0xff515C6F)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: CupertinoTextField(
            placeholder: "yourComment".i18n(),
            controller: controller,
            maxLines: 3,
            enabled: isClickable,
            keyboardType: TextInputType.multiline,
            decoration: decorationOfTextFeild,
            style: const TextStyle(
                fontFamily: FontFamilyStrings.ARIAL_LIGHT,
                fontWeight: FontWeight.w300,
                fontSize: 14),
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
        ),
        if (showAttachFile) attachFile(onTap: onTap, attachedFile: attachedFile)
      ],
    );
  }
}

// attach file widget, this used in CustCommentTextField and on some dialogs
Widget attachFile({required onTap, attachedFile}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
    child: DottedBorder(
      color: const Color(0xffD4D2D2),
      dashPattern: const [5],
      strokeWidth: 1,
      child: Container(
        color: Colors.grey.withOpacity(0.13),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(children: [
            const Icon(Icons.file_upload_outlined,
                size: 20, color: Color(0xff8D9F9E)),
            const SizedBox(
              width: 10,
            ),
            Text("attachFile".i18n(),
                style: const TextStyle(
                    color: Color(0xff8D9F9E),
                    fontFamily: FontFamilyStrings.ARIAL_LIGHT,
                    fontWeight: FontWeight.w300)),
            const Spacer(),
            GestureDetector(
              onTap: attachedFile == null
                  ? onTap
                  : () {
                      openAttachFile(attachedFile);
                    },
              child: Container(
                height: 25,
                width: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: primaryColor),
                child: Text(
                  attachedFile == null ? "browseFile".i18n() : "Open file",
                  style: const TextStyle(
                      fontSize: 10,
                      fontFamily: FontFamilyStrings.ARIAL_REGULAR,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )
          ]),
        ),
      ),
    ),
  );
}

// 
class FilterContent extends StatelessWidget {
  const FilterContent({
    super.key,
    required this.title,
    required this.result,
    required this.onSelect,
    required this.items,
  });
  final String title;
  final String result;
  final Function(String) onSelect;
  final List items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: PopupMenuButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          result,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: imageSvg(src: 'arrow_down', size: 20),
                    ),
                  ],
                ),
                itemBuilder: (context) => items
                    .map((e) => PopupMenuItem(
                        onTap: () {
                          onSelect(e);
                        },
                        child: Text(e.toString())))
                    .toList(),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

// This to show no data found when the request returning empty data
Widget noDataFound(BuildContext context, {type}) {
  return Center(
      child: Container(
    height: context.height * .3,
    alignment: Alignment.center,
    child: Text("No ${type ?? "Data"} Found",
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: FontFamilyStrings.ROBOTO_BOLD,
            color: Colors.grey)),
  ));
}
