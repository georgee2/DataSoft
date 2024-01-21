import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../drawer/drawer_sceen.dart';
import '../view_model/cubit/requests_cycles_cubit.dart';

class AllRequests extends StatelessWidget {
  AllRequests({super.key});
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: BlocProvider(
                  create: (context) => RequestsCyclesCubit()..setHomeCycles(),
                  child: BlocBuilder<RequestsCyclesCubit, RequestsCyclesState>(
                    builder: (context, state) {
                      var cubit = RequestsCyclesCubit.get(context);
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cubit.homeCyblesList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: cubit.cyclesIconsAndName(
                                  context, cubit.homeCyblesList[index])[2],
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      cubit.homeImages(index),
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          color: cubit.homeCyclesColors(index)),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: imageSvg(
                                                src: cubit.cyclesIconsAndName(
                                                    context,
                                                    cubit.homeCyblesList[
                                                        index])[1],
                                                size: cubit.cyclesIconsAndName(
                                                            context,
                                                            cubit.homeCyblesList[
                                                                index])[1] ==
                                                        "visits_icon"
                                                    ? 45
                                                    : 55,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            cubit.cyclesIconsAndName(context,
                                                cubit.homeCyblesList[index])[0],
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
