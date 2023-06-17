// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_product_bloc.dart';

@immutable
abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {
  final ProductResponseModel model;

  AddProductSuccess({
    required this.model,
  });
}

class AddProductError extends AddProductState {
  final String message;

  AddProductError({
    required this.message,
  });
}
