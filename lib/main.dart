import 'package:flutter/material.dart';
import 'package:tbcare/features/chatbot/chatbot_page.dart';
import 'package:tbcare/features/edukasi/detail_artikel_page.dart';
import 'package:tbcare/features/edukasi/detail_video_page.dart';
import 'package:tbcare/features/edukasi/konten_edukasi_page.dart';
import 'package:tbcare/features/jadwal/jadwal_page.dart';
import 'package:tbcare/features/layanan/layanan_kesehatan_page.dart';
import 'package:tbcare/repositories/profil_repository.dart';
import 'package:tbcare/services/api_services.dart';
import 'package:tbcare/services/notification_service.dart';
import 'core/session/user_session.dart';
import 'features/splash/splash_page.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_routes.dart';
import 'features/auth/login_page.dart';
import 'features/auth/forgot_password_page.dart';
import 'features/auth/register_page.dart';
import 'app/main_navigation.dart';
import 'features/profil/profil_page.dart';
import 'features/edit_profil/edit_profil_page.dart';
import 'features/notifikasi/notifikasi_page.dart';
import 'features/skrining/skrining_page.dart';
import 'features/skrining/hasil_skrining_page.dart';
import 'features/pengaturan/pengaturan_page.dart';
import 'features/pengaturan/ubah_kata_sandi_page.dart';
import 'features/pengaturan/tentang_aplikasi_page.dart';
import 'features/pengaturan/panduan_pengguna_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init();
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _SplashRouter(),
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.forgotPassword: (context) => const ForgotPasswordPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.home: (context) => const MainNavigation(),
        AppRoutes.jadwal: (context) => const JadwalPage(),
        AppRoutes.profil: (context) => const ProfilPage(),
        AppRoutes.layananKesehatan: (context) => const LayananKesehatanPage(),
        AppRoutes.kontenEdukasi: (context) => const KontenEdukasiPage(),
        AppRoutes.detailArtikel: (context) => DetailArtikelPage(
          konten: ModalRoute.of(context)!.settings.arguments as KontenEdukasiModel,
        ),
        AppRoutes.detailVideo: (context) => DetailVideoPage(
          konten: ModalRoute.of(context)!.settings.arguments as KontenEdukasiModel,
        ),
        AppRoutes.chatbot: (context) => const ChatbotPage(),
        AppRoutes.editProfil: (context) => const EditProfilPage(),
        AppRoutes.notifikasi: (context) => const NotifikasiPage(),
        AppRoutes.skrining:      (context) => const SkriningPage(),
        AppRoutes.hasilSkrining: (context) => const HasilSkriningPage(),
        AppRoutes.pengaturan: (context) => const PengaturanPage(),
        AppRoutes.ubahKataSandi: (context) => const UbahKataSandiPage(),
        AppRoutes.tentangAplikasi: (context) => const TentangAplikasiPage(),
        AppRoutes.panduanPengguna: (context) => const PanduanPenggunaPage(),
      },
    );
  }
}

class _SplashRouter extends StatefulWidget {
  const _SplashRouter();

  @override
  State<_SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<_SplashRouter> {
  @override
  void initState() {
    super.initState();
    _cekSession();
  }

  Future<void> _cekSession() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await UserSession.loadToken();

    if (token != null && token.isNotEmpty) {
      UserSession.simpan(
        nama: '',
        email: '',
        telepon: '',
        token: token,
      );

      try {
        await ProfilRepository.getProfile();
      } catch (e) {

        await UserSession.hapusToken();
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
        return;
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } else {

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}