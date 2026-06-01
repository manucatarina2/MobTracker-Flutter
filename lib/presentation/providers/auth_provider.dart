import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;
  
  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });
  
  AuthState copyWith({
    bool? isLoading,
    UserModel? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  
  AuthNotifier(this._authRepository) : super(const AuthState());
  
  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _authRepository.signIn(email: email, password: password);
      if (user != null) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Email ou senha inválidos');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao fazer login: $e');
      return false;
    }
  }
  
  Future<bool> signUp(String email, String password, String fullName) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await _authRepository.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      if (user != null) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Erro ao criar conta. Tente novamente.');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Erro ao criar conta: $e');
      return false;
    }
  }
  
  Future<void> signOut() async {
    await _authRepository.signOut();
    state = const AuthState();
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}