import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'sabitler/renkler.dart';
import 'saglayicilar/kimlik_saglayici.dart';
import 'saglayicilar/ilan_saglayici.dart';
import 'saglayicilar/teklif_saglayici.dart';
import 'ekranlar/splash_ekrani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EsyaTakasUygulamasi());
}

class EsyaTakasUygulamasi extends StatelessWidget {
  const EsyaTakasUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KimlikSaglayici()),
        ChangeNotifierProvider(create: (_) => IlanSaglayici()),
        ChangeNotifierProvider(create: (_) => TeklifSaglayici()),
      ],
      child: MaterialApp(
        title: 'Esya Takas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Renkler.anaRenk,
            primary: Renkler.anaRenk,
          ),
          scaffoldBackgroundColor: Renkler.arkaplan,
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
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Renkler.anaRenk,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Renkler.katman,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Renkler.sinir),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Renkler.anaRenk),
            ),
          ),
        ),
        home: const SplashEkrani(),
      ),
    );
  }
}
