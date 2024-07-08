import 'package:equatable/equatable.dart';
import 'package:flutter_pos/domain/entities/ordered_product_entity.dart';
import 'package:flutter_pos/domain/entities/user_entity.dart';

class TransactionEntity extends Equatable {
  final int? id;
  final String paymentMethod;
  final String? customerName;
  final String? description;
  final String createdById;
  final UserEntity? createdBy;
  final List<OrderedProductEntity>? orderedProducts;
  final int receivedAmount;
  final int returnAmount;
  final int totalAmount;
  final String? createdAt;
  final String? updatedAt;

  const TransactionEntity({
    this.id,
    required this.paymentMethod,
    this.customerName,
    this.description,
    required this.createdById,
    this.createdBy,
    this.orderedProducts,
    required this.receivedAmount,
    required this.returnAmount,
    required this.totalAmount,
    this.createdAt,
    this.updatedAt,
  });

  TransactionEntity copyWith({
    int? id,
    String? paymentMethod,
    String? customerName,
    String? description,
    String? createdById,
    UserEntity? createdBy,
    List<OrderedProductEntity>? orderdProducts,
    int? receivedAmount,
    int? returnAmount,
    int? totalAmount,
    String? createdAt,
    String? updatedAt,
  }) {
    return TransactionEntity(
      id: id ?? this.id,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerName: customerName ?? this.customerName,
      description: description ?? this.description,
      createdById: createdById ?? this.createdById,
      createdBy: createdBy ?? this.createdBy,
      orderedProducts: orderdProducts ?? orderedProducts,
      receivedAmount: receivedAmount ?? this.receivedAmount,
      returnAmount: returnAmount ?? this.returnAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        paymentMethod,
        customerName,
        description,
        createdById,
        createdBy,
        orderedProducts,
        receivedAmount,
        returnAmount,
        totalAmount,
        createdAt,
        updatedAt
      ];
}
