part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent {}


class GetProductsEvent extends ProductsEvent{}


class NextProductsEvent extends ProductsEvent{}

