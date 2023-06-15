import 'package:fic_bloc_ecatalog_sample/bloc/add_product/add_product_bloc.dart';
import 'package:fic_bloc_ecatalog_sample/bloc/products/products_bloc.dart';
import 'package:fic_bloc_ecatalog_sample/data/datasources/local_datasource.dart';
import 'package:fic_bloc_ecatalog_sample/data/models/request/product_request_model.dart';
import 'package:fic_bloc_ecatalog_sample/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController? titleController;
  TextEditingController? priceController;
  TextEditingController? descriptionController;

  final scrollController = ScrollController();

  @override
  void initState() {
    titleController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();

    context.read<ProductsBloc>().add(GetProductsEvent());
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        context.read<ProductsBloc>().add(NextProductsEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController!.dispose();
    priceController!.dispose();
    descriptionController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        elevation: 5,
        actions: [
          IconButton(
            onPressed: () async {
              await LocalDataSource().removeToken();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginPage();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsSuccess) {
            debugPrint('total data : ${state.data.length}');
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                  if (state.isNext && index == state.data.length) {
                    return const Card(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return Card(
                    child: ListTile(
                      title: Text(
                        state.data.reversed.toList()[index].title ?? '-',
                      ),
                      subtitle: Text('${state.data[index].price}\$'),
                    ),
                  );
                },
                itemCount:
                    state.isNext ? state.data.length + 1 : state.data.length,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Add Product"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: "Price",
                      ),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  BlocConsumer<AddProductBloc, AddProductState>(
                    listener: (context, state) {
                      if (state is ProductsSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Add Product Success",
                            ),
                          ),
                        );
                      }
                      if (state is AddProductError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Add Product ${state.message}"),
                          ),
                        );
                      }
                      context.read<ProductsBloc>().add(GetProductsEvent());
                      titleController!.clear();
                      priceController!.clear();
                      descriptionController!.clear();
                      Navigator.pop(context);
                    },
                    builder: (context, state) {
                      if (state is AddProductLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ElevatedButton(
                        onPressed: () {
                          final model = ProductRequestModel(
                            title: titleController!.text,
                            price: int.parse(priceController!.text),
                            description: descriptionController!.text,
                          );

                          context
                              .read<AddProductBloc>()
                              .add(DoAddProductEvent(model: model));
                        },
                        child: const Text("Add"),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
