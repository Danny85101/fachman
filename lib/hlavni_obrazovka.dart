import 'package:flutter/material.dart';
import 'historie_obrazovka.dart'; 
import 'diar_obrazovka.dart'; 
import 'velka_tlacitka.dart'; 
import 'formular_zaznamu.dart'; 
import 'data_formulare.dart'; 

class HlavniObrazovka extends StatefulWidget {
  const HlavniObrazovka({super.key});

  @override
  State<HlavniObrazovka> createState() => _HlavniObrazovkaState();
}

class _HlavniObrazovkaState extends State<HlavniObrazovka> {

  void _obnovitObrazovku() {
    setState(() {});
  }

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
            icon: const Icon(Icons.calendar_month, size: 30),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DiarObrazovka())),
          ),
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
              VelkaTlacitka(poVyfoceni: _obnovitObrazovku), 

              // --- TVOJE REZERVOVANÁ MEZERA NA PÁSKU ---
              const SizedBox(height: 12), 
              Container(
                height: 50, // Pevná výška, která drží obrazovku na místě!
                width: double.infinity,
                decoration: BoxDecoration(
                  // Barva se mění ze zelené na průhlednou podle toho, jestli máme fotku
                  color: prilozenaFotka != null ? Colors.green : Colors.transparent, 
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Center(
                  // Text zmizí, když fotka není
                  child: Text(
                    prilozenaFotka != null ? '📷 FOTO PŘIPOJENO' : '', 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                ),
              ),
              // ----------------------------------------

              const SizedBox(height: 15),
              FormularZaznamu(poUlozeni: _obnovitObrazovku), 
            ],
          ),
        ),
      ),
    );
  }
}