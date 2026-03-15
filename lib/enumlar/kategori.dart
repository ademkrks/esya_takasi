// İlanların ait olduğu kategorileri belirten enum
enum Kategori {
  elektronik,
  giyim,
  kitap,
  spor,
  evEsyasi,
  diger,
}

// Kullanıcı arayüzünde gösterilecek etiket metinleri
extension KategoriEtiket on Kategori {
  String get etiket {
    switch (this) {
      case Kategori.elektronik:
        return 'Elektronik';
      case Kategori.giyim:
        return 'Giyim';
      case Kategori.kitap:
        return 'Kitap';
      case Kategori.spor:
        return 'Spor';
      case Kategori.evEsyasi:
        return 'Ev Eşyası';
      case Kategori.diger:
        return 'Diğer';
    }
  }
}
