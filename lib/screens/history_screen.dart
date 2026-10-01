import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/bmi_history_model.dart';

class HistoryScreen extends StatelessWidget {
  final bool isOn;

  const HistoryScreen({
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

    final Color dateColor =
        isOn ? Colors.white38 : Colors.black38;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        title: Text(
          'BMI History',
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
                'No BMI history yet',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 18,
                ),
              ),
            );
          }

          final history = box.values.toList().reversed.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'BMI: ${item.bmi.toStringAsFixed(1)}',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Row(
                          children: [
                            Text(
                              item.result,
                              style: const TextStyle(
                                color: Colors.pink,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 8),

                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: cardColor,
                                      title: Text(
                                        'Delete BMI',
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'Are you sure you want to delete this BMI record?',
                                        style: TextStyle(
                                          color:
                                              secondaryTextColor,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color:
                                                  secondaryTextColor,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            item.delete();
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(
                                              color:
                                                  Colors.redAccent,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Height: ${item.height.round()} cm',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Weight: ${item.weight} kg',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Age: ${item.age}',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '${item.date.day}/${item.date.month}/${item.date.year} - '
                      '${item.date.hour > 12 ? item.date.hour - 12 : item.date.hour == 0 ? 12 : item.date.hour}:'
                      '${item.date.minute.toString().padLeft(2, '0')} '
                      '${item.date.hour >= 12 ? 'PM' : 'AM'}',
                      style: TextStyle(
                        color: dateColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}