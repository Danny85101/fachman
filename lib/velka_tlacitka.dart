import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; 
import 'data_formulare.dart'; 
import 'dialog_zakaznici.dart'; 

class VelkaTlacitka extends StatelessWidget {
  // PŘIDÁNO: Připravili jsme místo pro náš "zvonek" (funkci z hlavní obrazovky)
  final VoidCallback? poVyfoceni;

  // PŘIDÁNO: Tlačítko teď umí ten zvonek přijmout do své výbavy
  const VelkaTlacitka({super.key, this.poVyfoceni});

  void _zkusitVyfotit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chceš fotit?', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('NE', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Navigator.pop(context); // Zavřeme otázku
              
              // Spouštíme rovnou pravý systémový foťák
              final ImagePicker picker = ImagePicker();
              final XFile? fotka = await picker.pickImage(source: ImageSource.camera, imageQuality: 30);

              // Pokud uživatel fotku normálně cvakne
              if (fotka != null) {
                // 1. Uložíme ji do tvé propisky
                prilozenaFotka = fotka.path; 
                
                // 2. ZAZVONÍME! (Tím se hlavní obrazovka překreslí a ukáže zelenou lištu)
                if (poVyfoceni != null) {
                  poVyfoceni!(); 
                }

                // 3. A HNED na něj vyhodíme okno s výběrem zákazníka!
                ukazDialogZakaznici(context, prilozenaFotka!);
              }
            },
            child: const Text('ANO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _zkusitVyfotit(context),
        icon: const Icon(Icons.camera_alt, size: 50, color: Colors.black),
        label: const Text('VYFOTIT ÚČTENKU', style: TextStyle(fontSize: 24, color: Colors.black)),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[600], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}