import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class PurchaseService {
  Future<bool> buyHints(int count);
  Future<void> restorePurchases();
  Future<bool> isAvailable();
}

class MobilePurchaseService implements PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  static const Set<String> _productIds = {
    'hints_3',
    'hints_5',
    'hints_10',
    'hints_20',
  };

  @override
  Future<bool> isAvailable() => _iap.isAvailable();

  @override
  Future<bool> buyHints(int count) async {
    final products = await _iap.queryProductDetails(_productIds);
    final product = products.productDetails.firstWhere(
      (p) => p.id == 'hints_$count',
      orElse: () => throw Exception('Product not found'),
    );

    await _iap.buyConsumable(
      purchaseParam: PurchaseParam(productDetails: product),
    );
    return true;
  }

  @override
  Future<void> restorePurchases() => _iap.restorePurchases();
}

class WebPurchaseService implements PurchaseService {
  @override
  Future<bool> buyHints(int count) async {
    // Реализация для веба (может быть заглушкой или интеграцией с другой платежной системой)
    debugPrint('WEB: Simulating purchase of $count hints');
    await Future.delayed(const Duration(seconds: 1)); // Имитация задержки
    return true;
  }

  @override
  Future<void> restorePurchases() async {
    debugPrint('WEB: Restore purchases not supported');
  }

  @override
  Future<bool> isAvailable() async => false;
}
