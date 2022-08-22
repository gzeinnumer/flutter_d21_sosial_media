# flutter_d21_sosial_media


|<img src="/preview/preview1.png" width="300"/>|<img src="/preview/preview2.png" width="300"/>|<img src="/preview/preview3.png" width="300"/>|<img src="/preview/preview4.png" width="300"/>|
|--|--|--|--|

- auth_repository.dart
```dart
class AuthRepository{
  Future<void> login() async{
    await Future.delayed(const Duration(seconds: 3));
  }
}
```

- login_view.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_d21_sosial_media/auth_repository.dart';
import 'package:flutter_d21_sosial_media/bloc/login/login_bloc.dart';
import 'package:flutter_d21_sosial_media/bloc/login/login_event.dart';
import 'package:flutter_d21_sosial_media/bloc/login/login_state.dart';
import 'package:flutter_d21_sosial_media/bloc/login/login_status.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) =>
                LoginBloc(authRepository: context.read<AuthRepository>()),
          ),
        ],
        child: _loginForm(),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final status = state.status;
          if (status is SubmissionFailed) {
            _showSnackbar(context, status.exception.toString());
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _usernameField(),
                  _passwordField(),
                  _loginBtn(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        decoration: const InputDecoration(
          icon: Icon(Icons.person),
          hintText: "Username",
        ),
        validator: (value) => state.isValidUsername ? null : "To short",
        onChanged: (value) => context
            .read<LoginBloc>()
            .add(LoginUsernameChangedEvent(username: value)),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(
          icon: Icon(Icons.security),
          hintText: "Password",
        ),
        validator: (value) => state.isValidPassword ? null : "To short",
        onChanged: (value) => context
            .read<LoginBloc>()
            .add(LoginPasswordChangedEvent(password: value)),
      );
    });
  }

  Widget _loginBtn() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.status is FormSubmitting
          ? const CircularProgressIndicator()
          : ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(LoginSubmittedEvent());
                }
              },
              child: const Text('Login'),
            );
    });
  }

void _showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
}
```

- main.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_d21_sosial_media/auth_repository.dart';
import 'package:flutter_d21_sosial_media/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => AuthRepository())
        ],
        child: LoginView(),
      ),
    );
  }
}
```

---

```
Copyright 2022 M. Fadli Zein
```