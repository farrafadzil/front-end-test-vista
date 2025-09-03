import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/company_provider.dart';
import 'providers/service_provider.dart';
import 'screens/company_list_screen.dart';
import 'screens/create_company_screen.dart';
import 'screens/create_service_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vista App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => CompanyListScreen(),
        '/create-company': (_) => CreateCompanyScreen(),
       '/create-service': (_) => CreateServiceScreen(),
      },
    );
  }
}
