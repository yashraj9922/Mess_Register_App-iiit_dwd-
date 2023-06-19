import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
  final _quantityController = TextEditingController();
  String _selectedEntryType = 'Milk';
  String _scannedRollNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Mess_Register')),
        backgroundColor: Color.fromARGB(255, 0, 21, 64),
        titleTextStyle: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 0, 26, 79),
        child: const Text(
          'Yashraj_Kadam, 22BDS066',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.italic,
            fontSize: 9,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _scanQRCode,
              child: Text('Scan QR Code'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Roll Number: $_scannedRollNumber',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
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
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _addEntry,
              child: Text('Add Entry'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
            ),
            SizedBox(height: 32.0),
            Image.asset(
              'assets/iiit_dharwad_logo.png',
              height: 115.0,
              width: 115.0,
            ),
          ],
        ),
      ),
    );
  }

  void _scanQRCode() {
    Navigator.push(
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
  }

  void _addEntry() async {
    if (_scannedRollNumber.isNotEmpty && _quantityController.text.isNotEmpty) {
      final rollNumber = _scannedRollNumber;
      final quantity = int.parse(_quantityController.text);
      final type = _selectedEntryType;
      final now = DateTime.now();
      final entry = '$type,$quantity,${now.toString()}';

      try {
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
        final spreadsheet = await gsheets.spreadsheet(
            '1w-VzJr0VEuVndCdt1uq2AlPe_txnB1EYCWsjrSECODM'); // Replace with your own spreadsheet ID
        final sheet = await spreadsheet.worksheetByTitle('Sheet1');

        await sheet?.values
            .appendRow([rollNumber, type, quantity.toString(), now.toString()]);

        _quantityController.clear();
        _scannedRollNumber = ''; // Clear scanned roll number
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Entry added successfully.'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding entry: $e'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please scan a QR code and enter the quantity.'),
        ),
      );
    }
  }
}

class QRViewExample extends StatefulWidget {
  final Function(String) onScannedQRCode;

  const QRViewExample({Key? key, required this.onScannedQRCode})
      : super(key: key);

  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final scannedDataParts = scanData.code!.split(',');
      if (scannedDataParts.length > 3) {
        final rollNumber = scannedDataParts[3];
        widget.onScannedQRCode(rollNumber);
        setState(() {
          controller.pauseCamera();
        });
      }
    });
  }
}
