// her yerde kullandığımız sabit sayıları burada topladık
// magic number yazmak çok kötü alışkanlık dedi hocamız, ondan
class Degerler {
  // boşluk değerleri - padding margin için kullanıyoruz
  static const double kucukBosluk = 8.0;
  static const double normalBosluk = 16.0;  // en çok bunu kullanıyoruz
  static const double buyukBosluk = 24.0;
  static const double cokBuyukBosluk = 32.0;  // sayfanın altına koyuyoruz genelde

  // köşe yuvarlaklıkları
  static const double kucukRadius = 8.0;
  static const double normalRadius = 12.0;
  static const double buyukRadius = 20.0;  // kartlarda kullanıyoruz

  // kart gölgesi
  static const double kartGolge = 2.0;
  // kart içindeki görsel alanının yüksekliği
  static const double kartGorselYuksekligi = 180.0;
  // form alanlarının yüksekliği, hepsini eşit yapmak için
  static const double formAlanYuksekligi = 52.0;
  // ikon boyutu
  static const double ikonBoyu = 24.0;
}
