//This acts as the output for the Auth bloc
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../auth_user.dart';

@immutable
abstract class AuthState {
  final AuthUser? user;
  const AuthState({this.user});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized() : super();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser authUser;
  const AuthStateLoggedIn({
    required this.authUser,
  }) : super(user: authUser);
}

class AuthStateVerification extends AuthState {
  const AuthStateVerification() : super();
}

//To produce various mutations of this state
//(e.g isLoading=false/true and null exception), we use an equatable
class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
  }) : super();

  @override
  List<Object?> get props => [exception];
}

class AuthStateLoggingIn extends AuthState {
  final Exception? exception;
  const AuthStateLoggingIn({
    required this.exception,
  }) : super();
}

class AuthStateRegistering extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
  }) : super();

  @override
  List<Object?> get props => [exception];
}

class AuthStateRegistrationSuccessful extends AuthState {
  final Exception? exception;
  const AuthStateRegistrationSuccessful({
    required this.exception,
  }) : super();
}
