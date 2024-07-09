import 'package:flutter/foundation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../app/services/auth/auth_service.dart';
import '../../../app/utilities/console_log.dart';
import '../../../core/errors/errors.dart';
import '../../../core/usecase/usecase.dart';
import '../../../domain/entities/ordered_product_entity.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/repositories/transaction_repository.dart';
import '../../../domain/usecases/transaction_usecases.dart';
import '../../../service_locator.dart';
import '../products/products_provider.dart';

class HomeProvider extends ChangeNotifier {
  final TransactionRepository transactionRepository;

  HomeProvider({required this.transactionRepository});

  final panelController = PanelController();

  bool isPanelExpanded = false;

  List<ProductEntity>? allProducts;

  List<OrderedProductEntity> orderedProducts = [];
  int receivedAmount = 0;
  String selectedPaymentMethod = 'cash';
  String? customerName;
  String? description;

  void resetStates() {
    isPanelExpanded = false;
    allProducts = null;
    orderedProducts = [];
    receivedAmount = 0;
    selectedPaymentMethod = 'cash';
    customerName = null;
    description = null;
  }

  Future<Result<int>> createTransaction() async {
    try {
      var transaction = TransactionEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        paymentMethod: selectedPaymentMethod,
        customerName: customerName,
        description: description,
        orderedProducts: orderedProducts,
        createdById: AuthService().getAuthData()!.uid,
        receivedAmount: receivedAmount,
        returnAmount: receivedAmount - getTotalAmount(),
        totalOrderedProduct: orderedProducts.length,
        totalAmount: getTotalAmount(),
      );

      var res = await CreateTransactionUsecase(transactionRepository).call(transaction);

      resetStates();
      panelController.close();

      // Refresh products
      sl<ProductsProvider>().getAllProducts();

      return res;
    } catch (e) {
      cl('[createTransaction].error $e');
      return Result.error(APIError(error: e.toString()));
    }
  }

  void onChangedIsPanelExpanded(bool val) {
    isPanelExpanded = val;
    notifyListeners();
  }

  void onAddOrderedProduct(ProductEntity product, int qty) {
    if (orderedProducts.where((e) => e.productId == product.id).isNotEmpty) {
      orderedProducts.firstWhere((e) => e.productId == product.id).quantity = qty;
    } else {
      var order = OrderedProductEntity(quantity: qty, product: product, productId: product.id!);
      orderedProducts.add(order);
    }

    notifyListeners();
  }

  void onRemoveOrderedProduct(OrderedProductEntity val) {
    orderedProducts.remove(val);
    notifyListeners();
  }

  void onRemoveAllOrderedProduct() {
    orderedProducts.clear();
    panelController.close();
    isPanelExpanded = false;
    notifyListeners();
  }

  void onChangedOrderedProductQuantity(int index, int value) {
    orderedProducts[index].quantity = value;
    notifyListeners();
  }

  void onChangedReceivedAmount(int value) {
    receivedAmount = value;
    notifyListeners();
  }

  void onChangedPaymentMethod(String? value) {
    selectedPaymentMethod = value ?? selectedPaymentMethod;
    notifyListeners();
  }

  void onChangedCustomerName(String value) {
    customerName = value;
    notifyListeners();
  }

  void onChangedDescription(String value) {
    description = value;
    notifyListeners();
  }

  int getTotalAmount() {
    if (orderedProducts.isEmpty) return 0;
    return orderedProducts.map((e) => (e.product?.price ?? 0) * e.quantity).reduce((a, b) => a + b);
  }
}
