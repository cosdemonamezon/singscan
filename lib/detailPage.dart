import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singscan/appController.dart';
import 'package:singscan/constants.dart';
import 'package:singscan/extension/dateExtension.dart';
import 'package:singscan/scanPage.dart';
import 'package:singscan/widgets/LoadingDialog.dart';
import 'dart:ui';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, required this.conId}) : super(key: key);
  String conId;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getConById());
  }

  Future<void> getConById() async {
    LoadingDialog.open(context);
    await context.read<AppController>().getConcertId(widget.conId);
    LoadingDialog.close(context);
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontSize: 16, color: Colors.white);
    final size = MediaQuery.of(context).size;
    return Consumer<AppController>(builder: (context, controller, child) {
      return Scaffold(
        backgroundColor: Color.fromARGB(221, 12, 12, 12),
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
                width: 60,
              ),
              SizedBox(
                height: 100,
                child: Image.asset(
                  'assets/icons/aaaa.jpg',
                  fit: BoxFit.fitHeight,
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: controller.concert != null
                ? Column(
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            controller.concert!.cover.toString(),
                            width: double.infinity,
                            height: 400,
                            fit: BoxFit.fitWidth,
                          ),
                          Positioned.fill(
                              child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child:
                                Container(color: Colors.black.withOpacity(0.2)),
                          )),
                          Padding(
                            padding: const EdgeInsets.only(),
                            child: Center(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: SizedBox(
                                    height: 350,
                                    child: Center(
                                      child: Image.network(
                                        controller.concert!.cover.toString(),
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          controller.concert!.concertName.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('เริ่มขายบัตร', style: style),
                                Text('สิ้นสุดขายบัตร', style: style),

                                // Text('สินสุด ${_concert?.closeSale.formatTo('dd/MM/yyyy HH:mm')}',
                                //     style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.concert!.publicSale!
                                      .formatTo('dd/MM/yyyy HH:mm'),
                                  style: style,
                                ),
                                Text(
                                  controller.concert!.closeSale!
                                      .formatTo('dd/MM/yyyy HH:mm'),
                                  style: style,
                                ),
                                // Text('สินสุด ${_concert?.closeSale.formatTo('dd/MM/yyyy HH:mm')}',
                                //     style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                            controller.concert!.concertShows!.length,
                            (index) => Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Container(
                                    height: size.height * 0.10,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color(0xFFF1EEEE),
                                            width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(4, 0, 4, 4),
                                          child: Icon(
                                            Icons.event_note_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 12),
                                          child: Text(
                                            'วันที่ ${controller.concert!.concertShows![index].showDateTime.formatTo('dd/MM/yyyy')}',
                                            style: style,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                                'เวลา ${controller.concert!.concertShows![index].showDateTime.formatTo('HH:mm')}',
                                                style: style),
                                          ),
                                        ),
                                        // DateTime.now().difference(controller.concert!.publicSale!).inMinutes > 0 &&
                                        // DateTime.now().difference(controller.concert!.closeSale!).inMinutes < 0
                                        Expanded(
                                          flex: 3,
                                          child: InkWell(
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ScanPage(
                                                            concertId:
                                                                controller
                                                                    .concert!
                                                                    .id,
                                                            concertShowId:
                                                                controller
                                                                    .concert!
                                                                    .concertShows![
                                                                        index]
                                                                    .id,
                                                            concert: controller
                                                                .concert,
                                                          )));
                                            },
                                            child: Container(
                                              height: size.height * 0.10,
                                              width: size.width * 0.32,
                                              decoration: BoxDecoration(
                                                color: (kPrimaryColor),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                'แสกนบัตร',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      //   child: InkWell(
                      //     onTap: () {},
                      //     child: Container(
                      //       height: size.height * 0.08,
                      //       width: double.infinity,
                      //       decoration: BoxDecoration(
                      //           border: Border.all(color: Color(0xFFF1EEEE), width: 1.0),
                      //           borderRadius: BorderRadius.circular(15)),
                      //       child: Row(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           Expanded(
                      //             flex: 1,
                      //             child: Icon(
                      //               Icons.location_on_outlined,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //           Expanded(
                      //             flex: 9,
                      //             child: Padding(
                      //               padding: EdgeInsets.only(left: 5),
                      //               child: controller.concert != null ? Text(controller.concert!.stateImg.toString(), style: style) : Text(''),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.all(8.0),
                      //   child: Text(controller.concert!.description ?? '',
                      //       style: style),
                      // ),
                    ],
                  )
                : SizedBox(),
          ),
        ),
      );
    });
  }
}
