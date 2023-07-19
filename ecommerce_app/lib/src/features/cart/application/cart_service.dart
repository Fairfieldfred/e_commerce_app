// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../products/domain/product.dart';
import '../domain/cart.dart';
import '../domain/item.dart';

class CartService {
  CartService(this.ref);
  final Ref ref;

  Future<Cart> _fetchCart() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteCartRepositoryProvider).fetchCart(user.uid);
    } else {
      return ref.read(localCartRepositoryProvider).fetchCart();
    }
  }

  //save the cart ot the local or remote Repository
  // depending on teh user auth state
  Future<void> _setCart(Cart cart) async  {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteCartRepositoryProvider).setCart(user.uid, cart);
    } else {
      await ref.read(localCartRepositoryProvider).setCart(cart);
    }
  }

  // sets an item in teh local or remote cart depending on the user atuh state
  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.setItem(item);
    await _setCart(updated);
  }

  // adds an item in the local or remote cart depending on the user auth state
  Future<void> addItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.addItem(item);
    await _setCart(updated);
  }

  // removes an item in the local or remote cart depending on the user auth state
  Future<void> removeItemById(ProductID productId) async {
    final cart = await  _fetchCart();
    final updated = cart.removeItemById(productId);
    await _setCart(updated);
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(ref);
});