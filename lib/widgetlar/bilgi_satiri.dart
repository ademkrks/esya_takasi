import 'package:flutter/material.dart';

import '../sabitler/renkler.dart';

class BilgiSatiri extends StatelessWidget {
  const BilgiSatiri({
    super.key,
    required this.ikon,
    required this.etiket,
    required this.deger,
  });

  final IconData ikon;
  final String etiket;
  final String deger;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Renkler.arkaplan,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              ikon,
              size: 18,
              color: Renkler.anaRenk,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiket,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Renkler.ikinciMetin,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  deger,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
