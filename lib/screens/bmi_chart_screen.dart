import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bmi_history_model.dart';

class BmiChartScreen extends StatelessWidget {
  final bool isOn;

  const BmiChartScreen({
    super.key,
    required this.isOn,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isOn ? const Color(0xFF1C2135) : const Color(0xFFF5F5F5);

    final Color cardColor =
        isOn ? const Color(0xFF24263B) : Colors.white;

    final Color textColor =
        isOn ? Colors.white : Colors.black87;

    final Color secondaryTextColor =
        isOn ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        title: Text(
          'BMI Chart',
          style: TextStyle(
            color: textColor,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder<Box<BmiHistoryModel>>(
        valueListenable:
            Hive.box<BmiHistoryModel>('bmi_history').listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return Center(
              child: Text(
                'No BMI data yet',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 18,
                ),
              ),
            );
          }

          final records = box.values.toList();

          // ترتيب البيانات من الأقدم إلى الأحدث
          records.sort(
            (a, b) => a.date.compareTo(b.date),
          );

          final spots = <FlSpot>[];

          for (int i = 0; i < records.length; i++) {
            spots.add(
              FlSpot(
                i.toDouble(),
                records[i].bmi,
              ),
            );
          }

          double minBmi = records.first.bmi;
          double maxBmi = records.first.bmi;

          for (final item in records) {
            if (item.bmi < minBmi) {
              minBmi = item.bmi;
            }

            if (item.bmi > maxBmi) {
              maxBmi = item.bmi;
            }
          }

          double minY = (minBmi - 2).clamp(0, double.infinity);
          double maxY = maxBmi + 2;

          if (maxY - minY < 5) {
            maxY = minY + 5;
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BMI Over Time',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Your BMI history',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        height: 300,
                        child: LineChart(
                          LineChartData(
                            minY: minY,
                            maxY: maxY,

                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 1,
                            ),

                            borderData: FlBorderData(
                              show: false,
                            ),

                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),

                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget:
                                      (value, meta) {
                                    return Text(
                                      value.toStringAsFixed(0),
                                      style: TextStyle(
                                        color:
                                            secondaryTextColor,
                                        fontSize: 11,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: records.length <= 7,
                                  getTitlesWidget:
                                      (value, meta) {
                                    final int index =
                                        value.toInt();

                                    if (index < 0 ||
                                        index >=
                                            records.length) {
                                      return const SizedBox();
                                    }

                                    final date =
                                        records[index].date;

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(
                                        top: 8,
                                      ),
                                      child: Text(
                                        '${date.day}/${date.month}',
                                        style: TextStyle(
                                          color:
                                              secondaryTextColor,
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            lineTouchData: LineTouchData(
                              enabled: true,
                              touchTooltipData:
                                  LineTouchTooltipData(
                                getTooltipItems:
                                    (touchedSpots) {
                                  return touchedSpots
                                      .map((spot) {
                                    return LineTooltipItem(
                                      'BMI: ${spot.y.toStringAsFixed(1)}',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),

                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                barWidth: 3,
                                color: Colors.pink,
                                dotData: FlDotData(
                                  show: true,
                                ),
                                belowBarData:
                                    BarAreaData(
                                  show: true,
                                  color: Colors.pink
                                      .withOpacity(0.15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}