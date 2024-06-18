import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class RegisterEvent extends AuthEvent {
  final String username;

  const RegisterEvent(this.username);
}

class LoginEvent extends AuthEvent {
  final String username;

  const LoginEvent(this.username);
}

class CheckAuthEvent extends AuthEvent {}

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class Authenticated extends AuthState {
  final String username;

  const Authenticated(this.username);
}

class Unauthenticated extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<CheckAuthEvent>(_onCheckAuth);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', event.username);
    emit(Authenticated(event.username));
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    if (savedUsername == event.username) {
      emit(Authenticated(event.username));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    if (savedUsername != null) {
      emit(Authenticated(savedUsername));
    } else {
      emit(Unauthenticated());
    }
  }
}
