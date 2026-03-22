import 'package:flutter/material.dart';

class DiarKarta extends StatelessWidget {
  final Map<String, dynamic> zakazka;
  final String hezkeDatum;
  final VoidCallback naSmazani;
  final VoidCallback naUpravu;

  const DiarKarta({
    super.key,
    required this.zakazka,
    required this.hezkeDatum,
    required this.naSmazani,
    required this.naUpravu,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        // Když se ťukne na kartičku, zavolá se funkce pro úpravu
        onTap: naUpravu,
        
        leading: const Icon(Icons.calendar_month, color: Colors.orange, size: 35),
        
        title: Text(
          '$hezkeDatum - ${zakazka['kdo']}', 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        
        subtitle: Text(
          zakazka['co'], 
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        // Naše stará známá popelnice, která zavolá funkci pro smazání
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: naSmazani, 
        ),
      ),
    );
  }
}