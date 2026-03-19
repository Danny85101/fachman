import 'package:share_plus/share_plus.dart';
import 'sklad.dart'; // Saháme si pro data do paměti

// Funkce, která vezme úplně všechno a připraví to jako jeden velký zálohovací soubor
void exportovatVsechnaData() {
  if (vsechnyNakupy.isEmpty) {
    Share.share('Zatím v aplikaci nemáš žádná data k zálohování.');
    return;
  }

  // Hlavička našeho záložního souboru
  String zalohaText = 'ZÁLOHA DAT - DIGITÁLNÍ FACHMAN\n';
  zalohaText += '--------------------------------\n\n';

  // Nejdřív si ty data pro zálohu taky roztřídíme do složek, ať se v tom dá číst
  Map<String, List<Map<String, dynamic>>> slozkyZakazniku = {};
  for (var zaznam in vsechnyNakupy) {
    String jmeno = zaznam['zakaznik'];
    if (!slozkyZakazniku.containsKey(jmeno)) {
      slozkyZakazniku[jmeno] = [];
    }
    slozkyZakazniku[jmeno]!.add(zaznam);
  }

  // A teď to všechno vypíšeme pod sebe
  for (var zakaznik in slozkyZakazniku.keys) {
    zalohaText += 'ZÁKAZNÍK: $zakaznik\n';
    double celkem = 0;
    
    for (var vec in slozkyZakazniku[zakaznik]!) {
      String polozka = vec['polozka'];
      double cena = (vec['cena'] as num).toDouble();
      String datum = vec['datum'] ?? 'Neznámé datum'; // Přidáme i datum, pokud ho tam máme
      
      zalohaText += '- $polozka ($cena Kč) [$datum]\n';
      celkem += cena;
    }
    zalohaText += 'CELKEM ZA ZÁKAZNÍKA: $celkem Kč\n';
    zalohaText += '--------------------------------\n\n';
  }

  // Tady se vyvolá ta chytrá nabídka (Apple/Android)
  Share.share(zalohaText, subject: 'Záloha dat - Digitální Fachman');
}