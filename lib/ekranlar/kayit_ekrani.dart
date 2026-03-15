import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gezinme/ana_gezinme.dart';
import '../sabitler/degerler.dart';
import '../sabitler/renkler.dart';
import '../saglayicilar/kimlik_saglayici.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  final _formAnahtari = GlobalKey<FormState>();
  final _adSoyadKontrol = TextEditingController();
  final _epostaKontrol = TextEditingController();
  final _sifreKontrol = TextEditingController();

  bool _sifreGizli = true;
  bool _yukleniyor = false;

  @override
  void dispose() {
    _adSoyadKontrol.dispose();
    _epostaKontrol.dispose();
    _sifreKontrol.dispose();
    super.dispose();
  }

  Future<void> _kayitOl() async {
    if (!_formAnahtari.currentState!.validate()) {
      return;
    }

    setState(() => _yukleniyor = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    final basarili = context.read<KimlikSaglayici>().kayitOl(
          _adSoyadKontrol.text.trim(),
          _epostaKontrol.text.trim(),
          _sifreKontrol.text,
        );

    setState(() => _yukleniyor = false);

    if (basarili) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AnaGezinme()),
        (route) => false,
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bu e-posta zaten kullaniliyor.'),
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
            colors: [Renkler.yumusakTuruncu, Renkler.arkaplan],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: 110,
              right: -46,
              child: _ArkaPlanLeke(
                boyut: 170,
                renk: Renkler.yumusakMavi,
              ),
            ),
            const Positioned(
              bottom: 40,
              left: -40,
              child: _ArkaPlanLeke(
                boyut: 170,
                renk: Renkler.yumusakYesil,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.86),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Renkler.sinir),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Yeni bir hesap olustur',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Profilini ac, ilanlarini ekle ve kampusteki diger ogrencilerle hizlica takas yap.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Renkler.ikinciMetin,
                          ),
                    ),
                    const SizedBox(height: 18),
                    const Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _MiniBilgiChip(
                          ikon: Icons.verified_user_outlined,
                          etiket: 'Kolay kayit',
                          renk: Renkler.yumusakMavi,
                        ),
                        _MiniBilgiChip(
                          ikon: Icons.inventory_2_outlined,
                          etiket: 'Ilanlarini yonet',
                          renk: Renkler.yumusakTuruncu,
                        ),
                        _MiniBilgiChip(
                          ikon: Icons.swap_horiz_rounded,
                          etiket: 'Teklif takibi',
                          renk: Renkler.yumusakYesil,
                        ),
                      ],
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
                              'Hesap bilgileri',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Sadece birkac adim sonra uygulama kullanima hazir.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Renkler.ikinciMetin,
                                  ),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _adSoyadKontrol,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                labelText: 'Ad soyad',
                                hintText: 'Ali Veli',
                                prefixIcon: Icon(Icons.person_outline_rounded),
                              ),
                              validator: (deger) {
                                if (deger == null || deger.trim().isEmpty) {
                                  return 'Ad soyad zorunlu.';
                                }
                                if (deger.trim().length < 3) {
                                  return 'Ad soyad en az 3 karakter olmali.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
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
                                onPressed: _yukleniyor ? null : _kayitOl,
                                child: _yukleniyor
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text('Kayit Ol'),
                              ),
                            ),
                          ],
                        ),
                      ),
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
