import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/toast_message.dart';
import '../../notifications/view_model/notification_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_soft/core/constants.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:data_soft/core/media_query_values.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:data_soft/features/splash_screen/splash_screen.dart';
import 'package:data_soft/features/home/view_model/cubit/home_cubit.dart';
import 'package:data_soft/features/registration/view_model/cubit/registration_cubit.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    bool isVisible = MediaQuery.of(context).viewInsets.bottom > 0.0;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: bgColor,
      ),
      body: BlocProvider(
          create: (context) => RegistrationCubit()..getEmail(),
          child: BlocConsumer<RegistrationCubit, RegistrationStates>(
            listener: (context, state) {
              if (state is RegistrationLoadingState) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );
              }
              if (state is RegistrationErrorState) {
                showToast("Invalid email or password");
              }
              if (state is AddDataToFirebaseSuccessState) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                topicSubscribe();
                HomeCubit.get(context).initUserState();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ));
              }
            },
            builder: (context, state) {
              var cubit = RegistrationCubit.get(context);
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            height: context.height * 0.3,
                            width: double.infinity,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30)),
                            ),
                            child: Stack(
                              children: [
                                BannerCarousel(
                                  showIndicator: true,
                                  animation: true,
                                  activeColor: primaryColor,
                                  disableColor: Colors.white,
                                  height: double.infinity,
                                  margin: EdgeInsets.zero,
                                  banners: cubit.itemsSuggestionsData
                                      .map(
                                        (e) => BannerModel(
                                            imagePath: e, id: e.toString()),
                                      )
                                      .toList(),
                                ),
                                const Positioned(
                                  bottom: 10,
                                  left: 30,
                                  child: Text(
                                    "Welcome",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: context.height -
                                    (context.height * 0.53 + 50),
                                maxHeight: context.height),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 40),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        imageSvg(src: "user_icon", size: 25),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            child: TextFormField(
                                          controller: cubit.userName,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                              hintText: "Username"),
                                          onTapOutside: (event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                        ))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        imageSvg(
                                            src: "password_icon", size: 25),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                            child: TextFormField(
                                          controller: cubit.password,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          decoration: InputDecoration(
                                              hintText: "Password",
                                              suffix: IconButton(
                                                  onPressed: () {
                                                    cubit.changePasswordState();
                                                  },
                                                  icon: Icon(
                                                    cubit.isHide
                                                        ? Icons
                                                            .remove_red_eye_outlined
                                                        : Icons.remove_red_eye,
                                                    color: cubit.isHide
                                                        ? Colors.grey
                                                        : Colors.black,
                                                  ))),
                                          obscureText: cubit.isHide,
                                          onTapOutside: (event) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                        ))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        cubit.login(context);
                                      },
                                      child: Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        decoration: BoxDecoration(
                                          borderRadius: borderRadius,
                                          color: primaryColor,
                                        ),
                                        child: const Text(
                                          "SIGN IN",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (!isVisible)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/dataSoft_logo.png",
                            height: 50,
                            width: 130,
                          ),
                          Text(
                            "Powered by: Data Soft",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withOpacity(0.4)),
                          ),
                        ],
                      ),
                    )
                ],
              );
            },
          )),
    );
  }
}
