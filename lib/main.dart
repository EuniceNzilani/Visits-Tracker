import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Add this import
import 'dart:async';
import 'data/services/api_service.dart';
import 'data/repositories/visit_repository.dart';
import 'data/repositories/customer_repository.dart';
import 'data/repositories/activity_repository.dart';
import 'presentation/bloc/visit_bloc.dart';
import 'presentation/pages/visits_list_page.dart';
import 'presentation/pages/add_visit_page.dart';

// Global constants for current user and time - UPDATED with current values
class AppConstants {
  static const String currentUser = 'EuniceNzilani';
  static final DateTime currentUtcTime = DateTime.parse('2025-05-30 20:16:56');
  static final String formattedCurrentTime = DateFormat(
    'yyyy-MM-dd HH:mm:ss',
  ).format(currentUtcTime);
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting
  initializeDateFormatting();

  // Run the app with error handling
  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, stackTrace) {
      debugPrint('Error: $error');
      debugPrint('Stack trace: $stackTrace');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // API Service provider
        RepositoryProvider<ApiService>(create: (context) => ApiService()),

        // Customer Repository provider
        RepositoryProvider<CustomerRepository>(
          create: (context) => CustomerRepository(context.read<ApiService>()),
        ),

        // Activity Repository provider
        RepositoryProvider<ActivityRepository>(
          create: (context) => ActivityRepository(context.read<ApiService>()),
        ),

        // Visit Repository provider
        RepositoryProvider<VisitRepository>(
          create: (context) => VisitRepository(context.read<ApiService>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Visit BLoC provider
          BlocProvider<VisitBloc>(
            create:
                (context) => VisitBloc(context.read<VisitRepository>())..add(
                  LoadVisits(),
                ), // Use LoadVisits instead of InitializeVisitBloc
          ),
        ],
        child: MaterialApp(
          title: 'RTM Sales Force Automation',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
            cardTheme: const CardTheme(
              elevation: 2,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: const CustomScrollBehavior(),
              child: child!,
            );
          },
          initialRoute: '/',
          routes: {
            '/': (context) => const VisitsListPage(),
            '/add-visit': (context) => const AddVisitPage(),
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder:
                  (context) => Scaffold(
                    appBar: AppBar(title: const Text('Error')),
                    body: Center(
                      child: Text('Page not found: ${settings.name}'),
                    ),
                  ),
            );
          },
        ),
      ),
    );
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  const CustomScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
