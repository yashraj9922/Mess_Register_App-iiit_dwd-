import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:mess_register/qrView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mess_Register',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _quantityControllermilk = TextEditingController();
  final _quantityControllercurd = TextEditingController();
  String _scannedRollNumber = '';
  int _counterMilk = 0;
  int _counterCurd = 0;

  final gsheets = GSheets("....."); // Replace with your own credentials file

  final spreadsheetId = '......'; // Replace with your own credentials file
  final now = DateTime.now();

  late Worksheet userSheet;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try {
      final spreadsheet = await gsheets.spreadsheet(spreadsheetId);
      userSheet = await _createSheet(
        spreadsheet,
        title: 'Sheet_${now.month}/${now.year}',
      );
    } catch (e) {
      print('Init Error: $e');
    }
  }

  static Future<Worksheet> _createSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

void _addEntry() async {
  if (_scannedRollNumber.isNotEmpty &&
      (_quantityControllermilk.text.isNotEmpty ||
          _quantityControllercurd.text.isNotEmpty)) {
    final rollNumber = _scannedRollNumber;
    final quantitymilk = _quantityControllermilk.text.isNotEmpty
        ? double.parse(_quantityControllermilk.text)
        : 0.0;
    final quantitycurd = _quantityControllercurd.text.isNotEmpty
        ? double.parse(_quantityControllercurd.text)
        : 0.0;

    final rows = await userSheet.values.allRows();
    int rowIndex = -1;
    for (int i = 0; i < rows.length; i++) {
      if (rows[i][0] == rollNumber) {
        rowIndex = i;
        break;
      }
    }

    if (rowIndex != -1) {
      final existingMilkLQuantity =
          double.parse(rows[rowIndex][1] ?? '0'); // Parse existing value or use 0 as default
      final existingCurdLQuantity =
          double.parse(rows[rowIndex][2] ?? '0'); // Parse existing value or use 0 as default

      double newMilkLQuantity = existingMilkLQuantity;
      double newCurdLQuantity = existingCurdLQuantity;

      newMilkLQuantity += quantitymilk * 0.5;
      newCurdLQuantity += quantitycurd * 0.5;

      rows[rowIndex][1] = newMilkLQuantity.toString();
      rows[rowIndex][2] = newCurdLQuantity.toString();

      await userSheet.values.insertRow(rowIndex + 1, rows[rowIndex]);
    } else {
      // Check if the worksheet is empty
      if (rows.isEmpty) {
        await userSheet.values.appendRow([
          'Roll No.',
          'Milk',
          'Curd',
        ]);
      }

      if (rollNumber.isNotEmpty) {
        await userSheet.values.appendRow([
          rollNumber,
          (quantitymilk * 0.5).toString(),
          (quantitycurd * 0.5).toString(),
        ]);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Entry added successfully.'),
      ),
    );

    setState(() {
      // Resetting the parameters
      _quantityControllermilk.clear();
      _quantityControllercurd.clear();
      _scannedRollNumber = '';
      _counterMilk = 0;
      _counterCurd = 0;
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please scan a QR code and enter the quantity.'),
      ),
    );
  }
}


  Future<void> _scanQRCode() async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => QRViewExample(
          onScannedQRCode: (code) {
            setState(() {
              _scannedRollNumber = code;
            });
            Navigator.pop(context);
          },
        ),
      ),
    );

    if (code != null) {
      setState(() {
        _scannedRollNumber = code;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Mess_Register')),
        backgroundColor: const Color.fromARGB(255, 0, 21, 64),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 25.0,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.italic,
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255, 0, 26, 79),
        child: const Text(
          'Yashraj_Kadam, 22BDS066',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 35.0),
            Image.asset(
              'assets/iiit_dharwad_logo.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 25.0),
            Center(
              child: Text(
                '$_scannedRollNumber',
                style: const TextStyle(
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 4, 152, 100), // Text color
                ),
              ),
            ),
            const SizedBox(height: 25.0),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 165.0, // Adjust the width as needed
                            height: 70.0, // Adjust the height as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius as needed
                              border: Border.all(
                                color: Color.fromARGB(
                                    255, 2, 48, 75), // Border color
                                width: 2.0, // Border width
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Milk',
                                style: TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(
                                      255, 0, 0, 0), // Text color
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    if (_counterMilk > 0) {
                                      _counterMilk--;
                                      _quantityControllermilk.text = _counterMilk
                                          .toString(); // Update quantity controller value
                                    }
                                  });
                                },
                                backgroundColor: Colors.white,
                                child: const Icon(Icons.remove,
                                    color: Colors.black),
                              ),
                              Text('$_counterMilk',
                                  style: const TextStyle(fontSize: 55.0)),
                              FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    _counterMilk++;
                                    _quantityControllermilk.text = _counterMilk
                                        .toString(); // Update quantity controller value
                                  });
                                },
                                backgroundColor: Colors.white,
                                child:
                                    const Icon(Icons.add, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 165.0, // Adjust the width as needed
                            height: 70.0, // Adjust the height as needed
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius as needed
                              border: Border.all(
                                color: const Color.fromARGB(
                                    255, 2, 48, 75), // Border color
                                width: 2.0, // Border width
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Curd',
                                style: TextStyle(
                                  fontSize: 26.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(
                                      255, 0, 0, 0), // Text color
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    if (_counterCurd > 0) {
                                      _counterCurd--;
                                      _quantityControllercurd.text = _counterCurd
                                          .toString(); // Update quantity controller value
                                    }
                                  });
                                },
                                backgroundColor: Colors.white,
                                child: const Icon(Icons.remove,
                                    color: Colors.black),
                              ),
                              Text('$_counterCurd',
                                  style: const TextStyle(fontSize: 55.0)),
                              FloatingActionButton(
                                onPressed: () {
                                  setState(() {
                                    _counterCurd++;
                                    _quantityControllercurd.text = _counterCurd
                                        .toString(); // Update quantity controller value
                                  });
                                },
                                backgroundColor: Colors.white,
                                child:
                                    const Icon(Icons.add, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 285.0, // Adjust the width as needed
                  height: 60.0, // Adjust the height as needed
                  child: ElevatedButton(
                    onPressed: _scanQRCode,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 4, 172, 113)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              23.0), // Adjust the value as needed
                        ),
                      ),
                    ),
                    child: const Text('Scan QR Code'),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 285.0, // Adjust the width as needed
                  height: 60.0, // Adjust the height as needed
                  child: ElevatedButton(
                    onPressed: _addEntry,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(198, 148, 15, 15)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              23.0), // Adjust the value as needed
                        ),
                      ),
                    ),
                    child: const Text('Add Entry'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
