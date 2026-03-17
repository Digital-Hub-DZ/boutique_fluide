import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boutique_fluide/services/admin_auth_service.dart';
import 'package:boutique_fluide/pages/home_page.dart';
import 'package:boutique_fluide/pages/product_details_page.dart';
import 'package:boutique_fluide/pages/admin_login_page.dart';
import 'package:boutique_fluide/pages/admin_dashboard_page.dart';
import 'package:boutique_fluide/pages/edit_product_page.dart';

class AppRouter {
  static GoRouter createRouter(AdminAuthService auth) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: auth,
      redirect: (context, state) {
        final isAdminRoute = state.matchedLocation.startsWith('/admin') &&
            state.matchedLocation != '/admin/login';
        if (isAdminRoute && !auth.isSignedIn) {
          return '/admin/login?from=${state.matchedLocation}';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) =>
              ProductDetailsPage(productId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/admin/login',
          builder: (context, state) => const AdminLoginPage(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardPage(),
        ),
        GoRoute(
          path: '/admin/add',
          builder: (context, state) => const EditProductPage(),
        ),
        GoRoute(
          path: '/admin/edit/:id',
          builder: (context, state) =>
              EditProductPage(productId: state.pathParameters['id']),
        ),
      ],
    );
  }
}
