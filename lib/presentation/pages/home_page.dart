// ignore_for_file: use_build_context_synchronously

import 'package:fic4_tugas_akhir_ekatalog/bloc/product/create_product/create_product_bloc.dart';
import 'package:fic4_tugas_akhir_ekatalog/bloc/product/get_all_product/get_all_product_bloc.dart';
import 'package:fic4_tugas_akhir_ekatalog/bloc/profile/profile_bloc.dart';
import 'package:fic4_tugas_akhir_ekatalog/data/localsources/auth_local_storage.dart';
import 'package:fic4_tugas_akhir_ekatalog/data/models/request/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  @override
  void initState() {
    context.read<ProfileBloc>().add(GetProfileEvent());
    context.read<GetAllProductBloc>().add(DoGetAllProductEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hi Farel',
         style: TextStyle(
          color: Colors.black,
          // color: Color(0xff1f005c),
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthLocalStorage().removeToken();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }));
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is ProfileLoaded) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.profile.name ?? ''),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(state.profile.email ?? '',),
                ],
              );
            }
            return const Text('no data');
          }),
          // Profile Page
          Expanded(child: BlocBuilder<GetAllProductBloc, GetAllProductState>(
            builder: (context, state) {
              if (state is GetAllProductLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
               // Profile Page
              if (state is GetALlProductLoaded) {
                return ListView.builder(itemBuilder: ((context, index) {
                  final product = state.listProduct.reversed.toList()[index];
                  return Card(
                    color: const Color(0xfffeebdd),
                    child: ListTile(
                      leading: const CircleAvatar( backgroundImage: NetworkImage('https://s3.o7planning.com/images/boy-128.png'),
                      backgroundColor: Colors.blue,
                      // backgroundColor: Color(0xfff7924a),
                      ),
                      title: Text(product.title ?? '-', style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 18),),
                      subtitle: Text(product.description ?? '-',
                      style: const TextStyle(color: Colors.black),
                      ),
                      trailing: Text('Rp.${product.price}', style: const TextStyle(color: Color(0xffd07d42),fontWeight: FontWeight.w700),)
                    ),
                  );
                }));
              }
              return const Text('no data',);
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Product'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(labelText: 'Title'),
                        controller: titleController,
                      ),
                      TextField(
                        decoration: const InputDecoration(labelText: 'Price'),
                        controller: priceController,
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        maxLines: 3,
                        decoration:
                            const InputDecoration(labelText: 'Description',),
                        controller: descriptionController,
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    BlocListener<CreateProductBloc, CreateProductState>(
                      listener: (context, state) {
                        if (state is CreateProductLoaded) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                              Text('${state.productResponseModel.id}')));
                          Navigator.pop(context);
                          context
                            .read<GetAllProductBloc>()
                            .add(DoGetAllProductEvent());
                        }
                      },
                      child: BlocBuilder<CreateProductBloc, CreateProductState>(
                        builder: (context, state) {
                          if (state is CreateProductLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ElevatedButton(
                            onPressed: () {
                              final productModel = ProductModel(
                                title: titleController.text,
                                price: int.parse(priceController.text),
                                description: descriptionController.text,
                              );
                              context.read<CreateProductBloc>().add(
                                  DoCreateProductEvent(
                                      productModel: productModel));

                              // context
                              //     .read<GetAllProductBloc>()
                              //     .add(DoGetAllProductEvent());
                            },
                            child: const Text('Save'),
                          );
                        },
                      ),
                    ),
                  ],
                );
              });
        },
        child: Icon(Icons.add,color: Colors.blue.shade400),
      ),
    );
  }
}
