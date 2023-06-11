import 'package:fic_bloc_ecatalog_sample/bloc/register/register_bloc.dart';
import 'package:fic_bloc_ecatalog_sample/data/models/request/register_request_model.dart';
import 'package:fic_bloc_ecatalog_sample/presentation/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    nameController!.dispose();
    emailController!.dispose();
    passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page,"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Register User",
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Name",
            ),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
          ),
          TextField(
            obscureText: true,
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: "Password",
            ),
          ),
          BlocConsumer(
            builder: (context, state) {
              if (state is RegisterLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ElevatedButton(
                onPressed: () {
                  final requestModel = RegisterRequestModel(
                    name: nameController!.text,
                    email: emailController!.text,
                    password: passwordController!.text,
                  );
                  context.read<RegisterBloc>().add(
                        DoRegisterEvent(
                          model: requestModel,
                        ),
                      );
                },
                child: const Text("Register"),
              );
            },
            listener: (context, state) {
              if (state is RegisterError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (state is RegisterSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Register success with id: ${state.model}",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    },
                  ),
                );
              }
            },
          ),
          // BlocListener<RegisterBloc, RegisterState>(
          //   listener: (context, state) {
          //     if (state is RegisterError) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text(state.message),
          //           backgroundColor: Colors.red,
          //         ),
          //       );
          //     }
          //     if (state is RegisterSuccess) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text(
          //             "Register success with id: ${state.model}",
          //           ),
          //           backgroundColor: Colors.green,
          //         ),
          //       );
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) {
          //             return const LoginPage();
          //           },
          //         ),
          //       );
          //     }
          //   },
          //   child: BlocBuilder<RegisterBloc, RegisterState>(
          //     builder: (context, state) {
          //       if (state is RegisterLoading) {
          //         return const Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       }
          //       return ElevatedButton(
          //         onPressed: () {
          //           final requestModel = RegisterRequestModel(
          //             name: nameController!.text,
          //             email: emailController!.text,
          //             password: passwordController!.text,
          //           );
          //           context.read<RegisterBloc>().add(
          //                 DoRegisterEvent(
          //                   model: requestModel,
          //                 ),
          //               );
          //         },
          //         child: const Text("Register"),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
