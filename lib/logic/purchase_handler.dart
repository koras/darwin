import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class PurchaseHandler {
  static final InAppPurchase _iap = InAppPurchase.instance;
  static late StreamSubscription<List<PurchaseDetails>> _subscription;

  static Future<void> init() async {
    // Настройка платформ
    if (defaultTargetPlatform == TargetPlatform.android) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iapStoreKit = InAppPurchaseStoreKitPlatformAddition();
      await iapStoreKit.setDelegate(ExamplePaymentQueueDelegate());
    }

    // Подписка на обновления покупок
    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => print('Purchase error: $error'),
    );

    // Подключение
    final bool available = await _iap.isAvailable();
    if (!available) {
      print('In-app purchases not available');
    }
  }

  static void _handlePurchaseUpdate(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        // Обработка успешной покупки
        _verifyAndDeliverProduct(purchase);
      }
    }
  }

  static Future<void> _verifyAndDeliverProduct(PurchaseDetails purchase) async {
    // Здесь должна быть ваша логика верификации покупки
    // и предоставления контента пользователю

    if (purchase.pendingCompletePurchase) {
      await _iap.completePurchase(purchase);
    }
  }

  static Future<void> buyProduct(String productId) async {
    try {
      final ProductDetailsResponse response = await _iap.queryProductDetails({
        productId,
      });
      if (response.notFoundIDs.isNotEmpty) {
        print('Product not found');
        return;
      }

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: response.productDetails.first,
      );

      await _iap.buyConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      print('Purchase error: $e');
    }
  }

  static Future<void> dispose() async {
    await _subscription.cancel();
  }
}

// Только для iOS
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
