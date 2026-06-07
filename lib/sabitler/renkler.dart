import 'package:flutter/material.dart';

// bütün renkleri burada topladık, dağınık olmasın diye
// normalde her yere Color(0xFF...) yazmak çok saçma, bu daha mantıklı
class Renkler {
  // ana mavi renk, buton ve vurgu yerlerde kullanıyoruz
  static const Color anaRenk = Color(0xFF3D7FEF);
  // biraz daha koyu hali, gradient yaparken lazım oluyor
  static const Color anaRenkKoyu = Color(0xFF2558D9);
  // turuncu vurgu rengi, teklif gibi önemli butonlarda kullanıyoruz
  static const Color vurguRenk = Color(0xFFFF7A45);

  // arka plan rengi, hafif gri bir ton
  static const Color arkaplan = Color(0xFFF3F6FB);
  // kart arka planı, beyaz
  static const Color kartArkaplan = Color(0xFFFFFFFF);
  // input alanlarının içi için hafif mavi
  static const Color katman = Color(0xFFEAF0FB);
  // biraz daha koyu katman
  static const Color katmanKoyu = Color(0xFFD8E4FA);
  // koyu lacivert ton, bazı gradientlerde kullandık
  static const Color geceMavisi = Color(0xFF202B45);

  // yeşil - başarı mesajları için
  static const Color basariRenk = Color(0xFF2E9B5D);
  // kırmızı - hata mesajları için
  static const Color hataRenk = Color(0xFFE05252);
  // sarı/turuncu - bekliyor durumu için
  static const Color beklemdeRenk = Color(0xFFF1A63B);

  // ana metin rengi, koyu lacivert
  static const Color metin = Color(0xFF182033);
  // ikincil metin rengi, açık gri - açıklamalar için kullanıyoruz
  static const Color ikinciMetin = Color(0xFF6A748B);
  // çizgi ve border rengi
  static const Color sinir = Color(0xFFDCE4F2);
  // gölge rengi, çok transparan yapıyoruz ki abartılı görünmesin
  static const Color golge = Color(0x14182133);

  // hafif pastel renkler, kart arka planlarında kullandık
  static const Color yumusakMavi = Color(0xFFE7F0FF);
  static const Color yumusakTuruncu = Color(0xFFFFE7DB);
  static const Color yumusakYesil = Color(0xFFE5F7ED);
  static const Color yumusakMor = Color(0xFFF0E9FF);
}
