// ürünün fiziksel durumu için enum
// kullanıcı ilan eklerken bunlardan birini seçecek
enum UrunDurumu { yeni, azKullanilmis, iyi, kotu }

// Türkçe gösterim için extension
extension UrunDurumuEtiket on UrunDurumu {
  String get etiket {
    switch (this) {
      case UrunDurumu.yeni: return 'Yeni';
      case UrunDurumu.azKullanilmis: return 'Az Kullanilmis';
      case UrunDurumu.iyi: return 'Iyi';
      case UrunDurumu.kotu: return 'Kotu';  // kötü olan ürün de takas edilebilir, fiyatı düşük olur
    }
  }
}
