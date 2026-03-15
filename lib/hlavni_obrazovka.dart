import 'package:flutter/material.dart';
import 'fotak_obrazovka.dart'; 
import 'mikrofon_obrazovka.dart'; 
import 'historie_obrazovka.dart'; 
import 'sklad.dart'; 

class HlavniObrazovka extends StatefulWidget {
  const HlavniObrazovka({super.key});

  @override
  State<HlavniObrazovka> createState() => _HlavniObrazovkaState();
}

class _HlavniObrazovkaState extends State<HlavniObrazovka> {
  final nakupController = TextEditingController();
  final zakaznikController = TextEditingController();
  final cenaController = TextEditingController();
  // NOVÉ: Propisky pro hodiny a sazbu
  final hodinyController = TextEditingController();
  final sazbaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), 
      appBar: AppBar(
        title: const Text('DIGITÁLNÍ FACHMAN', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, size: 30),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistorieObrazovka())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildVelkaTlacitka(), 
              const SizedBox(height: 15),
              _buildFormular(),      
              const SizedBox(height: 25),
              _buildTlacitkoUlozit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVelkaTlacitka() {
    return Column(
      children: [
        _tlacitkoAkce(
          text: 'DIKTOVAT VÝDAJ',
          barva: Colors.orange,
          ikona: Icons.mic,
          cil: const MikrofonObrazovka(),
        ),
        const SizedBox(height: 15),
        _tlacitkoAkce(
          text: 'VYFOTIT ÚČTENKU',
          barva: Colors.yellow[600]!,
          ikona: Icons.camera_alt,
          cil: const FotakObrazovka(),
        ),
      ],
    );
  }

  Widget _buildFormular() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
      child: Column(
        children: [
          TextField(
            controller: nakupController,
            decoration: const InputDecoration(labelText: 'CO JSI KOUPIL / DĚLAL?', border: UnderlineInputBorder()),
          ),
          TextField(
            controller: zakaznikController,
            decoration: const InputDecoration(labelText: 'PRO KOHO? (Zákazník)', border: UnderlineInputBorder()),
          ),
          const SizedBox(height: 10),
          // ŘÁDEK PRO HODINY A SAZBU (vedle sebe)
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: hodinyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'HODINY', border: UnderlineInputBorder()),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: sazbaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Kč / HOD', border: UnderlineInputBorder()),
                ),
              ),
            ],
          ),
          TextField(
            controller: cenaController,
            keyboardType: TextInputType.number, 
            decoration: const InputDecoration(labelText: 'NEBO PEVNÁ CENA (Kč)', border: InputBorder.none),
          ),
        ],
      ),
    );
  }

  Widget _buildTlacitkoUlozit() {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        onPressed: () {
          // LOGIKA VÝPOČTU
          double vyslednaCena = 0;
          double hodiny = double.tryParse(hodinyController.text) ?? 0;
          double sazba = double.tryParse(sazbaController.text) ?? 0;
          double pevnaCena = double.tryParse(cenaController.text) ?? 0;

          if (hodiny > 0 && sazba > 0) {
            vyslednaCena = hodiny * sazba; // Výpočet práce
          } else {
            vyslednaCena = pevnaCena; // Klasický nákup
          }

          if (nakupController.text.isNotEmpty && vyslednaCena > 0) {
            setState(() {
              vsechnyNakupy.add({
                'polozka': hodiny > 0 ? '${nakupController.text} ($hodiny hod)' : nakupController.text,
                'zakaznik': zakaznikController.text.isEmpty ? 'Neznámý' : zakaznikController.text,
                'cena': vyslednaCena,
              });
            });

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Uloženo do paměti!')));
            
            // Vymazání všeho
            nakupController.clear();
            zakaznikController.clear();
            cenaController.clear();
            hodinyController.clear();
            sazbaController.clear();
          }
        },
        child: const Text('ULOŽIT VÝDAJ / PRÁCI', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _tlacitkoAkce({required String text, required Color barva, required IconData ikona, required Widget cil}) {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => cil)),
        icon: Icon(ikona, size: 50, color: Colors.black),
        label: Text(text, style: const TextStyle(fontSize: 24, color: Colors.black)),
        style: ElevatedButton.styleFrom(backgroundColor: barva, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}