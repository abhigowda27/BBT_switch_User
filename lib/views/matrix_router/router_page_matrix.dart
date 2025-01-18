import 'dart:async';

import 'package:BBTS/widgets/router_m_card.dart';
import 'package:flutter/material.dart';

import '../../controller/matrix_storage.dart';
import '../../model/routers_m.dart';
import '../../utils/constants.dart';
import '../../widgets/toast.dart';
import '../qr_matrix/matrix_gallery_qr.dart';
import '../qr_matrix/matrix_qr.dart';
import 'connect_to_router.dart';

class RouterMatrixPage extends StatefulWidget {
  RouterMatrixPage({super.key});

  @override
  State<RouterMatrixPage> createState() => _RouterMatrixPageState();
}

class _RouterMatrixPageState extends State<RouterMatrixPage> {
  final MatrixStorageController _storageController = MatrixStorageController();

  Future<List<RouterMDetails>> fetchRouters() async {
    return _storageController.readRouters();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 70,
              width: 180,
              child: FloatingActionButton.large(
                backgroundColor: appBarColour,
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ScanQr(type: "router"),
                        ));
                      },
                      icon: Icon(Icons.camera_alt_outlined,
                          color: backGroundColour),
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                      thickness: 2,
                      endIndent: 20,
                      indent: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const GalleryQRMPage(type: "router"),
                        ));
                      },
                      icon: Icon(Icons.image_outlined, color: backGroundColour),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // appBar: const PreferredSize(
      //   preferredSize: Size.fromHeight(60),
      //   child: CustomAppBar(
      //     heading: "ROUTERS M",
      //   ),
      // ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: fetchRouters(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("ERROR: ${snapshot.error}"));
                    }

                    return ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (snapshot
                                  .data![index].contactsModel!.accessType
                                  .toString()
                                  .contains("Timed Access")) {
                                DateTime now = DateTime.now();
                                //DateTime? startDate = snapshot.data![index].contactsModel?.startDateTime;
                                DateTime? endDate = snapshot
                                    .data![index].contactsModel?.endDateTime;
                                if (snapshot
                                    .data![index].contactsModel!.accessType
                                    .contains("Timed")) {
                                  if (now.isAfter(endDate!)) {
                                    showToast(context,
                                        "You have surpassed the end date. Contact the admin for fresh approval");
                                    return;
                                  }
                                }
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConnectToRouterPage(
                                            routerDetails:
                                                snapshot.data![index],
                                          )));
                            },
                            child: RouterCard(
                                routerDetails: snapshot.data![index]),
                          );
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
