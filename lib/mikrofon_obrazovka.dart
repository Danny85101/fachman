import 'package:flutter/material.dart';

class MikrofonObrazovka extends StatelessWidget {
  const MikrofonObrazovka({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('DIKTOVÁNÍ', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Klepni a mluv...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            // OBŘÍ KULATÉ TLAČÍTKO MIKROFONU
            InkWell(
              onTap: () {
                // Zkušební hláška po stisknutí
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nahrávám hlas...')),
                );
              },
              child: Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle, // Udělá z toho dokonalé kolo
                ),
                child: const Icon(Icons.mic, size: 80, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}