import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boutique_fluide/theme.dart';
import 'package:boutique_fluide/nav.dart';
import 'package:boutique_fluide/services/product_service.dart';
import 'package:boutique_fluide/services/admin_auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => AdminAuthService()),
      ],
      child: const _AppRoot(),
    );
  }
}

class _AppRoot extends StatefulWidget {
  const _AppRoot();

  @override
  State<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<_AppRoot> {
  GoRouter? _router;
  AdminAuthService? _authRef;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.read<AdminAuthService>();
    if (_router == null || _authRef != auth) {
      _authRef = auth;
      _router = AppRouter.createRouter(auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Boutique Fluide',
      debugShowCheckedModeBanner: false,
      theme: boutiqueTheme,
      routerConfig: _router!,
    );
  }
}
