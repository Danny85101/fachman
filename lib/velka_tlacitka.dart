import 'package:flutter/material.dart';
import 'fotak_obrazovka.dart'; 

class VelkaTlacitka extends StatelessWidget {
  const VelkaTlacitka({super.key});

  @override
  Widget build(BuildContext context) {
    // Nechali jsme tu jen samotné tlačítko foťáku
    return _tlacitkoAkce(
      context, 
      text: 'VYFOTIT ÚČTENKU', 
      barva: Colors.yellow[600]!, 
      ikona: Icons.camera_alt, 
      cil: const FotakObrazovka()
    );
  }

  Widget _tlacitkoAkce(BuildContext context, {required String text, required Color barva, required IconData ikona, required Widget cil}) {
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