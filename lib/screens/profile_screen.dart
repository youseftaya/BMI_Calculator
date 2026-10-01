import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'home_screens.dart';

class ProfileScreen extends StatefulWidget {
  final bool isOn;

  const ProfileScreen({
    super.key,
    required this.isOn,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController =
      TextEditingController(text: 'Youssef Mahmoud');

  late bool isDark;

  bool isMale = true;
  int age = 26;
  int weight = 60;
  double height = 150;
  double? bmi;

  String resultText = '';

  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();

    isDark = widget.isOn;

    _loadProfileData();
  }

  void _loadProfileData() {
    final box = Hive.box('profile_data');

    final savedName = box.get('name');
    final savedGender = box.get('isMale');
    final savedAge = box.get('age');
    final savedWeight = box.get('weight');
    final savedHeight = box.get('height');
    final savedBmi = box.get('bmi');
    final savedResult = box.get('resultText');
    final savedImage = box.get('imageBytes');

    if (savedName != null) {
      nameController.text = savedName.toString();
    }

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

    if (savedBmi != null) {
      bmi = (savedBmi as num).toDouble();
    }

    if (savedResult != null) {
      resultText = savedResult.toString();
    }

    if (savedImage != null) {
      imageBytes = Uint8List.fromList(
        List<int>.from(savedImage),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final bytes = await image.readAsBytes();

    final box = Hive.box('profile_data');

    await box.put('imageBytes', bytes);

    if (!mounted) return;

    setState(() {
      imageBytes = bytes;
    });
  }

  Future<void> _saveName(String name) async {
    final box = Hive.box('profile_data');

    await box.put('name', name);

    if (!mounted) return;

    setState(() {
      nameController.text = name;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isDark
        ? const Color(0xFF1C2135)
        : const Color(0xFFF5F5F5);

    final Color cardColor =
        isDark ? const Color(0xFF24263B) : Colors.white;

    final Color textColor =
        isDark ? Colors.white : Colors.black87;

    final Color secondaryColor =
        isDark ? Colors.grey : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,

        title: Text(
          'Profile',
          style: TextStyle(
            color: textColor,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),

        leadingWidth: 105,

        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isDark
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              color: Colors.pink,
              size: 21,
            ),

            const SizedBox(width: 2),

            Switch(
              value: isDark,
              onChanged: (value) {
                setState(() {
                  isDark = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.pink,
              inactiveThumbColor: Colors.pink,
              inactiveTrackColor:
                  Colors.pink.withOpacity(0.3),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(20, 10, 20, 25),
          child: Column(
            children: [
              // Profile Image
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.pink,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 58,
                        backgroundColor: Colors.pink,
                        backgroundImage: imageBytes != null
                            ? MemoryImage(imageBytes!)
                            : null,
                        child: imageBytes == null
                            ? const Icon(
                                Icons.person,
                                size: 62,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),

                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Colors.pink,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 13),

              Text(
                nameController.text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'BMI Calculator User',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 25),

              // Gender / Age
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      icon: Icons.person_outline,
                      title: 'Gender',
                      value: isMale ? 'Male' : 'Female',
                      cardColor: cardColor,
                      textColor: textColor,
                      secondaryColor: secondaryColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _infoCard(
                      icon: Icons.cake_outlined,
                      title: 'Age',
                      value: '$age',
                      cardColor: cardColor,
                      textColor: textColor,
                      secondaryColor: secondaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Height / Weight
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      icon: Icons.height,
                      title: 'Height',
                      value: '${height.round()} cm',
                      cardColor: cardColor,
                      textColor: textColor,
                      secondaryColor: secondaryColor,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _infoCard(
                      icon: Icons.monitor_weight_outlined,
                      title: 'Weight',
                      value: '$weight kg',
                      cardColor: cardColor,
                      textColor: textColor,
                      secondaryColor: secondaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // BMI Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.12),
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.monitor_heart_outlined,
                        color: Colors.pink,
                        size: 30,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latest BMI',
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            bmi == null
                                ? '--'
                                : bmi!.toStringAsFixed(1),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (resultText.isNotEmpty)
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.12),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: Text(
                          resultText,
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Edit Profile
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showEditNameDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Go To Home
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BmiScreen(
                          isOn: isDark,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.pink,
                    side: const BorderSide(
                      color: Colors.pink,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text(
                    'Go to Home',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // History
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: secondaryColor,
                    side: BorderSide(
                      color: isDark
                          ? Colors.white24
                          : Colors.black12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.history),
                  label: const Text(
                    'BMI History',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color cardColor,
    required Color textColor,
    required Color secondaryColor,
  }) {
    return Container(
      height: 115,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.pink,
            size: 27,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: TextStyle(
              color: secondaryColor,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final controller =
        TextEditingController(text: nameController.text);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),

          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();

                if (name.isNotEmpty) {
                  await _saveName(name);
                }

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}