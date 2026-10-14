import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/odoo/odoo_exception.dart';
import '../data/customer_repository.dart';
import '../domain/customer.dart';
import 'customer_list_controller.dart';

class CustomerDetailsScreen extends ConsumerStatefulWidget {
  final int customerId;

  const CustomerDetailsScreen({super.key, required this.customerId});

  @override
  ConsumerState<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends ConsumerState<CustomerDetailsScreen> {
  Customer? _customer;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomer();
  }

  Future<void> _loadCustomer() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final repo = ref.read(customerRepositoryProvider);
      final customer = await repo.getCustomerById(widget.customerId);
      if (!mounted) return;
      setState(() {
        _customer = customer;
        _isLoading = false;
        _phoneController.text = customer?.phone ?? '';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = userFacingOdooError(error);
      });
    }
  }

  Future<void> _savePhone() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSaving = true);
      try {
        final repo = ref.read(customerRepositoryProvider);
        final newPhone = _phoneController.text.trim();
        final isOnlineDirect = await repo.updateCustomerPhone(widget.customerId, newPhone);
        if (!mounted) return;
        setState(() {
          _isSaving = false;
          _customer = _customer?.copyWith(phone: newPhone, isDirty: !isOnlineDirect);
        });
        ref.read(customerListControllerProvider.notifier).fetchInitial();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isOnlineDirect
                  ? 'Phone number updated successfully'
                  : 'Saved offline. Queued for sync when reconnected.',
            ),
          ),
        );
      } catch (error) {
        if (!mounted) return;
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not save phone number: ${userFacingOdooError(error)}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_customer?.name ?? 'Customer Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_errorMessage!, textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _loadCustomer,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                )
          : _customer == null
              ? const Center(child: Text('Customer not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  _customer!.name.isNotEmpty ? _customer!.name[0].toUpperCase() : '?',
                                  style: const TextStyle(color: Colors.white, fontSize: 24),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _customer!.name,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    if (_customer!.isDirty) ...[
                                      const SizedBox(height: 4),
                                      const Row(
                                        children: [
                                          Icon(Icons.sync_problem, color: Colors.orange, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            'Pending sync',
                                            style: TextStyle(color: Colors.orange, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Edit Phone Number',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Form(
                        key: _formKey,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  labelText: 'Phone',
                                  prefixIcon: Icon(Icons.phone),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (val) {
                                  if (val != null && val.trim().length > 40) {
                                    return 'Phone number must be 40 characters or fewer';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: _isSaving ? null : _savePhone,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Save'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Contact & Location Information',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.email),
                              title: const Text('Email'),
                              subtitle: Text(_customer!.email ?? 'Not provided'),
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: const Icon(Icons.location_on),
                              title: const Text('Address'),
                              subtitle: Text(
                                [
                                  if (_customer!.street != null && _customer!.street!.isNotEmpty)
                                    _customer!.street,
                                  if (_customer!.city != null && _customer!.city!.isNotEmpty)
                                    _customer!.city,
                                  if (_customer!.zip != null && _customer!.zip!.isNotEmpty)
                                    _customer!.zip,
                                  if (_customer!.country != null && _customer!.country!.isNotEmpty)
                                    _customer!.country,
                                ].join(', ').ifEmpty('Not provided'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

extension StringExt on String {
  String ifEmpty(String fallback) => isNotEmpty ? this : fallback;
}
