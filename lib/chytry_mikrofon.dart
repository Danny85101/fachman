import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChytryMikrofon {
  final stt.SpeechToText _speech = stt.SpeechToText();

  void ziskatHlas(BuildContext context, TextEditingController kamZapsat, String nazevKolonky) async {
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
}