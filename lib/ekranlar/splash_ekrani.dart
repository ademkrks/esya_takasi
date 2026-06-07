import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../saglayicilar/kimlik_saglayici.dart';
import '../sabitler/renkler.dart';
import '../gezinme/ana_gezinme.dart';
import 'giris_ekrani.dart';

class SplashEkrani extends StatefulWidget {
  const SplashEkrani({super.key});

  @override
  State<SplashEkrani> createState() => _SplashEkraniState();
}

class _SplashEkraniState extends State<SplashEkrani> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      var girisYapilmis = context.read<KimlikSaglayici>().girisYapilmis;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => girisYapilmis ? const AnaGezinme() : const GirisEkrani()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Renkler.anaRenk, Renkler.anaRenkKoyu, Renkler.geceMavisi],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 108,
                  height: 108,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  child: const Icon(Icons.swap_horizontal_circle_rounded, size: 58, color: Colors.white),
                ),
                const SizedBox(height: 28),
                Text(
                  'Esya Takas',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(
                  'Ogrenci takasi - hizli ve kolay',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.84)),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.7,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.82)),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Hazirlaniyor...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
