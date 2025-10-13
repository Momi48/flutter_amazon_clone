import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:amazon_clone/routers.dart';
import 'package:amazon_clone/features/auth/screens/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => UserProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthServices authServices = AuthServices();
  @override
  void initState() {
    super.initState();
   
    authServices.getUserData(context);
    
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Hello');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),

      onGenerateRoute: (setting) => generateRouter(setting),
      home:
         Provider.of<UserProvider>(
                context,
                
              ).user.type == 'admin' ? AdminScreen() :   Provider.of<UserProvider>(
                context,
                
              ).user.token!.isNotEmpty 
              ? BottomBar() : AuthScreen()  
                 
       
    );
  }
}
