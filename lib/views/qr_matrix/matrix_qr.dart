import 'package:BBTS/utils/constants.dart';
import 'package:BBTS/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../controller/matrix_storage.dart';
import '../../model/contacts.dart';
import '../../model/groups_m.dart';
import '../../model/router_to_group.dart';
import '../../model/routers_m.dart';
import '../../model/switches_m.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/toast.dart';

class ScanQr extends StatefulWidget {
  const ScanQr({required this.type, super.key});
  final String type;

  @override
  State<ScanQr> createState() => _QRViewState();
}

class _QRViewState extends State<ScanQr> {
  SwitchMDetails? details;
  RouterMDetails? routerDetails;
  late GroupMDetails groupDetails;
  late String groupName;
  late String selectedRouter;
  late String routerPassword;
  List<RouterGDetails> selectedSwitches = [];
  late bool exists;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scanQR();
  }

  String _scanBarcode = 'Unknown';
  final MatrixStorageController _storageController = MatrixStorageController();

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    String scannedData = 'Unknown';

    try {
      String preprocessedData =
          barcodeScanRes.replaceAll(RegExp(r'[\[\]]'), '');
      List<dynamic> d =
          preprocessedData.split(",").map((e) => e.trim()).toList();

      print("Parsed data: $d");
      print("Parsed data length: ${d.length}");

      // Validate type before processing
      if (widget.type == "switch" && (d[0] != "SWITCH")) {
        throw Exception("Invalid data for switch type.");
      } else if (widget.type == "router" && (d[0] != "ROUTER")) {
        throw Exception("Invalid data for router type.");
      } else if (widget.type == "group" && d[0] != "GROUP") {
        throw Exception("Invalid data for group type.");
      }

      // Proceed with parsing based on validated type
      if (widget.type == "switch") {
        ContactsModel contacts = ContactsModel(
          name: d[d.length - 4],
          accessType: d[d.length - 3],
          startDateTime: DateTime.tryParse(d[d.length - 2]) ?? DateTime.now(),
          endDateTime: DateTime.tryParse(d[d.length - 1]) ?? DateTime.now(),
        );

        var selectedTypes = <String>[];
        for (int i = 6; i < d.length - 4; i++) {
          if (d[i].isNotEmpty) {
            selectedTypes.add(d[i]);
          }
        }

        details = SwitchMDetails(
          contactsModel: contacts,
          iPAddress: routerIP,
          switchId: d[1],
          switchSSID: d[2],
          switchPassKey: d[3],
          switchPassword: d[4],
          selectedFan: d[5],
          switchTypes: selectedTypes,
        );
        scannedData = barcodeScanRes;
      } else if (widget.type == "router") {
        ContactsModel contacts = ContactsModel(
          name: d[d.length - 4],
          accessType: d[d.length - 3],
          startDateTime: DateTime.tryParse(d[d.length - 2]) ?? DateTime.now(),
          endDateTime: DateTime.tryParse(d[d.length - 1]) ?? DateTime.now(),
        );

        var selectedTypes = <String>[];
        for (int i = 8; i < d.length - 4; i++) {
          if (d[i].isNotEmpty) {
            selectedTypes.add(d[i]);
          }
        }

        routerDetails = RouterMDetails(
          switchID: d[1],
          switchName: d[2],
          routerName: d[3],
          routerPassword: d[4],
          switchPasskey: d[5],
          selectedFan: d[6],
          iPAddress: d[7],
          contactsModel: contacts,
          switchTypes: selectedTypes,
        );
        _storageController.isSwitchIDExists(d[0]);
        scannedData = barcodeScanRes;
      } else if (widget.type == "group") {
        groupName = d[1];
        selectedRouter = d[2];
        routerPassword = d[3];
        if (groupName.isEmpty || selectedRouter.isEmpty) {
          throw Exception(
              "Invalid group name or router name: Both must be non-empty.");
        }

        ContactsModel groupContacts = ContactsModel(
          name: d[d.length - 4],
          accessType: d[d.length - 3],
          startDateTime: DateTime.tryParse(d[d.length - 2])!,
          endDateTime: DateTime.tryParse(d[d.length - 1])!,
        );

        for (int i = 4; i < d.length - 4; i += 6) {
          RouterGDetails routerDetails = RouterGDetails(
            switchID: d[i],
            switchName: d[i + 1],
            switchPasskey: d[i + 2],
            switchTypes: int.parse(d[i + 3]),
            selectedFan: d[i + 4],
            iPAddress: d[i + 5],
          );
          selectedSwitches.add(routerDetails);
        }

        // for (int i = 4; i < d.length - 4; i += 6) {
        //   String switchID = d[i];
        //   String switchName = d[i + 1];
        //   String switchPasskey = d[i + 2];
        //   int switchTypes;
        //   try {
        //     switchTypes = int.parse(d[i + 3]);
        //   } catch (e) {
        //     throw FormatException("Invalid switchTypes value: ${d[i + 3]}");
        //   }
        //   String selectedFan = d[i + 4];
        //   String ipAddress = d[i + 5];
        //
        //   RouterGDetails routerDetails = RouterGDetails(
        //     switchID: switchID,
        //     switchName: switchName,
        //     switchPasskey: switchPasskey,
        //     switchTypes: switchTypes,
        //     selectedFan: selectedFan,
        //     iPAddress: ipAddress,
        //   );
        //
        //   selectedSwitches.add(routerDetails);
        // }

        groupDetails = GroupMDetails(
          groupName: groupName,
          selectedRouter: selectedRouter,
          routerPassword: routerPassword,
          selectedSwitches: selectedSwitches,
          contactsModel: groupContacts,
        );
        scannedData = barcodeScanRes;
      } else {
        print("Unknown type");
      }
    } catch (e) {
      print(e);
      setState(() {
        scannedData = "The QR does not have the right data: ${e.toString()}";
      });
    }

    setState(() {
      _scanBarcode = scannedData;
    });
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(children: [
          Text(_scanBarcode),
          CustomButton(
              text: "Submit",
              onPressed: () async {
                print(_scanBarcode);
                if (_scanBarcode == "Unknown") {
                  showToast(context, "QR data is not correct.");
                  return;
                }
                if (widget.type == "switch") {
                  _storageController.addSwitches(context, details!);
                } else if (widget.type == "router") {
                  _storageController.addRouters(context, routerDetails!);
                } else if (widget.type == "group") {
                  await _storageController.saveGroupDetails(
                      context, groupDetails);
                }
                print("details>>>>>>>>>>");
                print(details);
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const HomePage(),
                  ),
                  (route) => false,
                );
              })
        ]),
      ),
    );
  }
}
