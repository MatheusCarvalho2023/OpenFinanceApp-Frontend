import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:open_finance_app/theme/colors.dart';

class ChartData {
  final double value;
  final Color? color;

  ChartData({
    required this.value,
    this.color,
  });
}

class PieChartWidget extends StatelessWidget {
  final List<ChartData> data;
  final double centerSpaceRadius;
  final double sectionRadius;
  final double sectionsSpace;
  final String? centerText;
  final TextStyle centerTextStyle;
  final double? height;
  final double? width;

  const PieChartWidget({
    super.key,
    required this.data,
    this.centerSpaceRadius = 100,
    this.sectionRadius = 50,
    this.sectionsSpace = 3,
    this.centerText,
    this.centerTextStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height,
          width: width,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sections: _generateSections(),
                  centerSpaceRadius: centerSpaceRadius,
                  sectionsSpace: sectionsSpace,
                ),
              ),
              if (centerText != null)
                Text(
                  centerText!,
                  style: centerTextStyle,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generateSections() {
    final List<Color> defaultColors = [
      AppColors.accentGreen,
      AppColors.accentYellow,
      AppColors.accentRed,
      AppColors.primaryColor,
      AppColors.secondaryColor,
      AppColors.primaryColor10,
      AppColors.primaryColor20,
      AppColors.primaryColor30,
      AppColors.primaryColor40,
      AppColors.primaryColor50,
      AppColors.primaryColor60,
      AppColors.primaryColor70,
      AppColors.primaryColor80,
      AppColors.primaryColor90,
      AppColors.primaryColor100,
    ];

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;

      return PieChartSectionData(
        value: item.value,
        color: item.color ?? defaultColors[index % defaultColors.length],
        radius: sectionRadius,
        title: '',
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

}
