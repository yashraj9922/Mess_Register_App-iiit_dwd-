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

  final gsheets = GSheets(r'''
{
  "type": "service_account",
  "project_id": "gsheets-387620",
  "private_key_id": "123b49dc1dac90de884d78891a82ec1e4639c8f6",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCZpsyQVWNtWJ5q\nvroQ4yclHVa7H5NebaFGCzkVDPl4iMDHFUfqAeBPTfYcsct3B7vmL1FzwgWdFGRl\n4mcd69yWwA+WR7OgFXK1vsoQr2MQjG6utz5XLopyXAc5gg3MduRD0sOanftTu1oh\ndJArhdoSLN62QGxDib5ABxNcp96tiWvSh9hTreY7iws1S+oA4ti43NbnwKD5eLM8\nC4vjJqS0m5vPg8Y4uhjX8Km/3CcJnc9aHWIybDlfO0AuzAloKMoID2lnUQrn1a+U\n6dNCl+fsGSkz1eAD6Vk+lAU0D93GjeK9lHYOGjCtiBecZgtjlcFqAglVNRN8mB5t\n5zGKOVbrAgMBAAECggEAAm9mUT3z3skcxExUM+2lsoI4hwFacJCu5vvz4lAw/qa2\n3MY1kZEzYOO3bCpVMy8S3J8QshOidc7bmHxyGJijB7CbjqIsR/PkZtpTPC3Las5k\nTViSIFztzMowmHS7NeuxynFjWuajaRGlvV9U5EZcImrw91UmDMaja+2wx4h8OvvV\nnu6VobsqyIg0vdBLuw801R3jal9OFGnX6l/QmcLyJXaUwrGP0qkuks5y/Yd2wGQW\nGqJzZs/YQTCjCdSfePlMj7nYoyq9Khc9jCLEFSh15jth/yOcFRay1NYP84g98k8i\nrRcl7VAA1pPu+QgipJYe6OJ637IwCLBcw/sDDc+kwQKBgQDGm8fFL+djvT9PKcpt\n+RcpJvLF5Q4RjjQAgiRavASO5Hj0+s10xY5UN7xFxhToUm6MZ/iTjInXFv2gERPY\nwQnE/r76mmnao+sVa0/2OoqKbKQ6lNFAeXXMnlfk3wLo2C5G0Duw+te/5nxNOPtp\nVt0zYAvjV3OSSpP4mNy0MrTt2QKBgQDGDUrx3uVGGagX5CTCg/Mly70999btJZ5V\nA5T1nJCGwnt9cDzDbapQS37f34phQdKhk7D1HVyIzhm/tp1ACIh1gKtfbxHUC58b\nd2iD/g89nV/X+0t4Qxx7pupuz0CD6YGLHIxHGQcWGQMxVtHm4iPPrkLHI51sHI7M\nXH1rEIa8YwKBgCNYL8oQx14BnNWqu0Ks9Ik3TDcZl1Jaezin8G5RTYJceIYoaA3i\n5nxoWtIT+T6LBO9pxVwEw7cKeWJWB7EoUWPEbhpNBo+JYlmyek14h5Uw1l0yhLaz\nptoeR8gMRAlKB5pEjorlaSXWj8JyZJOPiNgOvK7drkyXhxPTqFtNNtOpAoGATCqI\njARgwFjVoHqI+JWuSPbVzKMn8QPqpF9ARkT0AB+DRnaHp9DhEwg1vvtFSKn7y0/1\nWg70q1g35tbgGuQtNqNJROZ+QMJHalS9ySVHzzZaycFHAPUuWw+SURM7iH+g5lMQ\nT7d8Vi9AXxU4nEaT5ybpX5R+0jkZYdagFTDB4GkCgYEAnuibu7RnTPZ3pqxyQaBz\nVXn+1yNbmPFHkAAPlXqMZGsyXa1jkMUz29+oGpyGo6OQ7kW///yICAjGFsV15Isk\nXl+d1bQNi4q3HZHmSk7B1MT0fpI352ICq6FuWvHWzmb3fkNZl5joJf/2V390qZcU\n3l+rGb+bieN4tHBPQbvhss4=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-387620.iam.gserviceaccount.com",
  "client_id": "109431254499431226867",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-387620.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
'''); // Replace with your own credentials file

  final spreadsheetId = '1w-VzJr0VEuVndCdt1uq2AlPe_txnB1EYCWsjrSECODM';
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
