import 'dart:async';

import 'package:flutter/material.dart';

import '../../controller/storage_controller.dart';
import '../../model/group.dart';
import '../../utils/constants.dart';
import '../../widgets/group_card.dart';
import '../../widgets/toast.dart';
import '../qr/gallery_qr.dart';
import '../qr/qr.dart';
import 'connect_to_group.dart';

class GroupingPage extends StatelessWidget {
  GroupingPage({Key? key}) : super(key: key);

  final StorageController _storageController = StorageController();

  // Method to fetch all groups from storage
  Future<List<GroupDetails>> fetchGroups() async {
    return _storageController.readAllGroups();
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
                          builder: (context) => const QRView(type: "group"),
                        ));
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: backGroundColour,
                      ),
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
                              const GalleryQRPage(type: "group"),
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
      //     preferredSize: Size.fromHeight(60),
      //     child: CustomAppBar(
      //       heading: "GROUPS",
      //     )),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<GroupDetails>>(
              future: fetchGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError)
                  return const Center(child: Text("ERROR"));
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Check access type and handle accordingly
                        if (snapshot.data![index].contactsModel.accessType
                            .contains("Timed Access")) {
                          DateTime now = DateTime.now();
                          DateTime startDate =
                              snapshot.data![index].contactsModel.startDateTime;
                          DateTime endDate =
                              snapshot.data![index].contactsModel.endDateTime;
                          print(startDate);
                          print(endDate);
                          if (now.isAfter(endDate)) {
                            showToast(context,
                                "You have surpassed the end date. Contact the admin for fresh approval");
                            return;
                          }
                        }
                        // Navigate to ConnectToGroupWidget
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectToGroupWidget(
                              groupName: snapshot.data![index].groupName,
                              selectedRouter:
                                  snapshot.data![index].selectedRouter,
                              selectedSwitches:
                                  snapshot.data![index].selectedSwitches!,
                            ),
                          ),
                        );
                      },
                      child: GroupCard(groupDetails: snapshot.data![index]),
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
