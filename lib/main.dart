import 'package:astrology_app/Bloc/astrologer_bloc.dart';
import 'package:astrology_app/Bloc/panchang_bloc.dart';
import 'package:astrology_app/Screens/home_screen.dart';
import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AstrologerBloc>(
        creator: (context, bag) => AstrologerBloc(),
        child: BlocProvider<PanchangBloc>(
            creator: (context, bag) => PanchangBloc(),
            child: MaterialApp(
              theme: ThemeData(
                  iconTheme: const IconThemeData(color: Colors.black),
                  floatingActionButtonTheme:
                      const FloatingActionButtonThemeData(
                          foregroundColor: Colors.white),
                  primaryColor: Colors.orange,
                  primarySwatch: Colors.orange,
                  scaffoldBackgroundColor: Colors.white,
                  appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.white,
                      centerTitle: true,
                      elevation: 0)),
              title: 'Flutter Demo',
              home: HomeScreen(),
            )));
  }
}
