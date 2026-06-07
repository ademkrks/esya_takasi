enum UrunDurumu { yeni, azKullanilmis, iyi, kotu }

extension UrunDurumuEtiket on UrunDurumu {
  String get etiket {
    switch (this) {
      case UrunDurumu.yeni: return 'Yeni';
      case UrunDurumu.azKullanilmis: return 'Az Kullanilmis';
      case UrunDurumu.iyi: return 'Iyi';
      case UrunDurumu.kotu: return 'Kotu';
    }
  }
}
