import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_login_project/feature/presentation/provider/auth_notifier.dart';
import '../../../feature/data/datasource/api_client.dart';
import '../../../feature/data/model/products_model.dart';

class ProductState {
  final List<Product> products;
  final bool isLoadingMore;
  final bool hasMore;
  final int skip;

  ProductState({
    required this.products,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.skip = 0
  });

  ProductState copyWith({
    List<Product>? products,
    bool? isLoadingMore,
    bool? hasMore,
    int? skip
  }) {
    return ProductState(
        products: products ?? this.products,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasMore: hasMore ?? this.hasMore,
        skip: skip ?? this.skip
    );
  }
}

class ProductsNotifier extends AutoDisposeAsyncNotifier<ProductState> {
  static const int _limit = 10;

  @override
  Future<ProductState> build() async {
    final client = ref.watch(apiClientProvider);
    final response = await client.getProducts(limit: _limit, skip: 0);
    return ProductState(
      products: response.products,
      skip: 0,
      hasMore: response.products.length < response.total,
    );
  }

  Future<void> fetchNextPage() async {
    final currentState = state.value;
    print("--> [Trace] Triggered fetchNextPage");
    print("--> [Trace] currentState null: ${currentState == null}");
    print("--> [Trace] isLoadingMore: ${currentState?.isLoadingMore}");
    print("--> [Trace] hasMore: ${currentState?.hasMore}");

    if (currentState == null || currentState.isLoadingMore || !currentState.hasMore) return;

    state = AsyncData(currentState.copyWith(isLoadingMore: true));
    final nextSkip = currentState.skip + _limit;
    print("--> [Trace] Fetching skip: $nextSkip, limit: $_limit");

    try {
      final client = ref.read(apiClientProvider);
      final response = await client.getProducts(limit: _limit, skip: nextSkip);

      print("--> [Trace] Fetched items count: ${response.products.length}");
      print("--> [Trace] Total items in API: ${response.total}");

      final updateList = [...currentState.products, ...response.products];
      print("--> [Trace] Total updated items in state: ${updateList.length}");

      state = AsyncData(
        currentState.copyWith(
          products: updateList,
          skip: nextSkip,
          isLoadingMore: false,
          hasMore: updateList.length < response.total,
        ),
      );
    } catch (e, st) {
      print("--> [Trace] Error fetching next page: $e");
      state = AsyncData(currentState.copyWith(isLoadingMore: false));
    }
  }
}

final productsNotifierProvider =
AsyncNotifierProvider.autoDispose<ProductsNotifier, ProductState>(
      () => ProductsNotifier(),
);