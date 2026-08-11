import 'package:flutter/material.dart';
import 'package:wallet/pages/auth/sign_in/screen/sign_in_screen.dart';
import 'package:wallet/pages/auth/sign_up/screen/sign_up_screen.dart';
import 'package:wallet/pages/home/screen/home_screen.dart';
import 'package:wallet/pages/taskes/screen/taskes_details_screen.dart';
import 'package:wallet/pages/taskes/screen/taskes_screen.dart';

Map<String, WidgetBuilder> routes = {
  SignInScreen.id: (context) => const SignInScreen(),
  SignUpScreen.id: (context) => const SignUpScreen(),
  HomeScreen.id: (context) => const HomeScreen(),
  TaskesScreen.id: (context) => const TaskesScreen(),
  TaskesDetailsScreen.id: (context) => const TaskesDetailsScreen(),
};
