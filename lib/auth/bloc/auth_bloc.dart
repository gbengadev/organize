import 'package:bloc/bloc.dart';
import '../../crud/sqlite_user_service.dart';
import '../auth_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    on<AuthEventInitialize>((event, emit) async {
      //await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
        ));
      } else {
        emit(AuthStateLoggedIn(
          authUser: user,
        ));
      }
    });

    //Login
    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
      ));
      final username = event.username;
      final password = event.password;
      final provider = event.provider;
      try {
        final user = await provider.login(
          username: username,
          password: password,
        );
        //Disable loading dialog
        // emit(const AuthStateLoggedOut(
        //   exception: null,
        // ));
        //Login to the app
        emit(AuthStateLoggedIn(
          authUser: user,
        ));
        logger.d('Logged in emitted');
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
        ));
      }
    });

    //Logout
    on<AuthEventLogout>((event, emit) async {
      emit(const AuthStateUninitialized());
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(exception: e));
      }
    });

    //Register
    on<AuthEventRegister>((event, emit) async {
      logger.d('In Register event');
      emit(const AuthStateRegistering(
        exception: null,
      ));
      final username = event.username;
      final password = event.password;
      try {
        await provider.createUser(
          username: username,
          password: password,
        );
        logger.d('yes');

        emit(const AuthStateRegistrationSuccessful(exception: null));
      } on Exception catch (e) {
        logger.d('register exce is $e');
        emit(AuthStateRegistering(
          exception: e,
        ));
      }
    });

    //Should Register
    on<AuthEventShouldRegister>((event, emit) async {
      emit(const AuthStateRegistering(
        exception: null,
      ));
    });

    //Should Register
    on<AuthEventShouldLogin>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
      ));
    });
  }
}
