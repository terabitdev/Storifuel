import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/routes/routes_name.dart';
import 'package:storifuel/view/auth/check_email_screen.dart';
import 'package:storifuel/view/auth/forgot_password.dart';
import 'package:storifuel/view/category/category_screen.dart';
import 'package:storifuel/view/dashboard/dashboard_screen.dart';
import 'package:storifuel/view/favourite/favourite_screen.dart';
import 'package:storifuel/view/home/home_screen.dart';
import 'package:storifuel/view/onboarding/onboarding_screen.dart';
import 'package:storifuel/view/auth/sign_in_screen.dart';
import 'package:storifuel/view/auth/sign_up_screen.dart';
import 'package:storifuel/view/onboarding/splash_screen.dart';
import 'package:storifuel/view/profile/profile_screen.dart';
import 'package:storifuel/view/story/create_story_screen.dart';
import 'package:storifuel/view/story_details/story_details_screen.dart';
import 'package:storifuel/view_model/dashboard/dashboard_provider.dart';
import 'package:storifuel/view_model/story/story_provider.dart';
import 'package:storifuel/view_model/category/category_provider.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );
      case RoutesName.onboarding:
        return MaterialPageRoute(
          builder: (BuildContext context) => const OnboardingScreen(),
        );
      case RoutesName.createStory:
        return MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider(
            create: (_) => StoryProvider(),
            child: CreateStoryScreen(),
          ),
        );
      case RoutesName.signIn:
        return MaterialPageRoute(
          builder: (BuildContext context) => SignInScreen(),
        );
        case RoutesName.signUp:
        return MaterialPageRoute(
          builder: (BuildContext context) => SignUpScreen(),
        );
        case RoutesName.forgotPassword:
        return MaterialPageRoute(
          builder: (BuildContext context) => ForgotPasswordScreen(),
        );
        case RoutesName.checkEmail:
        return MaterialPageRoute(
          builder: (BuildContext context) => const CheckEmailScreen(),
        );
        case RoutesName.navbar:
        return MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider(
            create: (_) => NavBarProvider(),
            child: CustomNavigationBar(),
          ),
        );
         case RoutesName.home:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        );
      case RoutesName.category:
        return MaterialPageRoute(
          builder: (BuildContext context) => ChangeNotifierProvider(
            create: (_) => CategoryProvider(),
            child: const CategoryScreen(),
          ),
        );
      case RoutesName.favourite:
        return MaterialPageRoute(
          builder: (BuildContext context) => const FavouriteScreen(),
        );
      case RoutesName.profile:
        return MaterialPageRoute(
          builder: (BuildContext context) => const ProfileScreen(),
        );
      case RoutesName.storyDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (BuildContext context) => StoryDetailsScreen(
            storyId: args['storyId'],
            image: args['image'],
            title: args['title'],
            category: args['category'],
            timeAgo: args['timeAgo'],
            tags: args['tags'],
            content: args['content'],
          ),
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("No Route defined"))),
        );
    }
  }
}
