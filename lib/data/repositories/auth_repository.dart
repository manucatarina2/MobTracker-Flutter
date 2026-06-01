import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/user_model.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      print('1. Iniciando cadastro para: $email');
      
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      
      print('2. Resposta do signUp: ${response.user?.id}');
      
      if (response.user != null) {
        print('3. Usuário criado com ID: ${response.user!.id}');
        
        // Aguardar trigger criar o perfil
        await Future.delayed(const Duration(seconds: 2));
        print('4. Aguardou trigger');
        
        // Tentar fazer login automaticamente
        final loginResponse = await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        
        print('5. Login após cadastro: ${loginResponse.user?.id}');
        
        if (loginResponse.user != null) {
          final profileData = await _supabase
              .from('profiles')
              .select()
              .eq('id', loginResponse.user!.id)
              .maybeSingle();
          
          print('6. Perfil encontrado: $profileData');
          
          if (profileData != null) {
            return UserModel.fromJson(profileData);
          } else {
            print('6b. Perfil não encontrado, criando manualmente...');
            // Criar perfil manualmente
            final newUser = UserModel(
              id: loginResponse.user!.id,
              fullName: fullName,
              email: email,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            await _supabase.from('profiles').insert(newUser.toJson());
            print('6c. Perfil criado manualmente');
            return newUser;
          }
        }
      }
      print('7. Falha no cadastro - retornando null');
      return null;
    } catch (e) {
      print('ERRO no cadastro: $e');
      return null;
    }
  }
  
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('1. Iniciando login para: $email');
      
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      print('2. Resposta do login: ${response.user?.id}');
      
      if (response.user != null) {
        print('3. Usuário logado com ID: ${response.user!.id}');
        
        final profileData = await _supabase
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();
        
        print('4. Perfil encontrado: $profileData');
        
        if (profileData != null) {
          return UserModel.fromJson(profileData);
        } else {
          print('4b. Perfil não encontrado, criando manualmente...');
          // Criar perfil manualmente
          final newUser = UserModel(
            id: response.user!.id,
            fullName: response.user!.userMetadata?['full_name'] ?? 'Usuário',
            email: email,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await _supabase.from('profiles').insert(newUser.toJson());
          print('4c. Perfil criado manualmente');
          return newUser;
        }
      }
      print('5. Falha no login - retornando null');
      return null;
    } catch (e) {
      print('ERRO no login: $e');
      return null;
    }
  }
  
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    print('Usuário deslogado');
  }
  
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
    print('Email de recuperação enviado para: $email');
  }
  
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }
}