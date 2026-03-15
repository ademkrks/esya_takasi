import 'package:flutter/material.dart';

import '../sabitler/renkler.dart';
import 'giris_ekrani.dart';

class SplashEkrani extends StatefulWidget {
  const SplashEkrani({super.key});

  @override
  State<SplashEkrani> createState() => _SplashEkraniState();
}

class _SplashEkraniState extends State<SplashEkrani> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const GirisEkrani()),
      );
    });
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
        child: Stack(
          children: [
            Positioned(
              top: -70,
              left: -30,
              child: _isikLekesi(
                boyut: 210,
                renk: Colors.white.withValues(alpha: 0.11),
              ),
            ),
            Positioned(
              right: -60,
              bottom: 90,
              child: _isikLekesi(
                boyut: 230,
                renk: Renkler.vurguRenk.withValues(alpha: 0.16),
              ),
            ),
            SafeArea(
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
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: const Icon(
                        Icons.swap_horizontal_circle_rounded,
                        size: 58,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Esya Takas',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kampus icin hizli, temiz ve dogrudan takas deneyimi.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.84),
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _OzellikChip(
                          ikon: Icons.bolt_rounded,
                          etiket: 'Hizli eslesme',
                        ),
                        _OzellikChip(
                          ikon: Icons.shield_outlined,
                          etiket: 'Guvenli akis',
                        ),
                        _OzellikChip(
                          ikon: Icons.category_outlined,
                          etiket: 'Net kategoriler',
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.7,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Hazirlaniyor',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _isikLekesi({required double boyut, required Color renk}) {
    return Container(
      width: boyut,
      height: boyut,
      decoration: BoxDecoration(
        color: renk,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _OzellikChip extends StatelessWidget {
  const _OzellikChip({
    required this.ikon,
    required this.etiket,
  });

  final IconData ikon;
  final String etiket;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            etiket,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
