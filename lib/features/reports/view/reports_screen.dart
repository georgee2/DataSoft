import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:data_soft/features/drawer/drawer_sceen.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../veiw_model/cubit/reports_cubit.dart';

class ReportsScreen extends StatelessWidget {
  ReportsScreen(
      {super.key,
      required this.title,
      required this.color,
      required this.count});
  final Color color;
  final String title;
  final String count;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const DrawerScreen(
        screenName: "Reports",
      ),
      appBar: AppBar(),
      body: Column(
        children: [
          CustAppBar(
            title: "Reports",
            scaffoldKey: scaffoldKey,
            imageSrc: 'reports_icon',
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 20, 0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  Expanded(
                      child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: color),
                  )),
                  Text(
                    count,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
              child: BlocProvider(
            create: (context) => ReportsCubit()..getReports(title),
            child: BlocBuilder<ReportsCubit, ReportsState>(
              builder: (context, state) {
                var cubit = ReportsCubit.get(context);
                return ConditionalBuilder(
                  condition: cubit.reportModel != null,
                  builder: (context) {
                    return cubit.reportModel!.message!.reportData.isEmpty
                        ? noDataFound(context, type: "Reports")
                        : ListView.builder(
                            itemCount:
                                cubit.reportModel!.message!.reportData.length,
                            itemBuilder: (context, index) => ClientsContent(
                              title: cubit.reportModel!.message!
                                  .reportData[index].customerName!,
                              subTitle: cubit.reportModel!.message!
                                  .reportData[index].medicalSpecialty!,
                            ),
                          );
                  },
                  fallback: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ))
        ],
      ),
    );
  }
}
