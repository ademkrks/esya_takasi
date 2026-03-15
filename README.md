# Esya Takas

Esya Takas, ogrencilerin kullanmadiklari esyalari birbirleriyle takas etmesini hedefleyen Flutter tabanli bir mobil uygulama prototipidir. Uygulama su anda mock veri ile calisir; ilan listeleme, filtreleme, teklif gonderme ve profil akislari arayuz seviyesinde hazirdir.

## Ozellikler

- Giris ve kayit ekranlari
- Ana sayfada arama ve kategori filtreleme
- Ilan kartlari ve detay sayfasi
- Yeni ilan ekleme formu
- Gelen ve gonderilen teklifleri goruntuleme
- Teklif kabul etme ve reddetme
- Profil ekrani ve kullaniciya ait ilanlari listeleme
- Mock veri ile demo akisi

## Kullanilan Teknolojiler

- Flutter
- Dart
- Provider
- Intl
- Uuid
- Material 3

## Proje Yapisi

```text
lib/
  ekranlar/        Uygulama ekranlari
  gezinme/         Alt gezinme yapisi
  modeller/        Veri modelleri
  enumlar/         Kategori, urun durumu ve teklif durumu enumlari
  saglayicilar/    Provider tabanli durum yonetimi
  servisler/       Is kurallari ve veri islemleri
  veri/            Mock veri kaynagi
  widgetlar/       Ortak UI bilesenleri
  sabitler/        Renk, bosluk ve tema sabitleri
```

## Demo Hesaplar

Asagidaki hesaplarla uygulamaya giris yapabilirsin:

- `ahmet@test.com` / `123456`
- `fatma@test.com` / `123456`
- `mehmet@test.com` / `123456`

## Kurulum

### Gereksinimler

- Flutter SDK
- Dart SDK
- Android Studio veya Xcode
- Bir emulator ya da fiziksel cihaz

### Bagimliliklari yukle

```bash
flutter pub get
```

## Calistirma

### Genel Flutter komutlari

```bash
flutter run
flutter analyze
```

### Windows icin ozel not

Bu depo su anda Turkce karakter iceren bir klasor yolunda bulunuyor. Android build, Windows ortaminda bu tip yollarda sorun cikarabildigi icin dogrudan `flutter` yerine proje kokundeki `flutterw.bat` kullanilmalidir:

```bat
flutterw.bat run -d emulator-5554
flutterw.bat build apk --debug
flutterw.bat analyze
```

`flutterw.bat`, build sirasinda gecici bir ASCII surucu eslemesi olusturur ve Android araclarini bu yol uzerinden calistirir.

## Uygulama Akisi

1. Kullanici demo hesapla giris yapar veya yeni hesap olusturur.
2. Ana sayfada ilanlari gorur, arama yapar ve kategori secerek filtreleme yapar.
3. Bir ilanin detayina gidip kendi ilanlariyla teklif gonderebilir.
4. Teklifler ekraninda gelen ve gonderilen teklifler takip edilir.
5. Profil ekraninda kullanici kendi ilanlarini gorur.

## Mevcut Durum

- Veri katmani mock veri ile calisir.
- Kalici veritabani veya gercek backend entegrasyonu yoktur.
- Fotograf yukleme alani arayuzde yer tutucu olarak bulunur.
- Android tarafinda siyah ekran problemi icin `TextureView` ve Impeller kapatma ayari kullanilmistir.

## Gelistirme Notlari

- Uygulama `Provider` ile durum yonetir.
- Tema ve renk sistemi `lib/main.dart` ve `lib/sabitler/renkler.dart` icinde tanimlidir.
- Ornek ilanlar ve teklifler `lib/veri/mock_veri.dart` dosyasinda tutulur.

## Kontrol Komutlari

```bash
flutter analyze
flutter test
```

Windows Android akisi icin:

```bat
flutterw.bat analyze
flutterw.bat run -d emulator-5554 --debug --no-resident
```
