import 'package:fic4_tugas_akhir_ekatalog/bloc/register/register_bloc.dart';
import 'package:fic4_tugas_akhir_ekatalog/data/models/request/register_model.dart';
import 'package:fic4_tugas_akhir_ekatalog/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fic4_tugas_akhir_ekatalog/themes/top_bar.dart';
import 'package:fic4_tugas_akhir_ekatalog/themes/colors.dart';

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
    super.dispose();
    nameController!.dispose();
    emailController!.dispose();
    passwordController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 90,
      //   title: const Text('Register',
      //    style: TextStyle(
      //     color: Color(0xff1f005c),
      //     fontStyle: FontStyle.normal,
      //     fontWeight: FontWeight.w900,
      //     fontSize: 45,
      //     ),
      //   ),
      // ),

      body: Stack(
        // decoration:  const BoxDecoration(
        //   borderRadius: BorderRadius.only(
        //     topLeft:  Radius.circular(40.0),
        //     topRight: Radius.circular(40.0)
        //   ),
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment(0, 3),
        //     colors: <Color>[
        //       Colors.orange,
        //       // Colors.yellow,
        //       Colors.red,
        //       // Color.fromARGB(255, 13, 4, 31),
        //       // Color(0xff5b0060),
        //       // Color(0xff870160),
        //       // Color(0xffac255e),
        //       // Color(0xffca485c),
        //       // Color(0xffe16b5c),
        //       // Color(0xfff39060),
        //       // Color(0xffffb56b),
        //     ],
        //     tileMode: TileMode.mirror,

        //   ),
        //  ),
        children: [
          const Stack(
            children: <Widget>[
              TopBar(),
              Positioned(
                top: 60.0,
                left: 20.0,
                right: 0.0,
                child: Row(
                  children: <Widget> [
                    Column(
                      children: <Widget>[
                        Text('Register',
                        style: TextStyle(color: Colors.white, fontSize: 34, fontWeight:FontWeight.w900, letterSpacing: 4),),
                      ]

                    ),
                    ],
                ),
                ),
            ],
          ),
         Padding(
          // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 120),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 120),
              TextField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle : const TextStyle(color: Colors.grey),
                  fillColor: Colors.transparent,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.orange,
                    ),
                  ),
                  ),
                controller: nameController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(labelText: 'Email',
                labelStyle : const TextStyle(color: Colors.grey),
                fillColor: Colors.transparent,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.orange,
                    ),
                  ),
                ),
                controller: emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password',
                labelStyle : const TextStyle(color: Colors.grey),
                fillColor: Colors.transparent,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.orange,
                    ),
                  ),
                ),
                controller: passwordController,
              ),
              const SizedBox(
                height: 46 ,
              ),
              BlocConsumer<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  if (state is RegisterLoaded) {
                    nameController!.clear();
                    emailController!.clear();
                    passwordController!.clear();
                    //navigasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.blue,
                          content: Text(
                              'success register with id: ${state.model.id}')),
                    );
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }));
                  }
                },

                builder: (context, state) {
                  if (state is RegisterLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {
                      final requestModel = RegisterModel(
                        name: nameController!.text,
                        email: emailController!.text,
                        password: passwordController!.text,
                      );

                      context
                          .read<RegisterBloc>()
                          .add(SaveRegisterEvent(request: requestModel));
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        minimumSize: const Size.fromHeight(50),
                        shadowColor: Colors.grey.withOpacity(0.4),
                        elevation: 24, // e
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('Register',
                      style: TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w700),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }));
                },
                // child: const Text(
                //   'Belum Punya Akun? Register',
                //    style: TextStyle(color : Colors.white),
                //   // style: TextStyle(decoration: TextDecoration.underline),
                // ),
                child: RichText(
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: 'Already have an account ? ', style: TextStyle(color: Colors.black)),
                      TextSpan(text: 'Log In', style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
  ],),
    );
  }
}
