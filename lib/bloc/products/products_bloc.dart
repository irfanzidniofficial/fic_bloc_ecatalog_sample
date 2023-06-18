// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:fic_bloc_ecatalog_sample/data/datasources/product_datasource.dart';

import '../../data/models/response/product_response_model.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductDataSource dataSource;
  ProductsBloc(
    this.dataSource,
  ) : super(ProductsInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductsLoading());
      final result = await dataSource.getPaginationProduct(
        offset: 0,
        limit: 50,
      );
      result.fold((error) => emit(ProductsError(message: error)), (result) {
        bool isNext = result.length == 50;
        emit(ProductsSuccess(data: result, isNext: isNext));
      });
    });

    on<NextProductsEvent>((event, emit) async {
      final currentState = state as ProductsSuccess;
      final result = await dataSource.getPaginationProduct(
        offset: currentState.offset + 50,
        limit: 50,
      );
      result.fold(
        (error) => emit(ProductsError(message: error)),
        (result) {
          bool isNext = result.length == 50;
          emit(
            ProductsSuccess(
                data: [...currentState.data, ...result],
                offset: currentState.offset + 50,
                isNext: isNext),
          );
        },
      );
    });

    on<AddSingleProductEvent>(
      (event, emit) async {
        final currentState = state as ProductsSuccess;

        emit(
          currentState.copyWith(
            data: [
              ...currentState.data,
              event.data,
            ],
          ),
        );
      },
    );

    // on<ClearProductsEvent>(
    //   (event, emit) async {
    //     final currentState = state as ProductsSuccess;

    //     emit(ProductsInitial());
    //   },
    // );
  }
}
