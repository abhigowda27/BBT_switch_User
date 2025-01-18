import 'dart:async';

import 'package:BBTS/widgets/group_m_card.dart';
import 'package:flutter/material.dart';

import '../../controller/matrix_storage.dart';
import '../../model/groups_m.dart';
import '../../utils/constants.dart';
import '../../widgets/toast.dart';
import '../qr_matrix/matrix_gallery_qr.dart';
import '../qr_matrix/matrix_qr.dart';
import 'connect_to_group.dart';

class GroupsMatrixPage extends StatefulWidget {
  GroupsMatrixPage({Key? key}) : super(key: key);

  @override
  State<GroupsMatrixPage> createState() => _GroupsMatrixPageState();
}

class _GroupsMatrixPageState extends State<GroupsMatrixPage> {
  final MatrixStorageController _storageController = MatrixStorageController();

  Future<List<GroupMDetails>> fetchGroups() async {
    return _storageController.readAllGroups();
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
                          builder: (context) => const ScanQr(type: "group"),
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
                              const GalleryQRMPage(type: "group"),
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
      //     heading: "GROUPS M",
      //   ),
      // ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<GroupMDetails>>(
              future: fetchGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("ERROR ${snapshot.error}"));
                }
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
