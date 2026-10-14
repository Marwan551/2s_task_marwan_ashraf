import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/odoo/odoo_exception.dart';
import '../data/sales_order_repository.dart';
import '../domain/sales_order.dart';
import 'sales_order_list_screen.dart';

final salesOrderDetailProvider =
    FutureProvider.family.autoDispose<SalesOrder, int>((ref, orderId) async {
  final repo = ref.watch(salesOrderRepositoryProvider);
  return repo.getSalesOrderDetail(orderId);
});

class SalesOrderDetailScreen extends ConsumerStatefulWidget {
  final int orderId;

  const SalesOrderDetailScreen({super.key, required this.orderId});

  @override
  ConsumerState<SalesOrderDetailScreen> createState() => _SalesOrderDetailScreenState();
}

class _SalesOrderDetailScreenState extends ConsumerState<SalesOrderDetailScreen> {
  bool _isConfirming = false;

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

  Future<void> _handleConfirmOrder(SalesOrder order) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Order'),
        content: Text('Are you sure you want to confirm quotation ${order.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isConfirming = true);
      try {
        final repo = ref.read(salesOrderRepositoryProvider);
        await repo.confirmSalesOrder(widget.orderId);
        ref.invalidate(salesOrderDetailProvider(widget.orderId));
        ref.invalidate(salesOrderListProvider);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sales order confirmed successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to confirm order: ${userFacingOdooError(e)}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isConfirming = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(salesOrderDetailProvider(widget.orderId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: orderAsync.when(
        data: (order) {
          final canConfirm = order.state == 'draft' || order.state == 'sent';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              order.name,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Chip(
                              label: Text(
                                _formatState(order.state),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: _getStateColor(order.state),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Customer: ${order.partnerName}', style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('Date: ${_formatDate(order.dateOrder)}', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Order Lines',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Product')),
                        DataColumn(label: Text('Qty'), numeric: true),
                        DataColumn(label: Text('Unit Price'), numeric: true),
                        DataColumn(label: Text('Subtotal'), numeric: true),
                      ],
                      rows: order.lines.map((line) {
                        return DataRow(
                          cells: [
                            DataCell(Text(line.productName)),
                            DataCell(Text(line.quantity.toStringAsFixed(0))),
                            DataCell(
                              Text(NumberFormat.simpleCurrency(name: order.currencyCode).format(line.priceUnit)),
                            ),
                            DataCell(
                              Text(
                                NumberFormat.simpleCurrency(name: order.currencyCode)
                                    .format(line.priceSubtotal),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Untaxed Amount:'),
                            Text(
                              NumberFormat.simpleCurrency(name: order.currencyCode)
                                  .format(order.amountUntaxed),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Taxes:'),
                            Text(
                              NumberFormat.simpleCurrency(name: order.currencyCode)
                                  .format(order.amountTax),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount:',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              NumberFormat.simpleCurrency(name: order.currencyCode)
                                  .format(order.amountTotal),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (canConfirm)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isConfirming ? null : () => _handleConfirmOrder(order),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: _isConfirming
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Confirm Order', style: TextStyle(fontSize: 16)),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              userFacingOdooError(err),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
