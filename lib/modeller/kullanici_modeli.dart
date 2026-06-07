import 'package:cloud_firestore/cloud_firestore.dart';

class Kullanici {
  String id;
  String adSoyad;
  String eposta;
  String? profilFoto;

  Kullanici({
    required this.id,
    required this.adSoyad,
    required this.eposta,
    this.profilFoto,
  });

  factory Kullanici.fromDoc(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Kullanici(
      id: doc.id,
      adSoyad: data['adSoyad'] ?? '',
      eposta: data['eposta'] ?? '',
      profilFoto: data['profilFoto'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'adSoyad': adSoyad,
      'eposta': eposta,
      'profilFoto': profilFoto,
    };
  }
}
