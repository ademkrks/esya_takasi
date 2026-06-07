// firestore'dan veri okumak için bu paketi import ediyoruz
import 'package:cloud_firestore/cloud_firestore.dart';

// kullanıcı verilerini temsil eden model sınıfı
// firebase'den gelen veriyi dart nesnesine çeviriyoruz burada
class Kullanici {
  String id;       // firebase'in atadığı uid
  String adSoyad;  // kullanıcının adı soyadı
  String eposta;   // giriş için kullanılan eposta
  String? profilFoto;  // nullable, herkesin fotoğrafı olmayabilir

  Kullanici({
    required this.id,
    required this.adSoyad,
    required this.eposta,
    this.profilFoto,  // isteğe bağlı
  });

  // firebase document'ından Kullanici nesnesi oluşturuyoruz
  // factory constructor kullandık, dart'ta böyle yapılıyor
  factory Kullanici.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Kullanici(
      id: doc.id,  // id'yi document'dan alıyoruz, map'te yok
      adSoyad: data['adSoyad'] ?? '',  // null gelirse boş string veriyoruz
      eposta: data['eposta'] ?? '',
      profilFoto: data['profilFoto'],  // null gelebilir, sorun değil
    );
  }

  // Kullanici nesnesini firebase'e yazmak için Map'e çeviriyoruz
  // id'yi koymuyoruz çünkü document id olarak zaten var
  Map<String, dynamic> toMap() {
    return {
      'adSoyad': adSoyad,
      'eposta': eposta,
      'profilFoto': profilFoto,
    };
  }
}
