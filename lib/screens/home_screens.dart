import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/bmi_history_model.dart';
import '../widgets/gender_card.dart';
import '../widgets/counter_card.dart';
import 'result_screen.dart';
import 'history_screen.dart';
import 'statistics_screen.dart';
import 'bmi_chart_screen.dart';
import 'profile_screen.dart';

class BmiScreen extends StatefulWidget {
  final bool isOn;

  const BmiScreen({
    super.key,
    this.isOn = true,
  });

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  late bool isOn;

  bool isMale = true;

  bool isHeightSelected = false;
  bool isWeightSelected = false;
  bool isAgeSelected = false;

  double height = 150.0;
  int weight = 60;
  int age = 26;

  static const Color darkBackgroundColor =
      Color(0xFF1C2135);

  static const Color darkCardColor =
      Color(0xFF24263B);

  static const Color darkActiveCardColor =
      Color(0xFF3A4056);

  static const Color lightBackgroundColor =
      Color(0xFFF5F5F5);

  static const Color lightCardColor =
      Colors.white;

  static const Color lightActiveCardColor =
      Color(0xFFE3F2FD);

  static const Color pinkColor =
      Color(0xFFE91E63);

  @override
  void initState() {
    super.initState();

    isOn = widget.isOn;

    _loadProfileData();
  }

