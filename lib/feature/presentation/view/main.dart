import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../feature/presentation/provider/auth_notifier.dart';
import '../../../feature/presentation/view/main_home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspass');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.when(
      data: (user) {

        if (user != null) {
          return MainHomeScreen(user: user);
        }


        return Scaffold(
          appBar: AppBar(
            title: const Text('Log In'),
            backgroundColor: Colors.blue,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(authControllerProvider.notifier).login(
                      _usernameController.text,
                      _passwordController.text,
                    );
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        );
      },
      error: (error, stack) {
        String errorMessage = error.toString();
        if (error is DioException) {
          errorMessage = error.response?.data['message'] ?? 'Network Error';
        }
        return Scaffold(
          body: Center(
            child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}