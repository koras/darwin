import 'package:darwin/logic/iap_service.dart';

class PurchaseRepository {
  final IAPService _iapService;
  final Function(int) _onPurchaseComplete;

  PurchaseRepository(this._iapService, this._onPurchaseComplete);

  Future<void> init() async {
    await _iapService.init(_onPurchaseComplete);
  }

  Future<bool> purchaseHints(int count) async {
    try {
      await _iapService.purchase(count);
      return true;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _iapService.dispose();
  }
}
