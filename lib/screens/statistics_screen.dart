import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bmi_history_model.dart';

class StatisticsScreen extends StatelessWidget {
  final bool isOn;

  const StatisticsScreen({
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
          'BMI Statistics',
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
                'No BMI statistics yet',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 18,
                ),
              ),
            );
          }

          final records = box.values.toList();

          final double totalBmi = records.fold(
            0.0,
            (sum, item) => sum + item.bmi,
          );

          final double averageBmi =
              totalBmi / records.length;

          final double highestBmi = records
              .map((item) => item.bmi)
              .reduce((a, b) => a > b ? a : b);

          final double lowestBmi = records
              .map((item) => item.bmi)
              .reduce((a, b) => a < b ? a : b);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatisticsCard(
                  title: 'Total Calculations',
                  value: '${records.length}',
                  icon: Icons.calculate_outlined,
                  cardColor: cardColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),

                const SizedBox(height: 15),

                _buildStatisticsCard(
                  title: 'Average BMI',
                  value: averageBmi.toStringAsFixed(1),
                  icon: Icons.analytics_outlined,
                  cardColor: cardColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),

                const SizedBox(height: 15),

                _buildStatisticsCard(
                  title: 'Highest BMI',
                  value: highestBmi.toStringAsFixed(1),
                  icon: Icons.arrow_upward,
                  cardColor: cardColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),

                const SizedBox(height: 15),

                _buildStatisticsCard(
                  title: 'Lowest BMI',
                  value: lowestBmi.toStringAsFixed(1),
                  icon: Icons.arrow_downward,
                  cardColor: cardColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.bar_chart,
              color: Colors.pink,
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}