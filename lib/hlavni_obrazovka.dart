import 'package:flutter/material.dart';
import 'historie_obrazovka.dart'; 
import 'diar_obrazovka.dart'; // Natahujeme kabel do budoucího Diáře
import 'velka_tlacitka.dart'; 
import 'formular_zaznamu.dart'; 

class HlavniObrazovka extends StatelessWidget {
  const HlavniObrazovka({super.key});

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
          // 1. NOVÉ TLAČÍTKO - DIÁŘ (Kalendář)
          IconButton(
            icon: const Icon(Icons.calendar_month, size: 30),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DiarObrazovka())),
          ),
          // 2. PŮVODNÍ TLAČÍTKO - HISTORIE (Hodiny)
          IconButton(
            icon: const Icon(Icons.history, size: 30),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistorieObrazovka())),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              VelkaTlacitka(), 
              SizedBox(height: 15),
              FormularZaznamu(), 
            ],
          ),
        ),
      ),
    );
  }
}