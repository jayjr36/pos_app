import 'package:flutter_pos/app/database/app_database.dart';
import 'package:flutter_pos/data/datasources/local/transaction_local_datasource_impl.dart';
import 'package:flutter_pos/data/models/ordered_product_model.dart';
import 'package:flutter_pos/data/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('TransactionLocalDatasourceImpl', () {
    // Create an instance of the AppDatabase
    AppDatabase appDatabase = AppDatabase();

    // Declare a late variable for the datasource
    late TransactionLocalDatasourceImpl datasource;

    setUp(() async {
      // Initialize FFI (Foreign Function Interface) for SQFlite
      sqfliteFfiInit();
      // Change the default factory for unit testing calls to use FFI
      databaseFactory = databaseFactoryFfi;

      // Open an in-memory database for testing
      var testDatabase = await openDatabase(inMemoryDatabasePath, version: 1);

      // Initialize the AppDatabase with the test database
      await appDatabase.init(testDatabase: testDatabase);

      // Initialize the datasource with the AppDatabase
      datasource = TransactionLocalDatasourceImpl(appDatabase);
    });

    // Create a sample userId
    const userId = "user123";

    // Create a sample transaction
    final transaction = TransactionModel(
      id: 1,
      createdById: userId,
      paymentMethod: 'Cash',
      receivedAmount: 1,
      returnAmount: 0,
      totalAmount: 1,
      totalOrderedProduct: 1,
      orderedProducts: [
        OrderedProductModel(
          id: 1,
          transactionId: 1,
          productId: 1,
          quantity: 1,
          stock: 1,
          name: "name",
          imageUrl: "",
          price: 1,
        ),
      ],
    );

    // Test: createTransaction inserts the transaction into the database
    test('createTransaction inserts transaction into the database', () async {
      // Call the createTransaction method
      final res = await datasource.createTransaction(transaction);

      // Verify that the ID returned matches the transaction's ID
      expect(res, equals(transaction.id));
    });

    // Test: updateTransaction updates the transaction in the database
    test('updateTransaction updates transaction in the database', () async {
      final updateTransaction = datasource.updateTransaction(transaction);

      // Expect that the update completes successfully
      expectLater(updateTransaction, completes);
    });

    // Test: getTransaction retrieves the transaction from the database
    test('getTransaction retrieves transaction from the database', () async {
      final res = await datasource.getTransaction(transaction.id);

      // Verify that the retrieved transaction's ID matches the expected ID
      expect(res?.id, equals(transaction.id));
    });

    // Test: getAllUserTransactions retrieves all transactions for a given user
    test('getAllUserTransactions retrieves all user transactions from the database', () async {
      final res = await datasource.getAllUserTransactions(userId);

      // Expect that the result is not empty
      expect(res, isNotEmpty);
    });

    // Test: deleteTransaction deletes the transaction from the database
    test('deleteTransaction deletes transaction from the database', () async {
      final deleteTransaction = datasource.deleteTransaction(transaction.id);

      // Expect that the deletion completes successfully
      expectLater(deleteTransaction, completes);
    });
  });
}
