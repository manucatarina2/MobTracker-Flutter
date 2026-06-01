class AppConstants {
  static const appName = 'MobTracker';
  static const appVersion = '1.0.0';
  
  // SUPABASE - SUAS CREDENCIAIS
  static const supabaseUrl = 'https://urvtecnqzmsenrjlmvld.supabase.co';
  static const supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVydnRlY25xem1zZW5yamxtdmxkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAyNjQ4NDIsImV4cCI6MjA5NTg0MDg0Mn0.p9P-b-S-CtzxWSQdK_FAmnrmj4Xg65PPpHOl03oXODo';
  
  // SharedPreferences Keys
  static const prefUser = 'user';
  static const prefOnboardingCompleted = 'onboarding_completed';
  static const prefThemeMode = 'theme_mode';
  static const prefUserId = 'user_id';
  
  // Pagination
  static const defaultPageSize = 20;
  static const maxPageSize = 50;
  
  // Timeouts
  static const connectionTimeout = Duration(seconds: 30);
  static const sendTimeout = Duration(seconds: 30);
  static const receiveTimeout = Duration(seconds: 30);
  
  // Points System
  static const pointsCreateReport = 10;
  static const pointsReceiveConfirmation = 5;
  static const pointsReceiveLike = 2;
  static const pointsCreateAlert = 15;
  static const pointsComment = 1;
  static const pointsConfirmReport = 1;
  
  // Levels
  static const levelIniciante = 'Iniciante';
  static const levelColaborador = 'Colaborador';
  static const levelFiscalizador = 'Fiscalizador';
  static const levelEspecialista = 'Especialista';
  static const levelGuardiao = 'Guardião da Mobilidade';
  
  static const pointsIniciante = 0;
  static const pointsColaborador = 100;
  static const pointsFiscalizador = 500;
  static const pointsEspecialista = 1000;
  static const pointsGuardiao = 2000;
  
  // Report situations
  static const situations = [
    'Atrasado',
    'Lotado',
    'Quebrado',
    'Não passou',
    'Acidente',
    'Trânsito',
    'Parada vandalizada',
    'Outro'
  ];
  
  // Alert types
  static const alertTypes = [
    'Atraso',
    'Acidente',
    'Interdição',
    'Protesto',
    'Trânsito intenso',
    'Superlotação'
  ];
}