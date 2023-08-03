import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/cart_service.dart';
import '../../domain/item.dart';

class AddToCartController extends StateNotifier<AsyncValue<int>> {
  AddToCartController({required this.cartService}) : super(const AsyncData(1));
  final CartService cartService;

  void updateQuantity(int quantity) {
    state = AsyncData(quantity);
  }

  Future<void> addItem(ProductID productId) async {
    final item = Item(productId: productId, quantity: state.value!);
    state = const AsyncLoading<int>().copyWithPrevious(state);
    final value = await AsyncValue.guard(() => cartService.addItem(item));
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(1);
    }
  }

  //ToDO: Should this use autoDispose
  final addToCartControllerProvider = StateNotifierProvider<AddToCartController, AsyncValue<int>>((ref) {
    return AddToCartController(
      cartService: ref.watch(cartServiceProvider)
      );
  });
} 