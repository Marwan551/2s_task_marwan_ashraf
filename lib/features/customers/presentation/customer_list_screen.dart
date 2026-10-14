import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/odoo/odoo_exception.dart';
import '../data/customer_repository.dart';
import '../../auth/presentation/auth_controller.dart';
import 'customer_list_controller.dart';

class CustomerListScreen extends ConsumerStatefulWidget {
  const CustomerListScreen({super.key});

  @override
  ConsumerState<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends ConsumerState<CustomerListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(customerListControllerProvider.notifier).loadMore();
    }
  }

  Future<void> _logout() async {
    final repository = ref.read(customerRepositoryProvider);
    try {
      if (await repository.pendingChangeCount() > 0) {
        String? syncError;
        try {
          await repository.processOutbox();
        } catch (error) {
          syncError = userFacingOdooError(error);
        }
        final pendingCount = await repository.pendingChangeCount();
        if (pendingCount > 0 && mounted) {
          final discardChanges = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Pending customer edits'),
              content: Text(
                '$pendingCount phone ${pendingCount == 1 ? 'change has' : 'changes have'} not synced. '
                'Signing out will discard them.'
                '${syncError == null ? '' : '\n\nLast sync error: $syncError'}',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Stay signed in'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Discard and sign out'),
                ),
              ],
            ),
          );
          if (discardChanges != true) return;
        }
      }
      await repository.clearLocalCustomers();
      ref.invalidate(customerListControllerProvider);
      await ref.read(authControllerProvider.notifier).logout();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not sign out safely: ${userFacingOdooError(error)}'),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(customerListControllerProvider);
    final isConnectedAsync = ref.watch(isConnectedProvider);
    final isConnected = isConnectedAsync.value ?? true;
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          if (authState.isInternalUser)
            IconButton(
              icon: const Icon(Icons.receipt_long),
              tooltip: 'Sales Orders',
              onPressed: () {
                context.push('/orders');
              },
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (!isConnected)
            Container(
              color: Colors.amber.shade800,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: const Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Offline Mode - Displaying cached data',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(customerListControllerProvider.notifier).onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (val) {
                setState(() {});
                ref.read(customerListControllerProvider.notifier).onSearchChanged(val);
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(customerListControllerProvider.notifier).fetchInitial();
              },
              child: listState.isLoading && listState.customers.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : listState.errorMessage != null && listState.customers.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.cloud_off_outlined, size: 40),
                                const SizedBox(height: 12),
                                Text(
                                  listState.errorMessage!,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton.icon(
                                  onPressed: () => ref
                                      .read(customerListControllerProvider.notifier)
                                      .fetchInitial(),
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Try again'),
                                ),
                              ],
                            ),
                          ),
                        )
                  : listState.customers.isEmpty
                      ? Center(
                          child: Text(
                            listState.searchQuery.isNotEmpty
                                ? 'No customers found for "${listState.searchQuery}"'
                                : 'No customers available',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: listState.customers.length + (listState.hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == listState.customers.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            final customer = listState.customers[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: Text(
                                    customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        customer.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    if (customer.isDirty)
                                      const Tooltip(
                                        message: 'Pending sync',
                                        child: Icon(Icons.sync_problem, color: Colors.orange, size: 20),
                                      ),
                                  ],
                                ),
                                subtitle: Text(
                                  [
                                    if (customer.phone != null && customer.phone!.isNotEmpty) customer.phone,
                                    if (customer.city != null && customer.city!.isNotEmpty) customer.city,
                                  ].join(' • '),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  context.push('/customers/${customer.id}');
                                },
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
