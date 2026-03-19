import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

// Vytáhli jsme sem funkci na otevírání fotky, ať nestraší v hlavním souboru
void ukazatVelkouFotku(BuildContext context, String cestaKFotce) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          InteractiveViewer(
            panEnabled: true,
            minScale: 1.0,
            maxScale: 4.0,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: kIsWeb 
                  ? Image.network(cestaKFotce, fit: BoxFit.contain)
                  : Image.file(File(cestaKFotce), fit: BoxFit.contain),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    ),
  );
}