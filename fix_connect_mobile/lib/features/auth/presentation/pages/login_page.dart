import 'package:fix_connect_mobile/app/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Fix Connect', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 8),
                  Text(
                    'Welcome back to your creative',
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.brightness_6),
                    onPressed: () {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
