import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterdemoapp/constants/routes.dart';
import 'auth/auth_provider.dart';
import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_event.dart';
import 'auth/bloc/auth_state.dart';
import 'auth/sqlite_auth_provider.dart';
import 'constants/colors.dart';
import 'views/already_read_page.dart';
import 'views/favourite_page.dart';
import 'views/homepage.dart';
import 'views/login.dart';
import 'views/reading_list_page.dart';
import 'views/register.dart';

void main() {
  AuthProvider authProvider = SQLiteAuthProvider();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: PRIMARY_COLOR),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    ),
    home: BlocProvider<AuthBloc>(
      // create: (context) =>  AuthBloc(FirebaseAuthProvider()),
      create: (context) => AuthBloc(authProvider),
      child: const MainApp(),
    ),
    routes: {
      favouriteListPageRoute: (context) => const FavouriteListPage(),
      alreadyReadListPageRoute: (context) => const AlreadyReadListPage(),
      readingListPageRoute: (context) => const ReadingListPage(),
    },
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Retrieve authbloc from context
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return HomePage(user: state.authUser);
      } else if (state is AuthStateLoggedOut) {
        return const LoginPage();
      } else if (state is AuthStateRegistering ||
          state is AuthStateRegistrationSuccessful) {
        return const RegisterPage();
      } else {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }
    });
  }
}
