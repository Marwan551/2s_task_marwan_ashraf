import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/odoo/odoo_exception.dart';
import '../data/customer_repository.dart';
import '../domain/customer.dart';

class CustomerListState {
  final List<Customer> customers;
  final bool isLoading;
  final bool isMoreLoading;
  final bool hasMore;
  final String searchQuery;
  final String? errorMessage;

  const CustomerListState({
    this.customers = const [],
    this.isLoading = false,
    this.isMoreLoading = false,
    this.hasMore = true,
    this.searchQuery = '',
    this.errorMessage,
  });

  CustomerListState copyWith({
    List<Customer>? customers,
    bool? isLoading,
    bool? isMoreLoading,
    bool? hasMore,
    String? searchQuery,
    String? errorMessage,
  }) {
    return CustomerListState(
      customers: customers ?? this.customers,
      isLoading: isLoading ?? this.isLoading,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
      hasMore: hasMore ?? this.hasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }
}

class CustomerListController extends StateNotifier<CustomerListState> {
  final CustomerRepository _repository;
  Timer? _debounceTimer;
  int _fetchGeneration = 0;

  CustomerListController(this._repository) : super(const CustomerListState()) {
    fetchInitial();
  }

  Future<void> fetchInitial() async {
    final generation = ++_fetchGeneration;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final list = await _repository.getCustomers(
        searchQuery: state.searchQuery,
        offset: 0,
        limit: 40,
      );
      if (generation != _fetchGeneration) return;
      state = state.copyWith(
        isLoading: false,
        customers: list,
        hasMore: list.length == 40,
      );
    } catch (e) {
      if (generation != _fetchGeneration) return;
      state = state.copyWith(
        isLoading: false,
        errorMessage: userFacingOdooError(e),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isMoreLoading || !state.hasMore || state.isLoading) return;
    state = state.copyWith(isMoreLoading: true);
    try {
      final newItems = await _repository.getCustomers(
        searchQuery: state.searchQuery,
        offset: state.customers.length,
        limit: 40,
      );
      state = state.copyWith(
        isMoreLoading: false,
        customers: [...state.customers, ...newItems],
        hasMore: newItems.length == 40,
      );
    } catch (e) {
      state = state.copyWith(
        isMoreLoading: false,
        errorMessage: userFacingOdooError(e),
      );
    }
  }

  void onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      state = state.copyWith(searchQuery: query);
      fetchInitial();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final customerListControllerProvider =
    StateNotifierProvider<CustomerListController, CustomerListState>((ref) {
  final repo = ref.watch(customerRepositoryProvider);
  return CustomerListController(repo);
});
