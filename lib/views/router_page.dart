import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import '../controller/storage_controller.dart';
import '../model/routers.dart';
import '../utils/constants.dart';
import '../widgets/router_card.dart';
import 'connect_to_switch.dart';
import 'gallery_qr.dart';
import 'qr.dart';
import '../widgets/toast.dart';

class RouterPage extends StatelessWidget {
  RouterPage({super.key});
  final StorageController _storageController = StorageController();

  Future<List<RouterDetails>> fetchRouters() async {
    return _storageController.readRouters();
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
                          builder: (context) => const QRView(type: "router"),
                        ));
                      },
                      icon: const Icon(Icons.photo_camera),
                    ),
                    VerticalDivider(
                      color: blackColour,
                      thickness: 2,
                      endIndent: 20,
                      indent: 20,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                          const GalleryQRPage(type: "router"),
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
          iconTheme: IconThemeData(color: appBarColour),
          backgroundColor: backGroundColour,
          automaticallyImplyLeading: false,
          title: Text(
            "ROUTERS",
            style: TextStyle(
                color: appBarColour, fontSize: 35, fontWeight: FontWeight.bold),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0,
        ),
      ),
      // bottomNavigationBar: MyNavigationBar(),
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
                              if (snapshot.data![index].contactsModel.accessType.toString().contains("Timed Access")) {
                                DateTime now = DateTime.now();
                                DateTime startDate = snapshot.data![index].contactsModel.startDateTime;
                                DateTime endDate = snapshot.data![index].contactsModel.endDateTime;
                                print(startDate);
                                print(endDate);
                                if (snapshot.data![index].contactsModel.accessType.contains("Timed")) {
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
                                        IP: snapshot.data![index].iPAddress,
                                        switchName: snapshot.data![index].name,
                                        switchID: snapshot.data![index].switchID,
                                        switchPassKey: snapshot.data![index].switchPasskey,
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
