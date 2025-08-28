import 'package:flutter/material.dart';
import 'package:storifuel/view/category/category_screen.dart';
import 'package:storifuel/view/favourite/favourite_screen.dart';
import 'package:storifuel/view/home/home_screen.dart';
import 'package:storifuel/view/profile/profile_screen.dart';

class NavBarProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  final List<Widget> screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const FavouriteScreen(),
    const ProfileScreen(),
  ];

  void updateSelectedIndex(int index) {
    // Skip index 2 (add button) as it doesn't have a screen
    if (index == 2) return;
    
    // Adjust index for screens list since we don't have add screen
    if (index > 2) {
      _selectedIndex = index - 1; // Adjust for missing add screen
    } else {
      _selectedIndex = index;
    }
    notifyListeners();
  }

  Widget getCurrentScreen() {
    return screens[_selectedIndex];
  }

  void showAddBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Create New Story',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Add your create story options here
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Write a Story'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to write story screen
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Upload Photos'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to photo upload screen
              },
            ),
            ListTile(
              leading: Icon(Icons.videocam),
              title: Text('Record Video'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to video recording screen
              },
            ),
          ],
        ),
      ),
    );
  }
}