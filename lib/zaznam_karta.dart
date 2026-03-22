import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'sklad.dart';
import 'fotka_nahled.dart'; 
import 'zaznam_uprava_dialog.dart'; 

class ZaznamKarta extends StatefulWidget {
  final Map<String, dynamic> zaznam;
  final VoidCallback poZmene; 

  const ZaznamKarta({super.key, required this.zaznam, required this.poZmene});

  @override
  State<ZaznamKarta> createState() => _ZaznamKartaState();
}

class _ZaznamKartaState extends State<ZaznamKarta> {
  
  void _potvrditSmazaniZaznamu() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skutečně vymazat?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Opravdu chceš smazat položku "${widget.zaznam['polozka']}"?\n\nTuhle akci už nepůjde vzít zpět!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('NE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                vsechnyNakupy.remove(widget.zaznam);
              });
              ulozDoPameti(); 
              widget.poZmene(); 
              Navigator.pop(context); 
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Záznam smazán!')));
            },
            child: const Text('ANO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maFotku = widget.zaznam['fotka'] != null;
    final datum = widget.zaznam['datum'] ?? '';

    // ZMĚNA: Zahodili jsme ListTile, stavíme to ručně!
    return InkWell(
      // onTap pro úpravu záznamu jsme nechali
      onTap: () {
        ZaznamUpravaDialog.ukazat(
          context,
          zaznam: widget.zaznam,
          poZmene: () {
            setState(() {}); 
            widget.poZmene(); 
          },
        );
      },
      child: Container(
        // Elegantní čára mezi záznamy
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.black12))),
        // Vykašlali jsme se na standardní ListTile padding
        child: IntrinsicHeight( // Zajišťuje, aby fotka byla stejně vysoká jako text vedle
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Nutí fotku přes celou výšku!
            children: [
              // --- 1. SEKCE: FOTKA (nebo Ikona foťáku) ---
              GestureDetector(
                onTap: maFotku ? () => ukazatVelkouFotku(context, widget.zaznam['fotka']) : null,
                child: Container(
                  width: 90, // Pevná šířka pro logo/fotku
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Šedivé pozadí pro ikony bez fotky
                    // Jemné zaoblení rohu fotky
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)), 
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)), 
                    child: maFotku
                      ? (kIsWeb 
                          ? Image.network(widget.zaznam['fotka'], fit: BoxFit.cover) // BoxFit.cover = fotka se ořízne, ale nezdeformuje
                          : Image.file(File(widget.zaznam['fotka']), fit: BoxFit.cover))
                      // PŘIDÁNO: Pokud fotka není, ukážeme elegantní šedivý foťák
                      : Icon(Icons.camera_alt, size: 40, color: Colors.grey[400]),
                  ),
                ),
              ),
              
              // --- 2. SEKCE: TEXTY (Název, Cena, Datum) ---
              Expanded( // Zabere zbytek místa v řádku
                child: Padding(
                  padding: const EdgeInsets.all(15), // Pěknej prostor kolem textu
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, // Vycentruje texty vertikálně
                    children: [
                      Text(
                        widget.zaznam['polozka'], 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2, // Max 2 řádky pro název, pak se ořízne
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5), // Mezera mezi názvem a cenou
                      Text(
                        '${widget.zaznam['cena']} Kč', 
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15)
                      ),
                      if (datum.isNotEmpty) ...[
                        const SizedBox(height: 3), // Mezera před datem
                        Text(datum, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ],
                  ),
                ),
              ),
              
              // --- 3. SEKCE: POPELNICE (Smazání) ---
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red), 
                onPressed: _potvrditSmazaniZaznamu
              ),
              const SizedBox(width: 5), // Malý odstup od pravého kraje
            ],
          ),
        ),
      ),
    );
  }
}