import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/plant.dart';

class AddPage extends StatefulWidget {
  final Plant? plant;

  const AddPage({super.key, this.plant});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;

  final List<String> _categories = ["ไม้ดอก", "ไม้ใบ", "ไม้ผล", "สมุนไพร"];

  @override
  void initState() {
    super.initState();
    if (widget.plant != null) {
      _nameController.text = widget.plant!.name;
      _quantityController.text = widget.plant!.quantity.toString();
      _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.plant!.datePlanted);
      _selectedCategory = widget.plant!.category;
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("กรุณาเลือกวันที่ปลูก")),
        );
        return;
      }

      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("กรุณาเลือกประเภทพืช")),
        );
        return;
      }

      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      Plant newPlant = Plant(
        name: _nameController.text,
        quantity: int.parse(_quantityController.text),
        datePlanted: formattedDate,
        category: _selectedCategory ?? "ไม่ระบุ",
      );

      Navigator.pop(context, newPlant);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.plant == null ? "เพิ่มพืชใหม่" : "แก้ไขพืช")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "ชื่อพืช",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาป้อนชื่อพืช";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: "จำนวนต้น",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาป้อนจำนวน";
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return "กรุณาป้อนตัวเลขที่ถูกต้อง";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(_selectedDate == null
                    ? "เลือกวันที่ปลูก"
                    : "วันที่ปลูก: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}"),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "ประเภทพืช",
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return "กรุณาเลือกประเภทพืช";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                    widget.plant == null ? "เพิ่มพืช" : "บันทึกการเปลี่ยนแปลง"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
