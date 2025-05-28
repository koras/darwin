import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class IAPService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // ID продуктов из консолей разработчика
  static const Map<int, String> _productIds = {
    3: 'hints_pack_3',
    5: 'hints_pack_5',
    10: 'hints_pack_10',
    20: 'hints_pack_20',
  };

  // Инициализация сервиса
  Future<void> init(Function(int) onPurchaseComplete) async {
    // Настройка для разных платформ
    if (defaultTargetPlatform == TargetPlatform.android) {
      await InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }

    // Подписка на обновления покупок
    _subscription = _iap.purchaseStream.listen((purchases) {
      _handlePurchases(purchases, onPurchaseComplete);
    });

    // Загрузка доступных продуктов
    await loadProducts();
  }

  // Загрузка информации о продуктах
  Future<Set<ProductDetails>> loadProducts() async {
    final bool available = await _iap.isAvailable();
    if (!available) throw Exception('IAP not available');

    final ProductDetailsResponse response = await _iap.queryProductDetails(
      _productIds.values.toSet(),
    );

    return response.productDetails;
  }

  // Обработка покупок
  void _handlePurchases(
    List<PurchaseDetails> purchases,
    Function(int) onPurchaseComplete,
  ) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        // Находим сколько подсказок куплено
        final count =
            _productIds.entries
                .firstWhere((e) => e.value == purchase.productID)
                .key;

        // Подтверждаем покупку
        _iap.completePurchase(purchase);

        // Вызываем колбэк
        onPurchaseComplete(count);
      }
    }
  }

  // Запуск процесса покупки
  Future<void> purchase(int count) async {
    final products = await loadProducts();
    final product = products.firstWhere(
      (p) => p.id == _productIds[count],
      orElse: () => throw Exception('Product not found'),
    );

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  // Очистка ресурсов
  void dispose() {
    _subscription.cancel();
  }
}
