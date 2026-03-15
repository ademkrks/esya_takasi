// Ürünün fiziksel durumunu belirten enum
enum UrunDurumu {
  yeni,
  azKullanilmis,
  iyi,
  kotu,
}

// Kullanıcı arayüzünde gösterilecek etiket metinleri
extension UrunDurumuEtiket on UrunDurumu {
  String get etiket {
    switch (this) {
      case UrunDurumu.yeni:
        return 'Yeni';
      case UrunDurumu.azKullanilmis:
        return 'Az Kullanılmış';
      case UrunDurumu.iyi:
        return 'İyi';
      case UrunDurumu.kotu:
        return 'Kötü';
    }
  }
}
