import 'package:flutter/material.dart';
import 'renkler.dart';

class MetinStilleri {
  MetinStilleri._();

  static const TextStyle buyukBaslik = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Renkler.metin,
    letterSpacing: 0.2,
  );

  static const TextStyle ortaBaslik = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Renkler.metin,
  );

  static const TextStyle kucukBaslik = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Renkler.metin,
  );

  static const TextStyle govde = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Renkler.metin,
    height: 1.5,
  );

  static const TextStyle ikinciGovde = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: Renkler.ikinciMetin,
    height: 1.4,
  );

  static const TextStyle kucukEtiket = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Renkler.ikinciMetin,
  );

  static const TextStyle buton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Renkler.anaRenk,
  );
}
