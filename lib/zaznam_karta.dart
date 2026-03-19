import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'sklad.dart';
import 'fotka_nahled.dart'; // Aby řádek uměl otevřít fotku

class ZaznamKarta extends StatefulWidget {
  final Map<String, dynamic> zaznam;
  final VoidCallback poZmene; // Tohle je takový zvonek, kterým karta cinkne na hlavní obrazovku, když něco smaže/upraví

  const ZaznamKarta({super.key, required this.zaznam, required this.poZmene});

  @override
  State<ZaznamKarta> createState() => _ZaznamKartaState();
}

class _ZaznamKartaState extends State<ZaznamKarta> {
  
  void _smazatZaznam() {
    setState(() {
      vsechnyNakupy.remove(widget.zaznam);
    });
    ulozDoPameti(); // Uložíme smazání na disk
    widget.poZmene(); // Cinkneme hlavní obrazovce, ať se překreslí
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Záznam smazán!')));
  }

  void _upravitZaznam() {
    TextEditingController upravaNazev = TextEditingController(text: widget.zaznam['polozka']);
    TextEditingController upravaCena = TextEditingController(text: widget.zaznam['cena'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Opravit záznam', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: upravaNazev, decoration: const InputDecoration(labelText: 'Název')),
            TextField(controller: upravaCena, decoration: const InputDecoration(labelText: 'Cena (Kč)'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ZRUŠIT', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              setState(() {
                widget.zaznam['polozka'] = upravaNazev.text;
                widget.zaznam['cena'] = double.tryParse(upravaCena.text) ?? 0;
              });
              ulozDoPameti(); // Uložíme opravu na disk
              widget.poZmene(); // Cinkneme obrazovce
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Záznam opraven!')));
            },
            child: const Text('ULOŽIT OPRAVU', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maFotku = widget.zaznam['fotka'] != null;
    // TADY SI VYTAHUJEME TO NAŠE NOVÉ DATUM (pokud tam je)
    final datum = widget.zaznam['datum'] ?? '';

    return Container(
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        
        leading: maFotku
            ? GestureDetector(
                onTap: () => ukazatVelkouFotku(context, widget.zaznam['fotka']),
                child: SizedBox(
                  width: 50, height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: kIsWeb 
                        ? Image.network(widget.zaznam['fotka'], fit: BoxFit.cover)
                        : Image.file(File(widget.zaznam['fotka']), fit: BoxFit.cover),
                  ),
                ),
              )
            : const Icon(Icons.receipt_long, size: 30, color: Colors.grey),
        
        title: Text(widget.zaznam['polozka'], style: const TextStyle(fontWeight: FontWeight.bold)),
        // POD CENU JSME PŘIDALI I ZOBRAZENÍ DATA
        subtitle: Text('${widget.zaznam['cena']} Kč\n$datum', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        isThreeLine: datum.isNotEmpty, // Pokud máme datum, uděláme víc místa pro text
        
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: _upravitZaznam),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: _smazatZaznam),
          ],
        ),
      ),
    );
  }
}