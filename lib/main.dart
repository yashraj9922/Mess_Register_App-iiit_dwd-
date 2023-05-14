import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Milk and Curd Entries',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _rollNumberController = TextEditingController();
  final _quantityController = TextEditingController();
  String _selectedEntryType = 'Milk';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milk and Curd Entries'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _rollNumberController,
              decoration: InputDecoration(
                labelText: 'Roll Number',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedEntryType,
              onChanged: (value) {
                setState(() {
                  _selectedEntryType = value!;
                });
              },
              items: ['Milk', 'Curd']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Entry Type',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addEntry,
              child: Text('Add Entry'),
            ),
          ],
        ),
      ),
    );
  }

  void _addEntry() async {
    if (_rollNumberController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      final rollNumber = _rollNumberController.text;
      final quantity = int.parse(_quantityController.text);
      final type = _selectedEntryType;
      final now = DateTime.now();
      final entry = '$type,$quantity,${now.toString()}';
      final directory = await getExternalStorageDirectory();
      final entryDirectory = Directory('${directory!.path}/entries');
      if (!(await entryDirectory.exists())) {
        entryDirectory.create();
      }
      final file = File('${entryDirectory.path}/$rollNumber.csv');
      if (await file.exists()) {
        await file.writeAsString('$entry\n', mode: FileMode.append);
      } else {
        await file.writeAsString('$entry\n');
      }
      _rollNumberController.clear();
      _quantityController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Entry added successfully.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter roll number and quantity.'),
        ),
      );
    }
  }
}
