import 'package:flutter/material.dart';

import '../sabitler/renkler.dart';

class BosDurumWidget extends StatelessWidget {
  const BosDurumWidget({
    super.key,
    required this.ikon,
    required this.baslik,
    this.aciklama,
  });

  final IconData ikon;
  final String baslik;
  final String? aciklama;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Renkler.kartArkaplan,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Renkler.sinir),
            boxShadow: const [
              BoxShadow(
                color: Renkler.golge,
                blurRadius: 22,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Renkler.yumusakMavi, Renkler.yumusakMor],
                  ),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Icon(
                  ikon,
                  size: 40,
                  color: Renkler.anaRenk,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                baslik,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                textAlign: TextAlign.center,
              ),
              if (aciklama != null) ...[
                const SizedBox(height: 10),
                Text(
                  aciklama!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Renkler.ikinciMetin,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
