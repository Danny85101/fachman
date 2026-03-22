import 'package:flutter/material.dart';
import 'data_formulare.dart'; 
import 'tlacitko_ulozit.dart'; 
import 'chytry_mikrofon.dart'; 

class FormularZaznamu extends StatefulWidget {
  // PŘIDÁNO: Připravili jsme místo pro kabel (zvonek z hlavní obrazovky)
  final VoidCallback? poUlozeni;

  const FormularZaznamu({super.key, this.poUlozeni});

  @override
  State<FormularZaznamu> createState() => _FormularZaznamuState();
}

class _FormularZaznamuState extends State<FormularZaznamu> {
  final ChytryMikrofon mujMikrofon = ChytryMikrofon();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey)),
          child: Column(
            children: [
              // Ta stará zelená kontrolka je odtud odstraněna, protože ji máme nově hned pod žlutým tlačítkem

              TextField(
                controller: nakupController,
                decoration: InputDecoration(
                  labelText: 'CO JSI KOUPIL / DĚLAL?',
                  border: const UnderlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.blue),
                    onPressed: () => mujMikrofon.ziskatHlas(context, nakupController, 'CO JSI KOUPIL'),
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
                    onPressed: () => mujMikrofon.ziskatHlas(context, zakaznikController, 'PRO KOHO'),
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
                          onPressed: () => mujMikrofon.ziskatHlas(context, hodinyController, 'HODINY'),
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
                          onPressed: () => mujMikrofon.ziskatHlas(context, sazbaController, 'Kč / HOD'),
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
                    onPressed: () => mujMikrofon.ziskatHlas(context, cenaController, 'PEVNÁ CENA'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        
        // PŘIDÁNO: Předáváme kabel od zvonku dál dolů přímo do ukládacího tlačítka!
        TlacitkoUlozit(poUlozeni: widget.poUlozeni),
      ],
    );
  }
}