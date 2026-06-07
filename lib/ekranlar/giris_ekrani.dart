import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../saglayicilar/kimlik_saglayici.dart';
import '../sabitler/renkler.dart';
import '../gezinme/ana_gezinme.dart';
import 'kayit_ekrani.dart';

// giriş ekranı, email ve şifre ile firebase'e giriş yapıyoruz
class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  // form doğrulama için key, validate() çağırmak için lazım
  final _formAnahtari = GlobalKey<FormState>();
  final _epostaKontrol = TextEditingController();
  final _sifreKontrol = TextEditingController();
  bool _sifreGizli = true;    // göz ikonuna basınca şifreyi gösteriyoruz
  bool _yukleniyor = false;   // buton durumu için

  @override
  void dispose() {
    // controller'ları temizliyoruz, memory leak olmasın
    _epostaKontrol.dispose();
    _sifreKontrol.dispose();
    super.dispose();
  }

  Future<void> _girisYap() async {
    // form geçerli değilse devam etme
    if (!_formAnahtari.currentState!.validate()) return;

    setState(() => _yukleniyor = true);
    // biraz gecikme ekliyoruz, yükleniyor animasyonu görünsün
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    // saglayiciya giriş yap komutu veriyoruz
    var basarili = await context.read<KimlikSaglayici>().girisYap(
      _epostaKontrol.text.trim(),
      _sifreKontrol.text,
    );

    if (!mounted) return;
    setState(() => _yukleniyor = false);

    if (basarili) {
      // başarılıysa ana sayfaya gidiyoruz, geri dönemesin diye pushReplacement kullandık
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AnaGezinme()),
      );
    } else {
      // başarısızsa hata mesajı gösteriyoruz
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-posta veya sifre hatali.'), backgroundColor: Renkler.hataRenk),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // hafif mavi gradient arka plan
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Renkler.yumusakMavi, Renkler.arkaplan],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),

                // logo kutusu
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Renkler.anaRenk, Renkler.anaRenkKoyu],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.swap_horizontal_circle_rounded, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 18),
                // başlık metni
                Text(
                  'Takas icin hazirsan baslayalim',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 31, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(
                  'Ilanlari kesfet, filtrele ve uygun urune dakikalar icinde teklif gonder.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Renkler.ikinciMetin),
                ),
                const SizedBox(height: 24),

                // giriş formu kartı
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Renkler.kartArkaplan,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Renkler.sinir),
                    boxShadow: const [BoxShadow(color: Renkler.golge, blurRadius: 26, offset: Offset(0, 12))],
                  ),
                  child: Form(
                    key: _formAnahtari,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hesabina giris yap',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text('Tum ilanlar, tekliflerin ve profil bilgilerin burada seni bekliyor.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Renkler.ikinciMetin)),
                        const SizedBox(height: 18),

                        // e-posta alanı
                        TextFormField(
                          controller: _epostaKontrol,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-posta',
                            hintText: 'ornek@mail.com',
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'E-posta zorunlu.';
                            if (!v.contains('@')) return 'Gecerli bir e-posta gir.';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // şifre alanı, göz ikonu ile göster/gizle özelliği var
                        TextFormField(
                          controller: _sifreKontrol,
                          obscureText: _sifreGizli,
                          decoration: InputDecoration(
                            labelText: 'Sifre',
                            hintText: 'En az 6 karakter',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _sifreGizli = !_sifreGizli),
                              icon: Icon(_sifreGizli ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Sifre zorunlu.';
                            if (v.length < 6) return 'En az 6 karakter olmali.';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // giriş butonu, yükleniyorsa spinner gösteriyoruz
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _yukleniyor ? null : _girisYap,
                            child: _yukleniyor
                                ? const SizedBox(width: 20, height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Giris Yap'),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // test için demo hesap bilgilerini gösteriyoruz
                        // production'da bunu kaldırmak lazım ama şimdilik pratik
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Renkler.yumusakMavi,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Demo hesap', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                              const SizedBox(height: 8),
                              const Text('E-posta: ahmet@test.com'),
                              const SizedBox(height: 4),
                              const Text('Sifre: 123456'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // kayıt ol linki
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hesabin yok mu?',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Renkler.ikinciMetin)),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const KayitEkrani()));
                      },
                      child: const Text('Kayit ol'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
