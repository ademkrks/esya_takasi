# Esya Takas

Ogrencilerin kullanmadiklari esyalari birbirleriyle takas etmesini saglayan Flutter uygulamasi. Mock veri ile calisir.

## Demo Hesaplar

- `ahmet@test.com` / `123456`
- `fatma@test.com` / `123456`
- `mehmet@test.com` / `123456`

## Kurulum

```bash
flutter pub get
flutter run
```

## Ozellikler

- Giris / kayit ekranlari
- Ilan listeleme, arama, kategori filtresi
- Ilan detay ve teklif gonderme
- Gelen / gonderilen teklif yonetimi
- Profil ekrani

## Proje Yapisi

```
lib/
  ekranlar/      ekranlar
  widgetlar/     ortak widgetlar
  modeller/      veri modelleri
  saglayicilar/  provider state management
  servisler/     is mantigi
  veri/          mock veriler
  enumlar/       enumlar
  sabitler/      renkler ve sabitler
  gezinme/       alt nav bar
```

> Not: Mock veri kullaniliyor, gercek backend yok.
