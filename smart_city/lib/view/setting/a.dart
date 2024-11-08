import 'package:flutter/material.dart';

class SettingUi extends StatefulWidget {
  const SettingUi({Key? key}) : super(key: key);

  @override
  State<SettingUi> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingUi> {
  bool isDarkMode = false;
  String selectedLanguage = 'English';
  String selectedVehicle = 'Personal Car';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [const Color(0xFF1A1A1A), const Color(0xFF303030)]
                : [const Color(0xFF2196F3), const Color(0xFF673AB7)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Profile Section
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: isDarkMode
                    ? const Color(0xFF424242)
                    : Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor:
                            isDarkMode ? Colors.grey[700] : Colors.blue[100],
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blue,
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // Handle avatar change
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'john.doe@email.com',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Settings Options
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: isDarkMode
                    ? const Color(0xFF424242)
                    : Colors.white.withOpacity(0.9),
                child: Column(
                  children: [
                    _buildSettingItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      onTap: () {},
                      isDarkMode: isDarkMode,
                    ),
                    _buildSettingItem(
                      icon: Icons.directions_car,
                      title: 'Vehicle Type',
                      trailing: DropdownButton<String>(
                        value: selectedVehicle,
                        dropdownColor:
                        isDarkMode ? const Color(0xFF424242) : Colors.white,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                        items: ['Personal Car', 'SUV', 'Electric Vehicle']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedVehicle = newValue!;
                          });
                        },
                      ),
                      isDarkMode: isDarkMode,
                    ),
                    _buildSettingItem(
                      icon: Icons.language,
                      title: 'Language',
                      trailing: DropdownButton<String>(
                        value: selectedLanguage,
                        dropdownColor:
                        isDarkMode ? const Color(0xFF424242) : Colors.white,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                        items: ['English', 'Spanish', 'French', 'German']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLanguage = newValue!;
                          });
                        },
                      ),
                      isDarkMode: isDarkMode,
                    ),
                    _buildSettingItem(
                      icon: Icons.brightness_6,
                      title: 'Theme',
                      trailing: Switch(
                        value: isDarkMode,
                        activeColor: Colors.blue,
                        onChanged: (bool value) {
                          setState(() {
                            isDarkMode = value;
                          });
                        },
                      ),
                      isDarkMode: isDarkMode,
                    ),
                    _buildSettingItem(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {},
                      isDarkMode: isDarkMode,
                    ),
                    _buildSettingItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: () {},
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Logout Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  // Handle logout
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    required bool isDarkMode,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
        isDarkMode ? Colors.grey[800] : Colors.blue.withOpacity(0.1),
        child: Icon(
          icon,
          color: Colors.blue,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDarkMode ? Colors.white54 : Colors.black54,
          ),
      onTap: onTap,
    );
  }
}