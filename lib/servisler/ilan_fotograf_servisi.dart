class IlanFotografServisi {
  Future<String> fotografYukle({
    required String dosyaYolu,
  }) async {
    if (dosyaYolu.isEmpty) {
      throw ArgumentError('Fotograf yolu bos olamaz.');
    }

    return dosyaYolu;
  }
}
