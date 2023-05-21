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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.07,
                child: Image.asset(
                  'assets/icons/aaaa.jpg',
                  fit: BoxFit.fill,
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: controller.concerts.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'คอนเสิร์ต',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 0.67,
                            crossAxisSpacing: 5,
                            childAspectRatio: 0.75),
                        primary: true,
                        scrollDirection: Axis.vertical,
                        physics: const ClampingScrollPhysics(),
                        itemCount: controller.concerts.length,
                        itemBuilder: (_, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                          conId:
                                              controller.concerts[index].id)));
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 160,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 244, 245, 246)
                                              .withOpacity(0.7),
                                          Color.fromARGB(255, 245, 246, 247)
                                              .withOpacity(0.01)
                                        ],
                                        begin: AlignmentDirectional.topStart,
                                        //const FractionalOffset(1, 0),
                                        end: AlignmentDirectional.bottomEnd,
                                        stops: [0.1, 0.9],
                                        tileMode: TileMode.clamp),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: Image.network(
                                      controller.concerts[index].cover
                                          .toString(),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                      // Column(
                      //   children: List.generate(
                      //       controller.concerts.length,
                      //       (index) => Card(
                      //             child: Column(
                      //               children: [
                      //                 GestureDetector(
                      //                   onTap: () {
                      //                     Navigator.push(
                      //                         context,
                      //                         MaterialPageRoute(
                      //                             builder: (context) =>
                      //                                 DetailPage(
                      //                                     conId: controller
                      //                                         .concerts[index]
                      //                                         .id)));
                      //                   },
                      //                   child: Container(
                      //                     child: ClipRRect(
                      //                         borderRadius:
                      //                             BorderRadius.circular(8.0),
                      //                         child: Image.network(
                      //                           controller.concerts[index].cover
                      //                               .toString(),
                      //                           fit: BoxFit.fill,
                      //                         )),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           )),
                      // ),
                    ],
                  ),
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
