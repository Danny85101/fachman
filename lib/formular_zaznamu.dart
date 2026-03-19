import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'data_formulare.dart'; // Načteme si propisky
import 'tlacitko_ulozit.dart'; // Načteme si naše oddělené tlačítko

class FormularZaznamu extends StatefulWidget {
  const FormularZaznamu({super.key});

  @override
  State<FormularZaznamu> createState() => _FormularZaznamuState();
}

class _FormularZaznamuState extends State<FormularZaznamu> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  void _ziskatHlas(TextEditingController kamZapsat, String nazevKolonky) async {
    bool dostupne = await _speech.initialize();
    if (dostupne) {
      bool posloucham = true;
      String prubeznyText = kamZapsat.text; 

      showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              if (posloucham) {
                _speech.listen(
                  localeId: 'cs_CZ',
                  onResult: (vysledek) {
                    setModalState(() {
                      kamZapsat.text = prubeznyText.isEmpty 
                          ? vysledek.recognizedWords 
                          : "$prubeznyText ${vysledek.recognizedWords}";
                    });
                  },
                );
              } else {
                _speech.stop();
              }

              return Container(
                padding: const EdgeInsets.all(20),
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Diktuješ do: $nazevKolonky', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    Text(kamZapsat.text, style: const TextStyle(fontSize: 18, color: Colors.blue), textAlign: TextAlign.center, maxLines: 2),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        setModalState(() => posloucham = false);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(color: posloucham ? Colors.red : Colors.orange, shape: BoxShape.circle),
                        child: Icon(posloucham ? Icons.stop : Icons.mic, size: 40, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ).whenComplete(() => _speech.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
          child: Column(
            children: [
              TextField(
                controller: nakupController,
                decoration: InputDecoration(
                  labelText: 'CO JSI KOUPIL / DĚLAL?',
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.blue),
                    onPressed: () => _ziskatHlas(nakupController, 'CO JSI KOUPIL'),
                  ),
                ),
              ),
              TextField(
                controller: zakaznikController,
                decoration: InputDecoration(
                  labelText: 'PRO KOHO? (Zákazník)',
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.blue),
                    onPressed: () => _ziskatHlas(zakaznikController, 'PRO KOHO'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: hodinyController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'HODINY',
                        border: const UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.mic, color: Colors.blue),
                          onPressed: () => _ziskatHlas(hodinyController, 'HODINY'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: sazbaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Kč / HOD',
                        border: const UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.mic, color: Colors.blue),
                          onPressed: () => _ziskatHlas(sazbaController, 'Kč / HOD'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: cenaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'NEBO PEVNÁ CENA (Kč)',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.blue),
                    onPressed: () => _ziskatHlas(cenaController, 'PEVNÁ CENA'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        
        // TADY SE NAČTE TO NAŠE ODDĚLENÉ ZELENÉ TLAČÍTKO
        const TlacitkoUlozit(),
      ],
    );
  }
}