import 'package:flutter/material.dart';
import 'package:note_me/presentation/router/app_router.dart';
import 'package:provider/provider.dart';
import 'controller/provider/appProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppRouter _appRouter = AppRouter();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        onGenerateRoute: _appRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
