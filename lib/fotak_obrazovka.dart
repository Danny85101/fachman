import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dialog_zakaznici.dart'; // Natahujeme kabel do našeho nového souboru s oknem zákazníků

class FotakObrazovka extends StatefulWidget {
  const FotakObrazovka({super.key});

  @override
  State<FotakObrazovka> createState() => _FotakObrazovkaState();
}

class _FotakObrazovkaState extends State<FotakObrazovka> {
  XFile? vyfocenaFotka;
  final picker = ImagePicker();

  Future<void> _vyfotitUctenku() async {
    // TADY JE TA OPRAVA PRO PAMĚŤ TELEFONU! (imageQuality: 30)
    // Fotka bude mít rázem pár kilo místo několika megabajtů
    final XFile? fotka = await picker.pickImage(source: ImageSource.camera, imageQuality: 30);
    if (fotka != null) {
      setState(() {
        vyfocenaFotka = fotka;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: AppBar(
        title: const Text('FOTOAPARÁT', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey[900],
              child: vyfocenaFotka == null
                  ? const Center(child: Icon(Icons.camera, size: 100, color: Colors.white24))
                  : (kIsWeb ? Image.network(vyfocenaFotka!.path) : Image.file(File(vyfocenaFotka!.path))), 
            ),
          ),
          
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 40),
            color: Colors.black,
            child: Center(
              child: Column(
                children: [
                  InkWell(
                    onTap: _vyfotitUctenku,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey[400]!, width: 5)),
                    ),
                  ),

                  if (vyfocenaFotka != null) ...[
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
                      // Tady místo zdlouhavého kódu jenom zavoláme funkci z nového souboru
                      onPressed: () => ukazDialogZakaznici(context, vyfocenaFotka!.path), 
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text('HOTOVO - PŘIDAT K VÝDAJI', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}