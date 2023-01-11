import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:singscan/appService.dart';
import 'package:singscan/constants.dart';
import 'package:singscan/models/concert.dart';
import 'package:singscan/scanApi.dart';
import 'package:singscan/widgets/LoadingDialog.dart';
import 'package:singscan/widgets/cupertinoAlertDialog.dart';

class ScanPage extends StatefulWidget {
  ScanPage(
      {Key? key,
      required this.concertId,
      required this.concertShowId,
      required this.concert})
      : super(key: key);
  String concertId;
  String concertShowId;
  Concert? concert;

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
  @override
  void initState() {
    super.initState();
  }

  Future scan() async {
    try {
      ScanResult _barcode = await BarcodeScanner.scan();
      setState(() {
        barcode = _barcode.rawContent;
      });
      if (barcode != '') {
        //barcode = id ticket
        LoadingDialog.open(context);
        final scan = await ScanApi.getScanTicket(
            barcode, widget.concertId, widget.concertShowId);
        if (scan != null) {
          if (scan['statusCode'] == 200) {
            setState(() {
              data = scan;
              showText = '';
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
            showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoQuestion(
                      title: 'แจ้งเตือน',
                      content: 'ไม่พบตั๋วคอนเสิร์ต',
                      press: () {
                        Navigator.pop(context, true);
                      },
                    ));
          }
        } else {
          LoadingDialog.close(context);
          showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoQuestion(
                    title: 'แจ้งเตือน',
                    content: 'มีผิดพลาดกรุณาติดต่อแอดมิน',
                    press: () {
                      Navigator.pop(context, true);
                    },
                  ));
        }
      } else {
        LoadingDialog.close(context);

        // showCupertinoDialog(
        //     context: context,
        //     builder: (context) => CupertinoQuestion(
        //           title: 'แจ้งเตือน',
        //           content: 'กรุณาสแกนตั๋ว',
        //           press: () {
        //             Navigator.pop(context, true);
        //           },
        //         ));
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        // The user did not grant the camera permission.
        LoadingDialog.close(context);
      } else {
        LoadingDialog.close(context);
        showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoQuestion(
                  title: 'แจ้งเตือน',
                  content: 'มีผิดพลาดกรุณาติดต่อแอดมิน',
                  press: () {
                    Navigator.pop(context, true);
                  },
                ));
        // Unknown error.
      }
    } on FormatException {
      // User returned using the "back"-button before scanning anything.
    } catch (e) {
      LoadingDialog.close(context);
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoQuestion(
                title: 'แจ้งเตือน',
                content: 'ไม่พบคอนเสิร์ต',
                press: () {
                  Navigator.pop(context, true);
                },
              ));
      // Unknown error.
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Row(
          children: [
            SizedBox(
              width: 50,
            ),
            Text(
              'Sing Scan QR',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        // actions: <Widget>[
        //   IconButton(icon: Icon(Icons.camera_alt), onPressed: scan)
        // ],
      ),
      body: SingleChildScrollView(
        child: widget.concert != null
            ? Column(
                children: [
                  Stack(
                    children: [
                      Image.network(
                        widget.concert!.cover ?? '',
                        fit: BoxFit.fitWidth,
                        height: 400,
                        width: double.infinity,
                      ),
                      Positioned.fill(
                          child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(color: Colors.black.withOpacity(0.2)),
                      )),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Center(
                          child: SizedBox(
                            height: 350,
                            child: Center(
                              child: Image.network(
                                widget.concert!.cover.toString(),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Center(
                        child: (showText != '')
                            ? Padding(
                                padding: const EdgeInsets.only(top: 80),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/icons/cancle.png',
                                      fit: BoxFit.fill,
                                      height: size.height * 0.35,
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.symmetric(
                                    //       vertical: size.height * 0.01),
                                    //   child: Text(
                                    //     showText,
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 24,
                                    //         color: Colors.red),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            : Text(
                                '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                      ),
                      SizedBox(height: 14),
                      Center(
                        child: data.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 90),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/icons/success1.png',
                                      fit: BoxFit.fill,
                                      height: size.height * 0.35,
                                    ),
                                    // Padding(
                                    //   padding: EdgeInsets.symmetric(
                                    //       vertical: size.height * 0.03),
                                    //   child: Text(
                                    //     'Success',
                                    //     style: TextStyle(
                                    //         fontWeight: FontWeight.bold,
                                    //         fontSize: 24,
                                    //         color: Colors.green),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            : Text(''),
                      ),
                      SizedBox(height: size.height * 0.03),

                      // InkWell(
                      //   onTap: scan,
                      //   child: Container(
                      //     width: size.width * 0.42,
                      //     height: 50,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(20),
                      //         color: Colors.blue),
                      //     child: Center(
                      //       child: Text(
                      //         'สแกน QR Code',
                      //         style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.white),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      widget.concert!.concertName.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  InkWell(
                    onTap: scan,
                    child: Center(
                      child: CircleAvatar(
                        // backgroundImage: AssetImage(''),
                        backgroundColor: kPrimaryColor,
                        radius: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Center(
                            child: HeroIcon(
                              HeroIcons.qrCode,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )

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
              )
            : SizedBox(),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
