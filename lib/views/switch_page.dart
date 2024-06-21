import 'dart:async';
import 'package:open_settings/open_settings.dart';
import '../widgets/toast.dart';
import 'package:flutter/material.dart';
import '../controller/storage_controller.dart';
import '../model/switches.dart';
import '../utils/constants.dart';
import '../widgets/switch_card.dart';
import 'connect_to_switch.dart';
import 'gallery_qr.dart';
import 'qr.dart';

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
                      icon: const Icon(Icons.photo_camera),
                    ),
                    const VerticalDivider(
                      color: Colors.black,
                      thickness: 2,
                      endIndent: 20,
                      indent: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const GalleryQRPage(type: "switch"),
                        ));
                      },
                      icon: const Icon(Icons.photo),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    OpenSettings.openWIFISetting();
                  },
                  child: const Icon(Icons.wifi_find),
                  backgroundColor: backGroundColour,
                ),
                const SizedBox(height: 5), // Adjust spacing between buttons
                FloatingActionButton(
                  onPressed: () {
                    OpenSettings.openLocationSourceSetting();
                  },
                  backgroundColor: backGroundColour,
                  child: const Icon(Icons.location_on_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          iconTheme:  IconThemeData(color: appBarColour),
          backgroundColor: backGroundColour,
          automaticallyImplyLeading: false,
          title: Text(
            "Switches",
            style: TextStyle(
              color: appBarColour,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0,
        ),
      ),
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
                if (snapshot.hasError) return const Text("ERROR");

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
                          DateTime startDate = snapshot.data![index]
                              .contactsModel.startDateTime;
                          DateTime endDate = snapshot.data![index].contactsModel
                              .endDateTime;
                          print(startDate);
                          print(endDate);
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
                            builder: (context) =>
                                ConnectToSwitchWidget(
                                  switchName: snapshot.data![index].switchSSID,
                                  IP: snapshot.data![index].iPAddress,
                                  switchID: snapshot.data![index].switchld,
                                  switchPassKey: snapshot.data![index]
                                      .switchPassKey,
                                ),
                          ),
                        );
                      },
                      child: SwitchesCard(
                          switchesDetails: snapshot.data![index]),
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