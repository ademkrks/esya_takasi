import 'package:flutter/material.dart';
import 'renkler.dart';

// yazı stillerini buraya topladık, her yerde aynı stili kullanmak için
// aslında çok kullanmıyoruz ama düzenli durması için var
class MetinStilleri {
  // private constructor, bu sınıftan nesne oluşturulmasın diye
  // sadece static değerlere erişilecek
  MetinStilleri._();

  // büyük başlık - sayfa başlıklarında kullanılır
  static const TextStyle buyukBaslik = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Renkler.metin,
    letterSpacing: 0.2,  // harfler arası biraz boşluk, daha okunaklı oluyor
  );

  // orta başlık - bölüm başlıkları için
  static const TextStyle ortaBaslik = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Renkler.metin,
  );

  // küçük başlık - kart başlıkları vs için
  static const TextStyle kucukBaslik = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Renkler.metin,
  );

  // normal paragraf metni
  static const TextStyle govde = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Renkler.metin,
    height: 1.5,  // satır yüksekliği, okunması kolay oluyor
  );

  // ikincil paragraf, açıklamalar için
  static const TextStyle ikinciGovde = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: Renkler.ikinciMetin,  // gri renk
    height: 1.4,
  );

  // küçük etiketler için, mesela kategori veya durum
  static const TextStyle kucukEtiket = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: Renkler.ikinciMetin,
  );

  // buton yazısı
  static const TextStyle buton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.2,
  );

  // tıklanabilir link görünümlü metin
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Renkler.anaRenk,  // mavi renk, link gibi görünsün
  );
}
