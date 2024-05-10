import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterdemoapp/auth/auth_provider.dart';
import 'package:flutterdemoapp/auth/bloc/auth_bloc.dart';
import 'package:flutterdemoapp/auth/bloc/auth_state.dart';
import 'package:flutterdemoapp/auth/sqlite_auth_provider.dart';
import 'package:flutterdemoapp/constants/colors.dart';
import 'package:flutterdemoapp/crud/sqlite_user_service.dart';
import 'package:logger/logger.dart';
import '../auth/auth_exceptions.dart';
import '../auth/bloc/auth_event.dart';
import '../crud/database_setup.dart';

var logger = Logger();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final DatabaseSetup _databaseSetup;
  late final UserService _userService;
  late final TextEditingController _username;
  late final TextEditingController _password;
  bool _isVisible = false;
  String _errorText = '';
  String _usernameErrorTextValue = '';
  String _passwordErrorTextValue = '';

  @override
  void initState() {
    _databaseSetup = DatabaseSetup();
    _userService = UserService();
    _databaseSetup.open();
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          logger.d('Login Exception is ${state.exception}');
          if (state.exception is UserNotFoundAuthException) {
            setState(() {
              _isVisible = true;
              _errorText = 'User not found';
            });
          } else if (state.exception is WrongCredentialAuthException) {
            setState(() {
              _isVisible = true;
              _errorText = 'Username and Password combination is wrong';
            });
          } else if (state.exception is GenericAuthException) {
            setState(() {
              _isVisible = true;
              _errorText = 'An error occured.Please try again later';
            });
          } else {
            //Clear any error on the screen if visible
            setState(() {
              _isVisible = false;
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: PRIMARY_COLOR_LIGHT,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Text(
                  'Login to your account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 70,
                ),
                TextField(
                  controller: _username,
                  decoration: InputDecoration(
                    errorText: _usernameErrorTextValue.isEmpty
                        ? null
                        : _usernameErrorTextValue,
                    border: const OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    errorText: _passwordErrorTextValue.isEmpty
                        ? null
                        : _passwordErrorTextValue,
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FilledButton(
                  onPressed: () {
                    _login(SQLiteAuthProvider());
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Login'),
                ),
                Visibility(
                  visible: _isVisible,
                  child: Text(
                    style:
                        const TextStyle(color: Color.fromARGB(255, 128, 4, 4)),
                    (_errorText),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _goToRegisterPage,
                    child: const Text('Sign Up'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login(AuthProvider provider) {
    final username = _username.text;
    final password = _password.text;
    final usernameValidationText =
        _userService.getUsernameValidationText(username);
    final passwordValidationText =
        _userService.getPasswordValidationText(password);
    // Validate email and password fields
    if (usernameValidationText != 'valid') {
      setState(() {
        _usernameErrorTextValue = usernameValidationText;
      });
      return;
    }
    _usernameErrorTextValue = '';
    if (passwordValidationText != 'valid') {
      setState(() {
        _passwordErrorTextValue = passwordValidationText;
      });
      return;
    }
    _passwordErrorTextValue = '';
    //Read authbloc from build context(Login)
    context.read<AuthBloc>().add(
          AuthEventLogin(username, password, provider),
        );
  }

  void _goToRegisterPage() {
    BlocProvider.of<AuthBloc>(context).add(const AuthEventShouldRegister());
    context.read<AuthBloc>().add(
          const AuthEventShouldRegister(),
        );
  }
}
