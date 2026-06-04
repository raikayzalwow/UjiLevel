import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'providers/notification_provider.dart';
import 'utils/app_theme.dart';
import 'screens/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ← TAMBAHAN INI
  await initializeDateFormatting('id_ID', null);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const HoomlyApp());
}

class HoomlyApp extends StatelessWidget {
  const HoomlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(
          create: (_) => UserProvider()..loadUser(),
        ),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'Hoomly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const MainScaffold(),
      ),
    );
  }
}