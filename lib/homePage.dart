import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:singscan/appController.dart';
import 'package:singscan/detailPage.dart';
import 'package:singscan/scanPage.dart';
import 'package:singscan/widgets/LoadingDialog.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getConcertsList());
  }

  Future<void> _getConcertsList() async {
    LoadingDialog.open(context);
    await context.read<AppController>().getAllConcerts();
    LoadingDialog.close(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<AppController>(builder: (context, controller, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        body: SingleChildScrollView(
          child: controller.concerts.isNotEmpty
              ? Column(
                  children: List.generate(
                      controller.concerts.length,
                      (index) => Card(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                                conId: controller
                                                    .concerts[index].id)));
                                  },
                                  child: Container(
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(controller
                                            .concerts[index].cover
                                            .toString(),height: size.height*0.32, width: double.infinity,fit: BoxFit.fill,)),
                                  ),
                                ),
                              ],
                            ),
                          )),
                )
              : SizedBox(),
          // child: Column(
          //   children: [
          //     SizedBox(height: size.height * 0.05),
          //     Card(
          //       child: Column(
          //         children: [
          //           Text('Nouveautés'),
          //           GestureDetector(
          //             onTap: () {
          //               // Navigator.push(context,
          //               //     MaterialPageRoute(builder: (context) => ScanPage()));
          //             },
          //             child: Container(
          //               child: ClipRRect(
          //                   borderRadius: BorderRadius.circular(15.0),
          //                   child: Image.asset('assets/icons/bansing42.jpg')),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ),
      );
    });
  }
}
