import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ekranlar/splash_ekrani.dart';
import 'sabitler/degerler.dart';
import 'sabitler/renkler.dart';
import 'saglayicilar/ilan_saglayici.dart';
import 'saglayicilar/kimlik_saglayici.dart';
import 'saglayicilar/teklif_saglayici.dart';

void main() {
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
        theme: _temaOlustur(),
        home: const SplashEkrani(),
      ),
    );
  }

  ThemeData _temaOlustur() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Renkler.anaRenk,
      primary: Renkler.anaRenk,
      secondary: Renkler.vurguRenk,
      surface: Renkler.kartArkaplan,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Renkler.arkaplan,
      dividerColor: Renkler.sinir,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontSize: 29,
          fontWeight: FontWeight.w800,
          color: Renkler.metin,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Renkler.metin,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Renkler.metin,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Renkler.metin,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          height: 1.45,
          color: Renkler.metin,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: Renkler.metin,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          height: 1.4,
          color: Renkler.ikinciMetin,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Renkler.metin,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: Renkler.metin,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Renkler.anaRenk,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(Degerler.formAlanYuksekligi),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Degerler.normalRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Renkler.anaRenk,
          side: const BorderSide(color: Renkler.sinir),
          minimumSize: const Size.fromHeight(Degerler.formAlanYuksekligi),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Degerler.normalRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Renkler.katman,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Degerler.normalBosluk,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Degerler.normalRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Degerler.normalRadius),
          borderSide: const BorderSide(color: Renkler.sinir),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Degerler.normalRadius),
          borderSide: const BorderSide(color: Renkler.anaRenk, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Degerler.normalRadius),
          borderSide: const BorderSide(color: Renkler.hataRenk),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Degerler.normalRadius),
          borderSide: const BorderSide(color: Renkler.hataRenk, width: 1.4),
        ),
        hintStyle: const TextStyle(color: Renkler.ikinciMetin),
        labelStyle: const TextStyle(color: Renkler.ikinciMetin),
        prefixIconColor: Renkler.ikinciMetin,
        suffixIconColor: Renkler.ikinciMetin,
      ),
      cardTheme: CardThemeData(
        color: Renkler.kartArkaplan,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Degerler.normalRadius),
          side: const BorderSide(color: Renkler.sinir),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Renkler.kartArkaplan,
        indicatorColor: Renkler.yumusakMavi,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? Renkler.anaRenkKoyu
                : Renkler.ikinciMetin,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 22,
            color: states.contains(WidgetState.selected)
                ? Renkler.anaRenk
                : Renkler.ikinciMetin,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Renkler.geceMavisi,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Degerler.kucukRadius),
        ),
      ),
    );
  }
}
