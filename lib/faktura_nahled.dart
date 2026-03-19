import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

// Funkce, kterou zavoláme, když chceme ukázat fakturu
void ukazatNahledFaktury(BuildContext context, String zakaznik, List<Map<String, dynamic>> veci, double celkem) {
  
  // 1. Text pro případné odeslání (WhatsApp, mail...)
  String textKodeslani = 'Vyúčtování: $zakaznik\n';
  textKodeslani += '------------------------\n';
  for (var vec in veci) {
    textKodeslani += '- ${vec['polozka']}: ${vec['cena']} Kč\n';
  }
  textKodeslani += '------------------------\n';
  textKodeslani += 'CELKEM K ÚHRADĚ: $celkem Kč';

  // 2. Samotné okno s excelovskou tabulkou
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Náhled: $zakaznik', style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
              columns: const [
                DataColumn(label: Text('Položka', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Cena', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: veci.map((vec) => DataRow(
                cells: [
                  DataCell(Text(vec['polozka'].toString())),
                  DataCell(Text('${vec['cena']} Kč')),
                ],
              )).toList(),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 2, color: Colors.black),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('CELKEM:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('$celkem Kč', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text('ZAVŘÍT', style: TextStyle(color: Colors.grey))
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () {
            Share.share(textKodeslani); 
          }, 
          icon: const Icon(Icons.send, color: Colors.white),
          label: const Text('ODESLAT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        )
      ],
    )
  );
}