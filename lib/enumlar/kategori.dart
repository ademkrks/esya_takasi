// ilan kategorilerini enum ile tanımladık
// string yazmak yerine enum kullanmak daha güvenli, typo olmaz
enum Kategori { elektronik, giyim, kitap, spor, evEsyasi, diger }

// extension ile enum'a metod ekliyoruz, dart'ta çok kullanışlı bir özellik
// etiket property'si ile kategorinin Türkçe adını alabiliyoruz
extension KategoriEtiket on Kategori {
  String get etiket {
    switch (this) {
      case Kategori.elektronik: return 'Elektronik';
      case Kategori.giyim: return 'Giyim';
      case Kategori.kitap: return 'Kitap';
      case Kategori.spor: return 'Spor';
      case Kategori.evEsyasi: return 'Ev Esyasi';
      case Kategori.diger: return 'Diger';
    }
  }
}
