import 'package:flutter/material.dart';
import 'renkler.dart';

// Uygulama genelinde kullanılan ortak metin stilleri
class MetinStilleri {
  MetinStilleri._();

  // Büyük başlık — ekran başlıkları için
  static const TextStyle buyukBaslik = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Renkler.metin,
    letterSpacing: 0.2,
  );

  // Orta başlık — kart başlıkları ve bölüm başlıkları
  static const TextStyle ortaBaslik = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Renkler.metin,
  );

  // Küçük başlık — etiketler ve alt başlıklar
  static const TextStyle kucukBaslik = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Renkler.metin,
  );

  // Normal gövde metni
  static const TextStyle govde = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Renkler.metin,
    height: 1.5,
  );

  // İkincil/açıklama metni
  static const TextStyle ikinciGovde = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: Renkler.ikinciMetin,
    height: 1.4,
  );

  // Küçük etiket metni (rozet, chip vb.)
  static const TextStyle kucukEtiket = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Renkler.ikinciMetin,
  );

  // Buton metni
  static const TextStyle buton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  // Link / vurgulu metin
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Renkler.anaRenk,
  );
}
