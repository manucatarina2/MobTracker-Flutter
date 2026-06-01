import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presentation/screens/linhas_screen.dart';

const primaryDark = Color(0xFF0B3D2E);
const primaryGreen = Color(0xFF1F7A5C);
const lightGreen = Color(0xFF39D98A);
const background = Color(0xFFF7F6F3);
const yellow = Color(0xFFF4B400);
const red = Color(0xFFE74C3C);
const green = Color(0xFF2ECC71);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://urvtecnqzmsenrjlmvld.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVydnRlY25xem1zZW5yamxtdmxkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODAyNjQ4NDIsImV4cCI6MjA5NTg0MDg0Mn0.p9P-b-S-CtzxWSQdK_FAmnrmj4Xg65PPpHOl03oXODo',
  );

  runApp(const MobTrackerApp());
}

class MobTrackerApp extends StatelessWidget {
  const MobTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mob Tracker',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: background,
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentPage = 0;

  final pages = [
    {
      "icon": Icons.report_problem_outlined,
      "title": "Relate Problemas",
      "desc": "Informe atrasos, lotação e problemas no transporte."
    },
    {
      "icon": Icons.people_outline,
      "title": "Ajude a Comunidade",
      "desc": "Valide relatos e contribua para uma mobilidade melhor."
    },
    {
      "icon": Icons.card_giftcard,
      "title": "Ganhe Recompensas",
      "desc": "Acumule pontos e desbloqueie benefícios."
    },
    {
      "icon": Icons.analytics_outlined,
      "title": "Transforme a Cidade",
      "desc": "Seus relatos ajudam a melhorar o transporte."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xff0B3D2E), Color(0xff1F7A5C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: pages.length,
                  onPageChanged: (value) => setState(() => currentPage = value),
                  itemBuilder: (context, index) {
                    final item = pages[index];
                    return Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white12,
                              child: Icon(item["icon"] as IconData,
                                  size: 70, color: Colors.white)),
                          const SizedBox(height: 40),
                          Text(item["title"] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),
                          Text(item["desc"] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 16)),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AuthScreen())),
                        child: const Text("Pular",
                            style: TextStyle(color: Colors.white))),
                    Row(
                        children: List.generate(
                            pages.length,
                            (index) => Container(
                                margin: const EdgeInsets.all(4),
                                width: currentPage == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50))))),
                    ElevatedButton(
                      onPressed: () {
                        if (currentPage < pages.length - 1) {
                          controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                        } else {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const AuthScreen()));
                        }
                      },
                      child: Text(currentPage == pages.length - 1
                          ? "Começar"
                          : "Próximo"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> submit() async {
    setState(() => isLoading = true);
    try {
      if (isLogin) {
        await Supabase.instance.client.auth.signInWithPassword(
            email: emailController.text, password: passwordController.text);
        if (mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
      } else {
        if (passwordController.text != confirmPasswordController.text) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("As senhas não coincidem")));
          setState(() => isLoading = false);
          return;
        }
        await Supabase.instance.client.auth.signUp(
            email: emailController.text,
            password: passwordController.text,
            data: {"full_name": nameController.text});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Cadastro realizado! Faça login.")));
          setState(() {
            isLogin = true;
            isLoading = false;
            nameController.clear();
            emailController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
          });
          return;
        }
      }
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('assets/images/home.png', fit: BoxFit.cover)),
          Positioned.fill(
              child: Container(color: Colors.white.withOpacity(0.88))),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: const Color(0xff0B3D2E),
                        borderRadius: BorderRadius.circular(25)),
                    child: const Icon(Icons.directions_bus,
                        size: 55, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text('MOB TRACKER',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Color(0xff0B3D2E))),
                  const SizedBox(height: 8),
                  const Text('Acesse o MobTracker',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff0B3D2E))),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      isLogin
                          ? 'Entre para acompanhar a mobilidade urbana da sua cidade.'
                          : 'Crie sua conta para relatar e acompanhar a mobilidade urbana da sua cidade.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                          height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 6))
                      ],
                    ),
                    child: Column(
                      children: [
                        if (!isLogin) ...[
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Nome',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff0B3D2E)))),
                          const SizedBox(height: 10),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              hintText: 'Seu nome',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('E-mail',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff0B3D2E)))),
                        const SizedBox(height: 10),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            hintText: 'Seu e-mail',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Senha',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff0B3D2E)))),
                        const SizedBox(height: 10),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Crie uma senha',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: const Icon(Icons.visibility_off),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                          ),
                        ),
                        if (!isLogin) ...[
                          const SizedBox(height: 20),
                          const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Confirmar Senha',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff0B3D2E)))),
                          const SizedBox(height: 10),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Repita sua senha',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: const Icon(Icons.visibility_off),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
                            ),
                          ),
                        ],
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0B3D2E),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(isLogin ? 'Entrar' : 'Cadastrar-se',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => setState(() => isLogin = !isLogin),
                          child: RichText(
                            text: TextSpan(
                              text: isLogin
                                  ? 'Não tem conta? '
                                  : 'Já tem conta? ',
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: isLogin ? 'Cadastre-se' : 'Fazer Login',
                                  style: const TextStyle(
                                      color: Color(0xff0B3D2E),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ao continuar, você concorda com nossos Termos de Uso e Política de Privacidade.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11,
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    color: const Color(0xff0B3D2E),
                    child: const Center(
                        child: Text('© 2025 MobTracker',
                            style: TextStyle(color: Colors.white70))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Image.asset("assets/images/home.png", fit: BoxFit.cover),
          ),
          // Gradient Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xCC0B3D2E),
                    Color(0xFF0B3D2E),
                  ],
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 18, right: 18, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "MOB TRACKER",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: const TextSpan(
                                text: 'Mobilidade urbana ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontFamily: 'Roboto'),
                                children: [
                                  TextSpan(
                                    text: 'colaborativa',
                                    style: TextStyle(color: lightGreen),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.notifications_none,
                            color: Colors.white, size: 26),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Stats Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: const [
                        Expanded(
                            child: _StatCard(
                                icon: Icons.directions_bus,
                                value: '9',
                                title: 'Linhas')),
                        SizedBox(width: 10),
                        Expanded(
                            child: _StatCard(
                                icon: Icons.chat_bubble_outline,
                                value: '4',
                                title: 'Relatos')),
                        SizedBox(width: 10),
                        Expanded(
                            child: _StatCard(
                                icon: Icons.card_giftcard,
                                value: '2',
                                title: 'Suas\nRecompensas')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 27),
                  // White Container
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: background,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 27),
                        // Linhas em destaque Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Linhas em destaque",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: primaryDark),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Explore as linhas mais acionadas e comentadas pela comunidade",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LinhasScreen()),
                                  );
                                },
                                child: Container(
                                  width: 95,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: primaryDark,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Ver todas",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500)),
                                      SizedBox(width: 4),
                                      Icon(Icons.chevron_right,
                                          color: Colors.white, size: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Cards das linhas
                        SizedBox(
                          height: 150,
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            scrollDirection: Axis.horizontal,
                            children: [
                              _LineCardHighlight(),
                              const SizedBox(width: 14),
                              const _LineCardSmall(
                                  number: "10",
                                  title: "TERRAS DO VALE",
                                  subtitle: "Centro / Eugênio de Melo",
                                  desc:
                                      "Linha que conecta o Centro ao bairro Eugênio de Melo..."),
                              const SizedBox(width: 14),
                              const _LineCardSmall(
                                  number: "18",
                                  title: "TERMINO DO VALE",
                                  subtitle: "Centro / Terminal",
                                  desc:
                                      "Linha que conecta o bairro Inglaterra..."),
                            ],
                          ),
                        ),
                        const SizedBox(height: 27),
                        // Últimos relatos Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Últimos relatos da comunidade",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: primaryDark),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Veja o que os passageiros estão dizendo",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 95,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: primaryDark,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text("Ver todos",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(width: 4),
                                    Icon(Icons.chevron_right,
                                        color: Colors.white, size: 14),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Relatos Cards
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            children: const [
                              _ReportCard(
                                header: "1 HORA • HOJE ÀS 08:15 • RUA DA INHAÍ",
                                message:
                                    "Ônibus no horário e viagem muito tranquila!",
                                author: "Mariana",
                                type: "positive",
                              ),
                              _ReportCard(
                                header:
                                    "2 HORAS • RUA JOSÉ AMORIM, 1200 — JARDIM DAS ACÁCIAS / VILA VERDE 2 | LINHA 18",
                                message: "Faltou ônibus no horário.",
                                author: "Carlos",
                                type: "negative",
                              ),
                              _ReportCard(
                                header:
                                    "ONTEM ÀS 19:30 • RODOVIÁRIA DE TEÓFILO OTONI",
                                message:
                                    "Motorista educado e atencioso, excelente viagem!",
                                author: "João",
                                type: "neutral",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Card Contribua
                        Container(
                          height: 88,
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F3),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: primaryDark,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.chat_bubble_outline,
                                    color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Contribua com sua experiência",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: primaryDark),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Cada relato ajuda a construir uma mobilidade\nmelhor para todos na nossa região.",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: primaryDark,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Compartilhar relato",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.white, size: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: primaryDark,
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          iconSize: 24,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LinhasScreen()),
              ).then((_) {
                if (mounted) {
                  setState(() {
                    currentIndex = 0;
                  });
                }
              });
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_bus), label: "Linhas"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Pontos"),
            BottomNavigationBarItem(
                icon: Icon(Icons.warning_amber), label: "Alertas"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Usuário"),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String title;

  const _StatCard(
      {required this.icon, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: lightGreen, size: 20),
              const SizedBox(width: 7),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _LineCardHighlight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAE7DF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE67E22),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text("01",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    height: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                      color: yellow.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: yellow, size: 12),
                        const SizedBox(width: 4),
                        const Text("Destaque",
                            style: TextStyle(
                                color: yellow,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              "PADRE MARCELLO / PAULO / FAVORINO X VILA VELHA I / VILA VELHA II / GERMÂNIA",
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Vila Velha I / II / Germânia",
            style: TextStyle(color: Colors.black54, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          const Text(
            "Linha que atende os bairros Padre Marcelo, Paulo, Favorino...",
            style: TextStyle(color: Colors.black38, fontSize: 9),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _LineCardSmall extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final String desc;

  const _LineCardSmall(
      {required this.number,
      required this.title,
      required this.subtitle,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAE7DF), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(number,
                  style: const TextStyle(
                      color: primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.black54, fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: const TextStyle(color: Colors.black38, fontSize: 9),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String header;
  final String message;
  final String author;
  final String type;

  const _ReportCard({
    required this.header,
    required this.message,
    required this.author,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color iconColor;
    IconData iconData;
    Color bgColor;

    switch (type) {
      case 'positive':
        borderColor = lightGreen;
        iconColor = green;
        iconData = Icons.sentiment_satisfied_alt;
        bgColor = Colors.white;
        break;
      case 'negative':
        borderColor = red.withOpacity(0.4);
        iconColor = red;
        iconData = Icons.sentiment_dissatisfied;
        bgColor = red.withOpacity(0.04);
        break;
      case 'neutral':
      default:
        borderColor = yellow.withOpacity(0.4);
        iconColor = yellow;
        iconData = Icons.sentiment_neutral;
        bgColor = yellow.withOpacity(0.04);
        break;
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 78),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  header.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  author,
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
