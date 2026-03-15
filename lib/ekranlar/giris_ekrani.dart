import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gezinme/ana_gezinme.dart';
import '../sabitler/degerler.dart';
import '../sabitler/renkler.dart';
import '../saglayicilar/kimlik_saglayici.dart';
import 'kayit_ekrani.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final _formAnahtari = GlobalKey<FormState>();
  final _epostaKontrol = TextEditingController();
  final _sifreKontrol = TextEditingController();

  bool _sifreGizli = true;
  bool _yukleniyor = false;

  @override
  void dispose() {
    _epostaKontrol.dispose();
    _sifreKontrol.dispose();
    super.dispose();
  }

  Future<void> _girisYap() async {
    if (!_formAnahtari.currentState!.validate()) {
      return;
    }

    setState(() => _yukleniyor = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    final basarili = context.read<KimlikSaglayici>().girisYap(
          _epostaKontrol.text.trim(),
          _sifreKontrol.text,
        );

    setState(() => _yukleniyor = false);

    if (basarili) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AnaGezinme()),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('E-posta veya sifre hatali.'),
        backgroundColor: Renkler.hataRenk,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Renkler.yumusakMavi, Renkler.arkaplan],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -40,
              right: -24,
              child: _ArkaPlanLeke(
                boyut: 180,
                renk: Renkler.yumusakTuruncu,
              ),
            ),
            const Positioned(
              top: 180,
              left: -36,
              child: _ArkaPlanLeke(
                boyut: 150,
                renk: Renkler.yumusakMor,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    const _UstAlan(
                      baslik: 'Takas icin hazirsan baslayalim',
                      aciklama:
                          'Ilanlari kesfet, filtrele ve uygun urune dakikalar icinde teklif gonder.',
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Renkler.kartArkaplan,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Renkler.sinir),
                        boxShadow: const [
                          BoxShadow(
                            color: Renkler.golge,
                            blurRadius: 26,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formAnahtari,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hesabina giris yap',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tum ilanlar, tekliflerin ve profil bilgilerin burada seni bekliyor.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Renkler.ikinciMetin,
                                  ),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _epostaKontrol,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'E-posta',
                                hintText: 'ornek@mail.com',
                                prefixIcon: Icon(Icons.mail_outline_rounded),
                              ),
                              validator: (deger) {
                                if (deger == null || deger.trim().isEmpty) {
                                  return 'E-posta zorunlu.';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(deger.trim())) {
                                  return 'Gecerli bir e-posta gir.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _sifreKontrol,
                              obscureText: _sifreGizli,
                              decoration: InputDecoration(
                                labelText: 'Sifre',
                                hintText: 'En az 6 karakter',
                                prefixIcon:
                                    const Icon(Icons.lock_outline_rounded),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _sifreGizli = !_sifreGizli;
                                    });
                                  },
                                  icon: Icon(
                                    _sifreGizli
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: (deger) {
                                if (deger == null || deger.isEmpty) {
                                  return 'Sifre zorunlu.';
                                }
                                if (deger.length < 6) {
                                  return 'Sifre en az 6 karakter olmali.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _yukleniyor ? null : _girisYap,
                                child: _yukleniyor
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Giris Yap'),
                              ),
                            ),
                            const SizedBox(height: 18),
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
                                  Row(
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.key_rounded,
                                          color: Renkler.anaRenk,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Demo hesap',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'E-posta: ahmet@test.com',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Sifre: 123456',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hesabin yok mu?',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Renkler.ikinciMetin,
                                  ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const KayitEkrani()),
                            );
                          },
                          child: const Text('Kayit ol'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UstAlan extends StatelessWidget {
  const _UstAlan({
    required this.baslik,
    required this.aciklama,
  });

  final String baslik;
  final String aciklama;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Renkler.anaRenk, Renkler.anaRenkKoyu],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Renkler.golge,
                blurRadius: 22,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.swap_horizontal_circle_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          baslik,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 31,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          aciklama,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Renkler.ikinciMetin,
              ),
        ),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MiniBilgiChip(
              ikon: Icons.search_rounded,
              etiket: 'Akilli arama',
              renk: Renkler.yumusakMavi,
            ),
            _MiniBilgiChip(
              ikon: Icons.category_outlined,
              etiket: 'Temiz kategoriler',
              renk: Renkler.yumusakYesil,
            ),
            _MiniBilgiChip(
              ikon: Icons.chat_bubble_outline_rounded,
              etiket: 'Kolay teklif',
              renk: Renkler.yumusakTuruncu,
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniBilgiChip extends StatelessWidget {
  const _MiniBilgiChip({
    required this.ikon,
    required this.etiket,
    required this.renk,
  });

  final IconData ikon;
  final String etiket;
  final Color renk;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: renk,
        borderRadius: BorderRadius.circular(Degerler.buyukRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 15, color: Renkler.metin),
          const SizedBox(width: 6),
          Text(
            etiket,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Renkler.metin,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _ArkaPlanLeke extends StatelessWidget {
  const _ArkaPlanLeke({
    required this.boyut,
    required this.renk,
  });

  final double boyut;
  final Color renk;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: boyut,
        height: boyut,
        decoration: BoxDecoration(
          color: renk,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
