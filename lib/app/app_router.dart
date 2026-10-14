import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/customers/presentation/customer_details_screen.dart';
import '../features/customers/presentation/customer_list_screen.dart';
import '../features/sales_orders/presentation/sales_order_detail_screen.dart';
import '../features/sales_orders/presentation/sales_order_list_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ValueNotifier<AuthState>(ref.read(authControllerProvider));
  ref.listen<AuthState>(authControllerProvider, (_, next) {
    authNotifier.value = next;
  });

  return GoRouter(
    initialLocation: '/loading',
    refreshListenable: authNotifier,
    redirect: (context, state) {
      final authState = authNotifier.value;
      if (authState.isLoading) {
        return state.matchedLocation == '/loading' ? null : '/loading';
      }

      final isLoginLocation = state.matchedLocation == '/login';
      final isLoadingLocation = state.matchedLocation == '/loading';

      if (!authState.isAuthenticated) {
        return isLoginLocation ? null : '/login';
      }

      if (isLoginLocation || isLoadingLocation) {
        return '/customers';
      }

      if (state.matchedLocation.startsWith('/orders') && !authState.isInternalUser) {
        return '/customers';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/loading',
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/customers',
        builder: (context, state) => const CustomerListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              return CustomerDetailsScreen(customerId: id);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const SalesOrderListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              return SalesOrderDetailScreen(orderId: id);
            },
          ),
        ],
      ),
    ],
  );
});
