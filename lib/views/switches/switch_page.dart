import 'dart:async';

import 'package:flutter/material.dart';

import '../../controller/storage_controller.dart';
import '../../model/switches.dart';
import '../../utils/constants.dart';
import '../../widgets/switch_card.dart';
import '../../widgets/toast.dart';
import '../qr/gallery_qr.dart';
import '../qr/qr.dart';
import 'connect_to_switch.dart';

class SwitchPage extends StatelessWidget {
  SwitchPage({super.key});

  final StorageController _storageController = StorageController();

  Future<List<SwitchDetails>> fetchSwitches() async {
    return _storageController.readSwitches();
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
                          builder: (context) => const QRView(type: "switch"),
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
                              const GalleryQRPage(type: "switch"),
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
      //     heading: "SWITCHES",
      //   ),
      // ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: fetchSwitches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) return Text("ERROR ${snapshot.error}");
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (snapshot.data![index].contactsModel.accessType
                            .toString()
                            .contains("Timed Access")) {
                          DateTime now = DateTime.now();
                          DateTime startDate =
                              snapshot.data![index].contactsModel.startDateTime;
                          DateTime endDate =
                              snapshot.data![index].contactsModel.endDateTime;
                          if (snapshot.data![index].contactsModel.accessType
                              .contains("Timed")) {
                            if (now.isAfter(endDate)) {
                              showToast(context,
                                  "You have surpassed the end date. Contact the admin for fresh approval");
                              return;
                            }
                          }
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectToSwitchWidget(
                              switchName: snapshot.data![index].switchSSID,
                              IP: snapshot.data![index].iPAddress,
                              switchID: snapshot.data![index].switchld,
                              switchPassKey:
                                  snapshot.data![index].switchPassKey,
                            ),
                          ),
                        );
                      },
                      child:
                          SwitchesCard(switchesDetails: snapshot.data![index]),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
