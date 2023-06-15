import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fic_bloc_ecatalog_sample/data/models/request/product_request_model.dart';
import 'package:fic_bloc_ecatalog_sample/data/models/response/product_response_model.dart';
import 'package:http/http.dart' as http;

class ProductDataSource {
  Future<Either<String, List<ProductResponseModel>>> getAllProduct() async {
    final response =
        await http.get(Uri.parse("https://api.escuelajs.co/api/v1/products/"));

    if (response.statusCode == 200) {
      return Right(
        List<ProductResponseModel>.from(
          jsonDecode(response.body).map(
            (x) => ProductResponseModel.fromMap(x),
          ),
        ),
      );
    } else {
      return const Left("get product error");
    }
  }

  // https://api.escuelajs.co/api/v1/products/?offset=0&limit=10

  Future<Either<String, List<ProductResponseModel>>> getPaginationProduct(
      {required int offset, required int limit}) async {
    final response = await http.get(Uri.parse(
        "https://api.escuelajs.co/api/v1/products/?offset=$offset&limit=$limit"));

    if (response.statusCode == 200) {
      return Right(
        List<ProductResponseModel>.from(
          jsonDecode(response.body).map(
            (x) => ProductResponseModel.fromMap(x),
          ),
        ),
      );
    } else {
      return const Left("get product error");
    }
  }

  Future<Either<String, ProductResponseModel>> createProduct(
      ProductRequestModel model) async {
    final response = await http.post(
        Uri.parse('https://api.escuelajs.co/api/v1/products/'),
        body: model.toJson(),
        headers: {'Content-Type': 'application/json'});

    if (response == 201) {
      return Right(
        ProductResponseModel.fromJson(
          response.body,
        ),
      );
    } else {
      return const Left('error add product');
    }
  }
}
