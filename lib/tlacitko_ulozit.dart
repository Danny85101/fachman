import 'package:flutter/material.dart';
import 'sklad.dart';
import 'data_formulare.dart'; 

class TlacitkoUlozit extends StatefulWidget {
  // PŘIDÁNO: Připravili jsme místo pro zvonek, který schová pásku
  final VoidCallback? poUlozeni;

  const TlacitkoUlozit({super.key, this.poUlozeni});

  @override
  State<TlacitkoUlozit> createState() => _TlacitkoUlozitState();
}

class _TlacitkoUlozitState extends State<TlacitkoUlozit> {

  // TADY JE TVŮJ ČISTIČ JMÉN
  String _vycistitJmeno(String puvodniJmeno) {
    if (puvodniJmeno.trim().isEmpty) return 'Neznámý';
    String jmeno = puvodniJmeno.toLowerCase().replaceAll(RegExp(r'[,. ]+$'), '').trim();
    List<String> slova = jmeno.split(' ');
    if (slova.length == 2 && slova[0] == slova[1]) {
      jmeno = slova[0];
    }
    return jmeno[0].toUpperCase() + jmeno.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          double vyslednaCena = 0;
          double hodiny = double.tryParse(hodinyController.text) ?? 0;
          double sazba = double.tryParse(sazbaController.text) ?? 0;
          double pevnaCena = double.tryParse(cenaController.text) ?? 0;

          if (hodiny > 0 && sazba > 0) {
            vyslednaCena = hodiny * sazba;
          } else {
            vyslednaCena = pevnaCena;
          }

          bool necoVyplneno = nakupController.text.isNotEmpty || zakaznikController.text.isNotEmpty || vyslednaCena > 0 || hodiny > 0 || prilozenaFotka != null;

          if (necoVyplneno) {
            setState(() {
              String uhlazeneJmeno = _vycistitJmeno(zakaznikController.text);
              
              // ZJISTÍME DNEŠNÍ DATUM
              DateTime ted = DateTime.now();
              String dnesniDatum = '${ted.day}. ${ted.month}. ${ted.year}';

              vsechnyNakupy.add({
                'polozka': nakupController.text.isEmpty ? 'Nezadáno' : (hodiny > 0 ? '${nakupController.text} ($hodiny hod)' : nakupController.text),
                'zakaznik': uhlazeneJmeno, 
                'cena': vyslednaCena,
                'fotka': prilozenaFotka,
                'datum': dnesniDatum, 
              });
              
              ulozDoPameti();
            });

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uloženo do paměti!')));

            // Vyčistíme propisky
            nakupController.clear();
            zakaznikController.clear();
            cenaController.clear();
            hodinyController.clear();
            sazbaController.clear();
            prilozenaFotka = null;

            // PŘIDÁNO: Kouzelný povel, který okamžitě schová klávesnici a zruší blikající kurzor!
            FocusScope.of(context).unfocus();

            // ZAZVONÍME! (Tím řekneme obrazovce, ať pásku po smazání fotky schová)
            if (widget.poUlozeni != null) {
              widget.poUlozeni!();
            }
          }
        },
        child: const Text('ULOŽIT VÝDAJ / PRÁCI', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}