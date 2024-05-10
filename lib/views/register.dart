import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../auth/auth_exceptions.dart';
import '../auth/auth_provider.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../auth/bloc/auth_state.dart';
import '../auth/sqlite_auth_provider.dart';
import '../constants/colors.dart';
import '../crud/sqlite_user_service.dart';
import '../utitliy_classes/dialogs.dart';

var logger = Logger();

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final UserService _userService;
  late final TextEditingController _username;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  bool _isVisible = false;
  String _errorText = '';
  String _usernameErrorTextValue = '';
  String _passwordErrorTextValue = '';
  String _confirmPasswordErrorTextValue = '';

  @override
  void initState() {
    _userService = UserService();
    _username = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
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
        if (state is AuthStateRegistering) {
          if (state.exception is UserAlreadyExistsException) {
            setState(() {
              _isVisible = true;
              _errorText = 'Username already exists.';
            });
          } else if (state.exception is GenericAuthException) {
            setState(() {
              _isVisible = true;
              _errorText = 'An error occured.Please try again later';
            });
          } else {
            setState(() {
              //Clear any error on the screen if available
              _isVisible = false;
            });
          }
        }
        if (state is AuthStateRegistrationSuccessful) {
          logger.d('In successful state');
          final shouldLogin = await showRegistrationSuccessDialog(context);
          if (shouldLogin) {
            // ignore: use_build_context_synchronously
            context.read<AuthBloc>().add(
                  const AuthEventShouldLogin(),
                );
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
                  'Create an account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: 55,
                ),
                TextField(
                  decoration: InputDecoration(
                      errorText: _usernameErrorTextValue.isEmpty
                          ? null
                          : _usernameErrorTextValue,
                      border: const OutlineInputBorder(),
                      labelText: 'Username'),
                  controller: _username,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      errorText: _passwordErrorTextValue.isEmpty
                          ? null
                          : _passwordErrorTextValue,
                      border: const OutlineInputBorder(),
                      labelText: 'Password'),
                  controller: _password,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      errorText: _confirmPasswordErrorTextValue.isEmpty
                          ? null
                          : _confirmPasswordErrorTextValue,
                      border: const OutlineInputBorder(),
                      labelText: 'Confirm Password'),
                  controller: _confirmPassword,
                ),
                const SizedBox(
                  height: 20,
                ),
                FilledButton(
                  onPressed: () {
                    _register(SQLiteAuthProvider());
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Sign Up'),
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
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: goToLoginPage,
                    child: const Text('Go to Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register(AuthProvider authProvider) async {
    //Clear any databse error message on the screen
    setState(() {
      _isVisible = false;
    });
    //initialize variables
    final username = _username.text;
    final password = _password.text;
    final confirmPassword = _confirmPassword.text;
    final usernameValidationText =
        _userService.getUsernameValidationText(username);
    final passwordValidationText =
        _userService.getPasswordValidationText(password);
    // Validate email and password fields
    logger.d("user val is $usernameValidationText");
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
    if (password != confirmPassword) {
      setState(() {
        _confirmPasswordErrorTextValue = "Passwords don't match";
      });
      return;
    }
    _confirmPasswordErrorTextValue = '';
    //Read authbloc from build context(Login)
    context.read<AuthBloc>().add(
          AuthEventRegister(username, password, authProvider),
        );
  }

  void goToLoginPage() {
    context.read<AuthBloc>().add(
          const AuthEventShouldLogin(),
        );
  }
}
