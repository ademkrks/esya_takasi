// flutter ve firebase paketlerini import ediyoruz, bunlar olmadan uygulama calismiyor zaten
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
// kendi yazdığımız dosyaları da ekliyoruz
import 'sabitler/renkler.dart';
import 'saglayicilar/kimlik_saglayici.dart';
import 'saglayicilar/ilan_saglayici.dart';
import 'saglayicilar/teklif_saglayici.dart';
import 'ekranlar/splash_ekrani.dart';

// uygulama buradan basliyor, async yapmak zorundayiz cunku firebase beklemek istiyor
void main() async {
  // flutter'ı hazır hale getiriyoruz, bunu yazmadan firebase patlıyor
  WidgetsFlutterBinding.ensureInitialized();
  // firebase'i baslatiyoruz, bu olmadan hicbir sey calismaz
  await Firebase.initializeApp();
  // asıl widget'ı calistiriyoruz
  runApp(const EsyaTakasUygulamasi());
}

// uygulamanın ana widget'ı, StatelessWidget yaptık çünkü state tutmaya gerek yok burada
class EsyaTakasUygulamasi extends StatelessWidget {
  const EsyaTakasUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider ile tüm saglayicilari uygulamaya tanıtıyoruz
    // boyle yapmazsak ekranlar arası veri paylasamıyoruz
    return MultiProvider(
      providers: [
        // kullanicinin giris cikis bilgilerini tutan saglayici
        ChangeNotifierProvider(create: (_) => KimlikSaglayici()),
        // ilanlari tutan saglayici
        ChangeNotifierProvider(create: (_) => IlanSaglayici()),
        // teklifleri tutan saglayici
        ChangeNotifierProvider(create: (_) => TeklifSaglayici()),
      ],
      child: MaterialApp(
        title: 'Esya Takas',
        // debug yazısını kaldırıyoruz, sunum yaparken çok çirkin görünüyor
        debugShowCheckedModeBanner: false,
        // tema ayarları, renkleri ve genel görünümü buradan yonetiyoruz
        theme: ThemeData(
          // material 3 kullanıyoruz, daha modern görünüyor
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Renkler.anaRenk,
            primary: Renkler.anaRenk,
          ),
          // arka plan rengi
          scaffoldBackgroundColor: Renkler.arkaplan,
          // appbar teması, transparent yapiyoruz ki daha şık gorunsun
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Renkler.metin,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Renkler.metin,
            ),
          ),
          // buton teması, her yerde aynı görünsün diye buradan ayarlıyoruz
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Renkler.anaRenk,
              foregroundColor: Colors.white,
              // tam genislik buton olsun
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // form alanı teması
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Renkler.katman,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Renkler.sinir),
            ),
            // tiklayinca ana renge donuyor
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Renkler.anaRenk),
            ),
          ),
        ),
        // uygulama açılınca ilk splash ekranı gösteriyoruz
        home: const SplashEkrani(),
      ),
    );
  }
}