  void _loadProfileData() {
    final box = Hive.box('profile_data');

    final savedGender = box.get('isMale');
    final savedAge = box.get('age');
    final savedWeight = box.get('weight');
    final savedHeight = box.get('height');

    if (savedGender != null) {
      isMale = savedGender as bool;
    }

    if (savedAge != null) {
      age = savedAge as int;
    }

    if (savedWeight != null) {
      weight = savedWeight as int;
    }

    if (savedHeight != null) {
      height = (savedHeight as num).toDouble();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _saveBasicProfileData() {
    final box = Hive.box('profile_data');

    box.put('isMale', isMale);
    box.put('age', age);
    box.put('weight', weight);
    box.put('height', height);
  }

  void openProfile() {
    _saveBasicProfileData();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          isOn: isOn,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isOn
            ? darkBackgroundColor
            : lightBackgroundColor;

    final Color cardBackgroundColor =
        isOn
            ? darkCardColor
            : lightCardColor;

    final Color activeCardColor =
        isOn
            ? darkActiveCardColor
            : lightActiveCardColor;

    final Color textColor =
        isOn
            ? Colors.white
            : Colors.black87;

    final Color secondaryTextColor =
        isOn
            ? Colors.grey
            : Colors.black54;

    final Color counterButtonColor =
        isOn
            ? const Color(0xFF5D647B)
            : Colors.white;

    final Color counterIconColor =
        isOn
            ? Colors.white
            : const Color(0xFF555555);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: isOn
                        ? const Color(0xFF121623)
                        : const Color(0xFFD0D0D0),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Back to Profile
                  IconButton(
                    onPressed: openProfile,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: pinkColor,
                      size: 27,
                    ),
                  ),

                  // Title
                  Expanded(
                    child: Center(
                      child: Text(
                        'BMI Calculator',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // Actions
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StatisticsScreen(
                                isOn: isOn,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.bar_chart,
                          color: pinkColor,
                          size: 26,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BmiChartScreen(
                                isOn: isOn,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.show_chart,
                          color: pinkColor,
                          size: 26,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HistoryScreen(
                                isOn: isOn,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.history,
                          color: pinkColor,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Male / Female
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMale = true;
                                });

                                _saveBasicProfileData();
                              },
                              child: GenderCard(
                                title: 'Male',
                                imagePath:
                                    'assets/icons/Vector(9).png',
                                backgroundColor:
                                    isMale
                                        ? activeCardColor
                                        : cardBackgroundColor,
                                iconColor: isOn
                                    ? Colors.white
                                    : const Color(
                                        0xFF616161,
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 13),

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isMale = false;
                                });

                                _saveBasicProfileData();
                              },
                              child: GenderCard(
                                title: 'Female',
                                imagePath:
                                    'assets/icons/Vector(10).png',
                                backgroundColor:
                                    !isMale
                                        ? activeCardColor
                                        : cardBackgroundColor,
                                iconColor: isOn
                                    ? Colors.white
                                    : const Color(
                                        0xFF555555,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 23),

                    // Height
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isHeightSelected = true;
                            isWeightSelected = false;
                            isAgeSelected = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isHeightSelected
                                ? activeCardColor
                                : cardBackgroundColor,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Text(
                                'Height',
                                style: TextStyle(
                                  color:
                                      secondaryTextColor,
                                  fontSize: 22,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .baseline,
                                textBaseline:
                                    TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '${height.round()}',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 42,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(width: 5),

                                  Text(
                                    'cm',
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),

                              SliderTheme(
                                data: SliderTheme.of(context)
                                    .copyWith(
                                  activeTrackColor:
                                      Colors.pinkAccent,
                                  inactiveTrackColor:
                                      isOn
                                          ? Colors.white24
                                          : Colors.black26,
                                  thumbColor:
                                      pinkColor,
                                  overlayColor:
                                      Colors.pinkAccent
                                          .withOpacity(0.2),
                                  thumbShape:
                                      const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ),
                                  trackHeight: 2,
                                ),
                                child: Slider(
                                  value: height,
                                  min: 100,
                                  max: 220,
                                  onChanged: (value) {
                                    setState(() {
                                      height = value;
                                      isHeightSelected =
                                          true;
                                    });

                                    _saveBasicProfileData();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 23),

                    // Weight / Age
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isWeightSelected =
                                      true;
                                  isHeightSelected =
                                      false;
                                  isAgeSelected = false;
                                });
                              },
                              child: CounterCard(
                                title: 'Weight',
                                value: weight,
                                backgroundColor:
                                    isWeightSelected
                                        ? activeCardColor
                                        : cardBackgroundColor,
                                textColor: textColor,
                                buttonBackgroundColor:
                                    counterButtonColor,
                                buttonIconColor:
                                    counterIconColor,
                                onIncrement: () {
                                  setState(() {
                                    weight++;
                                    isWeightSelected =
                                        true;
                                  });

                                  _saveBasicProfileData();
                                },
                                onDecrement: () {
                                  if (weight > 1) {
                                    setState(() {
                                      weight--;
                                      isWeightSelected =
                                          true;
                                    });

                                    _saveBasicProfileData();
                                  }
                                },
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isAgeSelected = true;
                                  isHeightSelected =
                                      false;
                                  isWeightSelected =
                                      false;
                                });
                              },
                              child: CounterCard(
                                title: 'Age',
                                value: age,
                                backgroundColor:
                                    isAgeSelected
                                        ? activeCardColor
                                        : cardBackgroundColor,
                                textColor: textColor,
                                buttonBackgroundColor:
                                    counterButtonColor,
                                buttonIconColor:
                                    counterIconColor,
                                onIncrement: () {
                                  setState(() {
                                    age++;
                                    isAgeSelected = true;
                                  });

                                  _saveBasicProfileData();
                                },
                                onDecrement: () {
                                  if (age > 1) {
                                    setState(() {
                                      age--;
                                      isAgeSelected = true;
                                    });

                                    _saveBasicProfileData();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Calculate Button
            GestureDetector(
              onTap: () async {
                final double heightInMeters =
                    height / 100;

                final double bmi =
                    weight /
                    (heightInMeters * heightInMeters);

                String resultText;
                String interpretation;

                if (bmi < 18.5) {
                  resultText = 'Underweight';
                  interpretation =
                      'You Have a Low Body Weight.\n'
                      'Try to eat a balanced diet.';
                } else if (bmi < 25) {
                  resultText = 'Normal';
                  interpretation =
                      'You Have a Normal Body Weight,\n'
                      'Good Job.';
                } else if (bmi < 30) {
                  resultText = 'Overweight';
                  interpretation =
                      'You Have a Higher Than Normal Body Weight.';
                } else {
                  resultText = 'Obese';
                  interpretation =
                      'You Have a High Body Weight.\n'
                      'Consider a healthy lifestyle.';
                }

                final bmiHistory =
                    BmiHistoryModel(
                  bmi: bmi,
                  result: resultText,
                  interpretation: interpretation,
                  age: age,
                  weight: weight,
                  height: height,
                  isMale: isMale,
                  date: DateTime.now(),
                );

                final box =
                    Hive.box<BmiHistoryModel>(
                  'bmi_history',
                );

                await box.add(bmiHistory);

                // Save latest BMI
                final profileBox =
                    Hive.box('profile_data');

                await profileBox.put('isMale', isMale);
                await profileBox.put('age', age);
                await profileBox.put('weight', weight);
                await profileBox.put('height', height);
                await profileBox.put('bmi', bmi);
                await profileBox.put(
                  'resultText',
                  resultText,
                );

                if (!context.mounted) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResultScreen(
                      bmiResult:
                          bmi.toStringAsFixed(1),
                      resultText: resultText,
                      interpretation:
                          interpretation,
                      isOn: isOn,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                margin:
                    const EdgeInsets.only(top: 10),
                decoration: const BoxDecoration(
                  color: pinkColor,
                  borderRadius:
                      BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Calculate',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}