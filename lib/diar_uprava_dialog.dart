import 'package:flutter/material.dart';
import 'chytry_kalendar.dart';
import 'sklad_diar.dart';

class DiarUpravaDialog {
  // Funkce, která okénko vyvolá
  static void ukazat(
    BuildContext context, {
    required Map<String, dynamic> zakazka,
    required String hezkeDatum,
    required VoidCallback poZmene, // Zvonek, kterým cinkneme hlavní obrazovce, ať se překreslí
  }) {
    TextEditingController upravaKdy = TextEditingController(text: hezkeDatum);
    TextEditingController upravaKdo = TextEditingController(text: zakazka['kdo']);
    TextEditingController upravaCo = TextEditingController(text: zakazka['co']);
    bool necoSeZmenilo = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            
            // Kontrola, jestli se něco přepsalo
            void zkontrolujZmenu(String val) {
              bool zmenaTed = upravaKdy.text != hezkeDatum || 
                              upravaKdo.text != zakazka['kdo'] || 
                              upravaCo.text != zakazka['co'];
              if (necoSeZmenilo != zmenaTed) {
                setStateDialog(() { necoSeZmenilo = zmenaTed; });
              }
            }

            return AlertDialog(
              contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              title: const Text('Detail zakázky', style: TextStyle(fontSize: 14, color: Colors.grey)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: upravaKdy,
                      readOnly: true, // Zamezíme psaní, vyskočí kalendář
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                      onTap: () async {
                        await ChytryKalendar.vybratDatum(context, upravaKdy);
                        zkontrolujZmenu(""); 
                      },
                    ),
                    TextField(
                      controller: upravaKdo,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      decoration: const InputDecoration(border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.symmetric(vertical: 5)),
                      onChanged: zkontrolujZmenu,
                    ),
                    const Divider(),
                    TextField(
                      controller: upravaCo,
                      style: const TextStyle(fontSize: 16),
                      maxLines: null, // Dovolí textu růst dolů
                      decoration: const InputDecoration(border: InputBorder.none),
                      onChanged: zkontrolujZmenu,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: const Text('ZAVŘÍT', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))
                ),
                // Zelené tlačítko vyskočí jen po změně
                if (necoSeZmenilo)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      if (upravaKdo.text.isNotEmpty) {
                        // Smažeme starou a uložíme novou zakázku
                        vsechnyZakazky.remove(zakazka);
                        vsechnyZakazky.add({
                          'kdy': upravaKdy.text, 
                          'kdo': upravaKdo.text,
                          'co': upravaCo.text,
                        });
                        ulozDiarDoPameti(); 
                        
                        Navigator.pop(context); // Zavřeme okno
                        poZmene(); // Cinkneme obrazovce, ať ukáže nové údaje
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Zakázka upravena!')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Zákazník nesmí být prázdný!')));
                      }
                    },
                    child: const Text('ULOŽIT ZMĚNY', style: TextStyle(color: Colors.white)),
                  ),
              ],
            );
          }
        );
      },
    );
  }
}