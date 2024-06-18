import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_work/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:new_work/src/screens/auth_check/auth_check.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(CheckAuthEvent()),
      child: const MaterialApp(
        home: AuthCheck(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
