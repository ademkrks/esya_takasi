// şimdilik sadece placeholder, gerçek upload özelliği sonraya kaldı
// TODO: Firebase Storage entegrasyonu yapılacak
class IlanFotografServisi {
  Future<String> fotografYukle({
    required String dosyaYolu,
  }) async {
    // dosya yolu boşsa hata fırlatıyoruz
    if (dosyaYolu.isEmpty) {
      throw ArgumentError('Fotograf yolu bos olamaz.');
    }

    // şu an gerçek yükleme yapmıyor, sadece yolu döndürüyor
    // ileride burası Firebase Storage kodu ile dolacak
    return dosyaYolu;
  }
}
