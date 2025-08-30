import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:storifuel/core/theme/app_theme.dart';
import 'package:storifuel/firebase_options.dart';
import 'package:storifuel/routes/routes.dart';
import 'package:storifuel/routes/routes_name.dart';
import 'package:storifuel/view_model/Auth/auth_provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: ToastificationWrapper(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'StoriFuel',
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          initialRoute: RoutesName.splash,
          onGenerateRoute: Routes.generateRoute,
        ),
      ),
    );
  }
}
