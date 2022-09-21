import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:singscan/scanApi.dart';
import 'package:singscan/widgets/LoadingDialog.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final GlobalKey _gLobalkey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String barcode = "";
  String showText = '';
  Map<String, dynamic> data = {};  

  Future scan() async {
    try {
      ScanResult _barcode = await BarcodeScanner.scan();
      setState(() {
        barcode = _barcode.rawContent;
      });
      if (barcode != '') {
        LoadingDialog.open(context);
        final scan = await ScanApi.getScanTicket(barcode);
        if (scan != null) {
          if (scan['statusCode'] == 200) {
            setState(() {
              data = scan;
            });
            LoadingDialog.close(context);
            print('200');
          } else if (scan['statusCode'] == 400) {
            setState(() {
              data.clear();
              showText = scan['message'];
            });
            LoadingDialog.close(context);
          } else {
            print('format barcode not true');
            setState(() {
              data.clear();
              showText = 'ไม่พบตั๋วคอนเสิร์ต';
            });
            LoadingDialog.close(context);
          }
        } else {}
      } else {}
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        // The user did not grant the camera permission.
      } else {
        // Unknown error.
      }
    } on FormatException {
      // User returned using the "back"-button before scanning anything.
    } catch (e) {
      // Unknown error.
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sing Scan QR'),
        // actions: <Widget>[
        //   IconButton(icon: Icon(Icons.camera_alt), onPressed: scan)
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            SizedBox(
              height: size.height * 0.04,
            ),
            Image.asset(
              'assets/icons/logosing.jpg',
              fit: BoxFit.fill,
              height: size.height * 0.25,
            ),
            Center(
              child: (showText != '')
                  ? Column(
                      children: [
                        Image.asset(
                          'assets/icons/cancle.png',
                          fit: BoxFit.fill,
                          height: size.height * 0.25,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.01),
                          child: Text(
                            showText,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      '',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
            ),
            SizedBox(height: 14),
            Center(
              child: data.isNotEmpty
                  ? Column(
                      children: [
                        Image.asset(
                          'assets/icons/success.png',
                          fit: BoxFit.fill,
                          height: size.height * 0.25,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.03),
                          child: Text(
                            'Success',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.green),
                          ),
                        ),
                      ],
                    )
                  : Text(''),
            ),
            SizedBox(height: size.height * 0.03),
            
            
            InkWell(
              onTap: scan,
              child: Container(
                width: size.width*0.42,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue
                ),
                child: Center(
                  child: Text(
                    'สแกน QR Code',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            //HorizontalCoupon(),
            // Container(
            //   height: 100,
            //   width: 200,
            //   child: Center(
            //     child: (result != null)
            //         ? Text(
            //             'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
            //         : Text('Scan a code'),
            //   ),
            // )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
