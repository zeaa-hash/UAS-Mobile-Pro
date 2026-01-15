import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:navigator_5d/beranda.dart';
import 'package:navigator_5d/profil.dart';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      /// 🔑 LOGIN SEBAGAI HALAMAN AWAL
      home: const LoginPage(),
    );
  }
}

class MainNavbar extends StatelessWidget {
  const MainNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingNavBar(
      resizeToAvoidBottomInset: false,
      color: Colors.blue.shade600,
      selectedIconColor: Colors.redAccent,
      hapticFeedback: true,
      horizontalPadding: 20,
      items: [
        FloatingNavBarItem(
          iconData: Icons.phone,
          title: 'Telepon',
          page: HomePage(),
        ),
        FloatingNavBarItem(
          iconData: Icons.message,
          title: 'Pesan',
          page: Halaman_Utama(),
        ),
        FloatingNavBarItem(
          iconData: Icons.wallet,
          title: 'Saldo',
          page: HomePage(),
        ),
        FloatingNavBarItem(
          iconData: Icons.account_circle,
          title: 'Account',
          page: Halaman_Profil(),
        ),
      ],
    );
  }
}

/* =========================
   HOME PAGE
========================= */
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade400,
              Colors.blue.shade800,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(20),
            width: _active ? 340 : 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/upgris.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Text(
                  "Welcome to The Form",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Halaman_Utama(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.touch_app),
                  label: const Text("Interact"),
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
