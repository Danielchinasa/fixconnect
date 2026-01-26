import 'package:fix_connect_mobile/app/theme/app_gaps.dart';
import 'package:fix_connect_mobile/app/theme/theme_cubit.dart';
import 'package:fix_connect_mobile/core/widgets/input_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _focusNodeEmail = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Fix Connect',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            AppGaps.hXs,
            Text(
              'Hi! Welcome back, you\'ve been missed',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            AppGaps.hLg,
            InputPrimary(
              focusNode: _focusNodeEmail,
              controller: TextEditingController(),
              autofocus: true,
              label: 'Email Address',
              prefixIcon: Icon(
                Icons.email,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
