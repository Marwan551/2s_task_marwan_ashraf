import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/odoo/odoo_exception.dart';
import '../data/sales_order_repository.dart';
import '../domain/sales_order.dart';

final salesOrderListProvider = FutureProvider.autoDispose<List<SalesOrder>>((ref) async {
  final repo = ref.watch(salesOrderRepositoryProvider);
  return repo.getSalesOrders();
});

class SalesOrderListScreen extends ConsumerWidget {
  const SalesOrderListScreen({super.key});

  Color _getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'draft':
        return Colors.blue;
      case 'sent':
        return Colors.cyan.shade700;
      case 'sale':
        return Colors.green;
      case 'done':
        return Colors.purple;
      case 'cancel':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatState(String state) {
    switch (state.toLowerCase()) {
      case 'draft':
        return 'Quotation';
      case 'sent':
        return 'Quotation Sent';
      case 'sale':
        return 'Sales Order';
      case 'done':
        return 'Locked';
      case 'cancel':
        return 'Cancelled';
      default:
        return state;
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(salesOrderListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(salesOrderListProvider),
          ),
        ],
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('No sales orders found'));
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(salesOrderListProvider);
            },
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStateColor(order.state).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _getStateColor(order.state)),
                          ),
                          child: Text(
                            _formatState(order.state),
                            style: TextStyle(
                              color: _getStateColor(order.state),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Customer: ${order.partnerName}'),
                        Text(
                          'Date: ${_formatDate(order.dateOrder)}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          NumberFormat.simpleCurrency(name: order.currencyCode)
                              .format(order.amountTotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      context.push('/orders/${order.id}');
                    },
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  userFacingOdooError(err),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(salesOrderListProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
