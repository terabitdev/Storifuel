import 'package:flutter_svg/svg.dart';
import 'package:storifuel/core/constants/app_images.dart';
import 'package:storifuel/core/theme/app_responsiveness.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/routes/routes_name.dart';
import 'package:storifuel/view_model/dashboard/dashboard_provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NavBarProvider>(
        builder: (context, navBarProvider, child) {
          return navBarProvider.getCurrentScreen();
        },
      ),
      bottomNavigationBar: Consumer<NavBarProvider>(
        builder: (context, navBarProvider, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: NavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                height: context.screenHeight * 0.09,
                selectedIndex: _getDisplaySelectedIndex(navBarProvider.selectedIndex),
                onDestinationSelected: (index) {
                  if (index == 2) {
                    // Add button clicked
                    navBarProvider.showAddBottomSheet(context);
                  } else {
                    navBarProvider.updateSelectedIndex(index);
                  }
                },
                indicatorColor: Colors.transparent,
                destinations: [
                  NavigationDestination(
                    icon: SvgPicture.asset(
                      navBarProvider.selectedIndex == 0
                          ? AppImages.homeColorIcon
                          : AppImages.homeIcon,
                    ),
                    label: '',
                  ),
                   NavigationDestination(
                    icon: SvgPicture.asset(
                      navBarProvider.selectedIndex == 1
                          ? AppImages.favouriteColorIcon
                          : AppImages.favouriteIcon,
                    ),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.createStory);
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 2,
                              blurRadius: 10,
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          AppImages.addIcon,
                        ),
                      ),
                    ),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: SvgPicture.asset(
                      navBarProvider.selectedIndex == 2
                          ? AppImages.categoryColorIcon
                          : AppImages.categoryIcon,
                    ),
                    label: '',
                  ),
                  NavigationDestination(
                    icon: SvgPicture.asset(
                      navBarProvider.selectedIndex == 3
                          ? AppImages.profileColorIcon
                          : AppImages.profileIcon,
                    ),
                    label: '',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int _getDisplaySelectedIndex(int actualIndex) {
    // Convert internal selectedIndex to display selectedIndex
    if (actualIndex >= 2) {
      return actualIndex + 1; // Adjust for add button at index 2
    }
    return actualIndex;
  }
}

