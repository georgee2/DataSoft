import 'package:data_soft/core/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/external_sharing.dart';
import '../../../core/constants.dart';
import '../../../core/widgets/shared_widgets.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
      ),
      body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    "assets/images/dataSoft_logo.png",
                    height: 70,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("aboutUs".i18n()),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Find us on",
                    style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        fontFamily: FontFamilyStrings.ROBOTO_BOLD),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const AboutUsContent(
                      title: "Datasofteg.com",
                      url: "https://datasofteg.com/",
                      image: "website_icon",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const AboutUsContent(
                      title: "Data Soft",
                      url:
                          "https://www.google.com/maps/place/Smart+Villages+Development+and+Management+Company/@30.133767,31.207831,10z/data=!4m6!3m5!1s0x14585ba3024b8275:0x9fbd976cf0e573b1!8m2!3d30.0658297!4d31.0249619!16zL20vMGI5cDlk?hl=en-US&entry=ttu",
                      image: "location_icon",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const AboutUsContent(
                      title: "info@datasofteg.com",
                      url: "info@datasofteg.com",
                      image: "mail_icon",
                    ),
                    const SizedBox(
                      height: 50,
                    ),
          ],
        ),
      ),
    );
  }
}

class AboutUsContent extends StatelessWidget {
  const AboutUsContent({
    super.key,
    required this.title,
    required this.url,
    required this.image,
  });
  final String image;
  final String title;
  final String url;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (url == "info@datasofteg.com") {
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: url,
          );
          launchUrl(emailLaunchUri);
        } else {
          showlaunchUrl(url);
        }
      },
      child: Container(
        height: 60,
        width: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0.0, 5),
                  blurRadius: 10,
                  color: Colors.grey.withOpacity(0.7))
            ]),
        child: ListTile(
          minLeadingWidth: 35,
          leading: CircleAvatar(
            backgroundColor: secondryColor,
            radius: 17.5,
            child: imageSvg(src: image, color: Colors.white, size: 22.5),
          ),
          title: Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
