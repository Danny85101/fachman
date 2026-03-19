import 'package:flutter/material.dart';
import 'sklad_diar.dart'; // Saháme do paměti diáře

class DiarObrazovka extends StatefulWidget {
  const DiarObrazovka({super.key});

  @override
  State<DiarObrazovka> createState() => _DiarObrazovkaState();
}

class _DiarObrazovkaState extends State<DiarObrazovka> {
  final TextEditingController kdyController = TextEditingController();
  final TextEditingController kdoController = TextEditingController();
  final TextEditingController coController = TextEditingController();

  // Funkce, která otevře okénko pro zadání nové práce
  void _pridatZakazku() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nová zakázka', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: kdyController, decoration: const InputDecoration(labelText: 'Kdy (např. Čtvrtek 8:00)')),
            TextField(controller: kdoController, decoration: const InputDecoration(labelText: 'Kdo (Zákazník)')),
            TextField(controller: coController, decoration: const InputDecoration(labelText: 'Co se bude dělat')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ZRUŠIT', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              if (kdyController.text.isNotEmpty && kdoController.text.isNotEmpty) {
                setState(() {
                  // Zapíšeme novou práci do naší krabice
                  vsechnyZakazky.add({
                    'kdy': kdyController.text,
                    'kdo': kdoController.text,
                    'co': coController.text,
                  });
                  ulozDiarDoPameti(); // A rovnou uložíme na disk
                });
                
                // Vyčistíme kolonky pro příště
                kdyController.clear();
                kdoController.clear();
                coController.clear();
                Navigator.pop(context); // Zavřeme okénko
              }
            },
            child: const Text('ULOŽIT', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // Funkce pro smazání (odškrtnutí) hotové práce
  void _smazatZakazku(Map<String, dynamic> zakazka) {
    setState(() {
      vsechnyZakazky.remove(zakazka);
      ulozDiarDoPameti();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dobrá práce! Úkol splněn.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('MŮJ DIÁŘ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      
      body: vsechnyZakazky.isEmpty
          ? const Center(child: Text('Zatím nemáš naplánovanou žádnou práci.', style: TextStyle(fontSize: 18)))
          // Tady se vypisují všechny naplánované práce pod sebou
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: vsechnyZakazky.length,
              itemBuilder: (context, index) {
                var zakazka = vsechnyZakazky[index];
                
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month, color: Colors.orange, size: 35),
                    title: Text('${zakazka['kdy']} - ${zakazka['kdo']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text(zakazka['co'], style: const TextStyle(fontSize: 16)),
                    
                    // Zelená fajfka pro splnění úkolu
                    trailing: IconButton(
                      icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 35),
                      onPressed: () => _smazatZakazku(zakazka),
                    ),
                  ),
                );
              },
            ),
            
      // Tlačítko dole v rohu pro přidání
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pridatZakazku,
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('PŘIDAT PRÁCI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}