import 'package:flutter/material.dart';
import 'add_page.dart';
import 'model/plant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Plant> plants = [];

  void _addPlant(Plant newPlant) {
    setState(() {
      plants.add(newPlant);
    });
  }

  void _editPlant(int index, Plant updatedPlant) {
    setState(() {
      plants[index] = updatedPlant;
    });
  }

  void _deletePlant(int index) {
    setState(() {
      plants.removeAt(index);
    });
  }

  void _showEditDialog(int index) async {
    final updatedPlant = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPage(plant: plants[index]),
      ),
    );

    if (updatedPlant != null && updatedPlant is Plant) {
      _editPlant(index, updatedPlant);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("สวนของฉัน")),
      body: plants.isEmpty
          ? const Center(
              child: Text(
                "ยินดีต้อนรับ😊\n\n 🌱 ยังไม่มีพืชในสวนของคุณ\nกดปุ่ม ➕ เพื่อเพิ่มพืชใหม่",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];

                return Dismissible(
                  key: Key(plant.name),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child:
                        const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  onDismissed: (direction) {
                    _deletePlant(index);
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ต้น: ${plant.name}",
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          // แสดงข้อมูลพืช
                          Row(
                            children: [
                              const Icon(Icons.nature, color: Colors.green),
                              const SizedBox(width: 8),
                              Text("จำนวน: ${plant.quantity} ต้น",
                                  style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.date_range, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text("ปลูกเมื่อ: ${plant.datePlanted}",
                                  style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.category, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text("หมวดหมู่: ${plant.category}",
                                  style: const TextStyle(fontSize: 18)),
                            ],
                          ),

                          // ปุ่มแก้ไข / ลบ
                          const Divider(height: 20, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _showEditDialog(index),
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                label: const Text("แก้ไข"),
                              ),
                              TextButton.icon(
                                onPressed: () => _deletePlant(index),
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                label: const Text("ลบ"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );

          if (result != null && result is Plant) {
            _addPlant(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
