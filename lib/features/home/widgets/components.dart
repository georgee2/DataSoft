import 'package:data_soft/core/constants.dart';
import 'package:data_soft/core/widgets/shared_widgets.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../view_model/cubit/home_cubit.dart';

class HomeCycles extends StatelessWidget {
  const HomeCycles({super.key, required this.cyclesList, required this.cubit});
  final List cyclesList;
  final HomeCubit cubit;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cyclesList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 20),
      itemBuilder: (context, index) => GestureDetector(
        onTap: cubit.cyclesIconsAndName(context, cyclesList[index])[2],
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
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: cubit.homeCyclesColors(index)),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: imageSvg(
                          src: cubit.cyclesIconsAndName(
                              context, cyclesList[index])[1],
                          size: cubit.cyclesIconsAndName(
                                      context, cyclesList[index])[1] ==
                                  "visits_icon"
                              ? 30
                              : 40,
                        ),
                      ),
                    ),
                    Text(
                      cubit.cyclesIconsAndName(context, cyclesList[index])[0],
                      style: TextStyle(
                          fontSize: cubit.cyclesIconsAndName(
                                      context, cyclesList[index])[0] ==
                                  "Settlement"
                              ? 14
                              : 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HomeVisitsStatus extends StatelessWidget {
  const HomeVisitsStatus(
      {super.key,
      required this.image,
      required this.title,
      required this.count,
      required this.totalPercent,
      required this.onTap});

  final String image;
  final String title;
  final String count;
  final String totalPercent;

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 88,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 25),
                  blurRadius: 30,
                  color: const Color(0xff000000).withOpacity(0.2))
            ]),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          children: [
            imageSvg(src: image, size: 48),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff707070)),
                  ),
                  Text(
                    count,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Text(
              totalPercent,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

LineChart lineChart() {
  return LineChart(LineChartData(
    gridData: FlGridData(
      show: false,
      drawVerticalLine: false,
      horizontalInterval: 1,
      verticalInterval: 1,
    ),
    titlesData: FlTitlesData(
      show: false,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    minX: 0,
    maxX: 11,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: const [
          FlSpot(0, 3),
          FlSpot(2.6, 2),
          FlSpot(4.9, 5),
          FlSpot(6.8, 3.1),
          FlSpot(8, 4),
          FlSpot(9.5, 3),
          FlSpot(11, 4),
        ],
        isCurved: true,
        color: const Color(0xff29CB97).withOpacity(0.7),
        barWidth: 5,
        isStrokeCapRound: false,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            end: Alignment.bottomLeft,
            stops: const [0, 0.7],
            colors: [
              const Color(0xff29CB97),
              Colors.white,
            ].map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ),
    ],
  ));
}
