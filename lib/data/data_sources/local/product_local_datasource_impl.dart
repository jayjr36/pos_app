import 'package:flutter_pos/core/database/app_database.dart';
import 'package:flutter_pos/data/data_sources/interfaces/product_datasource.dart';
import 'package:flutter_pos/data/models/product_model.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDatasourceImpl extends ProductDatasource {
  final AppDatabase _appDatabase;

  ProductLocalDatasourceImpl(this._appDatabase);

  @override
  Future<int> createProduct(ProductModel product) async {
    product.id ??= DateTime.now().millisecondsSinceEpoch;
    return await _appDatabase.database.insert(
      AppDatabaseConfig.productTableName,
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await _appDatabase.database.update(
      AppDatabaseConfig.productTableName,
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteProduct(int id) async {
    await _appDatabase.database.delete(
      AppDatabaseConfig.productTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<ProductModel?> getProduct(int id) async {
    var res = await _appDatabase.database.query(
      AppDatabaseConfig.productTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (res.isEmpty) {
      return null;
    }

    return ProductModel.fromJson(res.first);
  }

  @override
  Future<List<ProductModel>> getAllUserProduct(String id) async {
    var res = await _appDatabase.database.query(
      AppDatabaseConfig.productTableName,
      where: 'createdById = ?',
      whereArgs: [id],
    );

    return res.map((e) => ProductModel.fromJson(e)).toList();
  }
}