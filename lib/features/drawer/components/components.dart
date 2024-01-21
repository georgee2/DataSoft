import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import '../../../core/constants.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent(
      {super.key,
      required this.title,
      required this.screenName,
      required this.imageSrc,
      required this.onTap});
  final String title;
  final String screenName;
  final String imageSrc;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: AlignmentDirectional.center,
        height: title == screenName ? 60 : 50,
        width: double.infinity,
        margin: const EdgeInsetsDirectional.only(start: 20, bottom: 20),
        padding: const EdgeInsetsDirectional.only(start: 15),
        decoration: title == screenName
            ? const BoxDecoration(
                borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(50),
                    bottomStart: Radius.circular(50)),
                color: Colors.white)
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            imageSvg(
              src: imageSrc,
              size: 30,
              color: title == screenName
                  ? primaryColor
                  : title == "Log Out"
                      ? Colors.white
                      : null,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: title == screenName ? primaryColor : Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
