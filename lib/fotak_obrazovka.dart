import 'package:flutter/material.dart';

class FotakObrazovka extends StatelessWidget {
  const FotakObrazovka({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Foťák má většinou černé pozadí, ať neruší
      appBar: AppBar(
        title: const Text('FOTOAPARÁT', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // HLEDÁČEK FOŤÁKU (zatím jen šedá plocha s ikonkou)
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[900],
              child: const Center(
                child: Icon(Icons.camera, size: 100, color: Colors.white24),
              ),
            ),
          ),
          
          // SPODNÍ PANEL S TLAČÍTKEM SPOUŠTĚ
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            color: Colors.black,
            child: Center(
              child: InkWell(
                onTap: () {
                  // Povel po stisknutí spouště
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('CVAK! Účtenka vyfocena.')),
                  );
                },
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle, // Udělá z toho dokonalé kolo
                    border: Border.all(color: Colors.grey[400]!, width: 5), // Tlustý okraj
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}