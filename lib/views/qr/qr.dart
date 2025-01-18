// import 'package:BBTS/views/home_page.dart';
// import 'package:BBTS/widgets/custom_app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//
// import '../../controller/storage_controller.dart';
// import '../../model/contacts.dart';
// import '../../model/group.dart';
// import '../../model/routers.dart';
// import '../../model/switches.dart';
// import '../../utils/constants.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/toast.dart';
//
// class QRView extends StatefulWidget {
//   const QRView({required this.type, super.key});
//   final String type;
//
//   @override
//   State<QRView> createState() => _QRViewState();
// }
//
// class _QRViewState extends State<QRView> {
//   SwitchDetails? details;
//   RouterDetails? routerDetails;
//   late GroupDetails groupDetails;
//   late String groupName;
//   late String selectedRouter;
//   List<RouterDetails> selectedSwitches = [];
//   late bool exists;
//   @override
//   void initState() {
//     super.initState();
//     scanQR();
//   }
//
//   String _scanBarcode = 'Unknown';
//   final StorageController _storageController = StorageController();
//
//   Future<void> scanQR() async {
//     String barcodeScanRes;
//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           '#ff6666', 'Cancel', true, ScanMode.QR);
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }
//     if (!mounted) return;
//     try {
//       List<String> d = barcodeScanRes.split(",");
//       print("Parsed data: $d");
//       print("Parsed data length: ${d.length}");
//
//       if (widget.type == "switch") {
//         if (d.length != 8) {
//           throw Exception(
//               "Not correct data for switch. Expected 8 but got ${d.length}");
//         }
//         ContactsModel contacts = ContactsModel(
//           accessType: d[5],
//           startDateTime: DateTime.tryParse(d[6])!,
//           endDateTime: DateTime.tryParse(d[7])!,
//           name: d[4],
//         );
//         details = SwitchDetails(
//           contactsModel: contacts,
//           iPAddress: routerIP,
//           switchld: d[0],
//           switchSSID: d[1],
//           switchPassKey: d[2],
//           switchPassword: d[3],
//         );
//       } else if (widget.type == "router") {
//         if (d.length != 10) {
//           throw Exception(
//               "Not correct data for router. Expected 10 but got ${d.length}");
//         }
//         ContactsModel contacts = ContactsModel(
//           accessType: d[7],
//           startDateTime: DateTime.tryParse(d[8])!,
//           endDateTime: DateTime.tryParse(d[9])!,
//           name: d[6],
//         );
//         routerDetails = RouterDetails(
//           switchID: d[0],
//           switchName: d[1],
//           name: d[2],
//           password: d[3],
//           switchPasskey: d[4],
//           iPAddress: d[5],
//           contactsModel: contacts,
//         );
//         setState(() async {
//           exists = await _storageController.isSwitchIDExists(d[0]);
//         });
//       } else if (widget.type == "group") {
//         String preprocessedData =
//             barcodeScanRes.replaceAll(RegExp(r'[\[\]]'), '');
//         List<String> d = preprocessedData.split(",");
//         if (d.length < 12 ||
//             d[0] == "GROUP" ||
//             d[0] == "ROUTER" ||
//             d[0] == "SWITCH") {
//           throw Exception("Not correct data for Group");
//         }
//         groupName = d[0];
//         selectedRouter = d[1];
//         ContactsModel groupContacts = ContactsModel(
//           name: d[d.length - 4],
//           accessType: d[d.length - 3],
//           startDateTime: DateTime.tryParse(d[d.length - 2])!,
//           endDateTime: DateTime.tryParse(d[d.length - 1])!,
//         );
//         for (int i = 2; i < d.length - 4; i += 6) {
//           RouterDetails routerDetails = RouterDetails(
//             switchID: d[i],
//             switchName: d[i + 1],
//             name: d[i + 2],
//             password: d[i + 3],
//             switchPasskey: d[i + 4],
//             iPAddress: d[i + 5],
//             contactsModel: groupContacts,
//           );
//           selectedSwitches.add(routerDetails);
//         }
//         groupDetails = GroupDetails(
//           groupName: groupName,
//           selectedRouter: selectedRouter,
//           selectedSwitches: selectedSwitches,
//           contactsModel: groupContacts,
//         );
//       } else {
//         print("Unknown type");
//       }
//       setState(() {
//         _scanBarcode = barcodeScanRes;
//       });
//     } catch (e) {
//       print(e);
//       setState(() {
//         _scanBarcode = "The QR does not have the right data: ${e.toString()}";
//       });
//     }
//   }
//
//   bool loading = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//           preferredSize: Size.fromHeight(60),
//           child: CustomAppBar(
//             heading: widget.type.toUpperCase(),
//           )),
//       body: Center(
//         child: Column(children: [
//           Text(_scanBarcode),
//           CustomButton(
//               text: "Submit",
//               onPressed: () async {
//                 print(_scanBarcode);
//                 if (_scanBarcode == "Unknown") {
//                   showToast(context, "QR data is not correct.");
//                   return;
//                 }
//                 if (widget.type == "switch") {
//                   _storageController.addSwitches(context, details!);
//                 } else if (widget.type == "router") {
//                   _storageController.addRouters(context, routerDetails!);
//                 } else if (widget.type == "group") {
//                   await _storageController.saveGroupDetails(
//                       context, groupDetails);
//                 }
//                 Navigator.pushAndRemoveUntil<dynamic>(
//                   context,
//                   MaterialPageRoute<dynamic>(
//                     builder: (BuildContext context) => const HomePage(),
//                   ),
//                   (route) => false,
//                 );
//               })
//         ]),
//       ),
//     );
//   }
// }

import 'package:BBTS/views/home_page.dart';
import 'package:BBTS/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../../controller/storage_controller.dart';
import '../../model/contacts.dart';
import '../../model/group.dart';
import '../../model/routers.dart';
import '../../model/switches.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/toast.dart';

class QRView extends StatefulWidget {
  const QRView({required this.type, super.key});
  final String type;

  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  String _scanBarcode = 'Unknown';
  bool loading = false;

  SwitchDetails? switchDetails;
  RouterDetails? routerDetails;
  GroupDetails? groupDetails;

  final StorageController _storageController = StorageController();

  @override
  void initState() {
    super.initState();
    scanQR();
  }

  Future<void> scanQR() async {
    try {
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;

      parseQRData(barcodeScanRes);

      setState(() {
        _scanBarcode = barcodeScanRes;
      });
    } on PlatformException {
      setState(() {
        _scanBarcode = 'Failed to scan QR code.';
      });
    } catch (e) {
      setState(() {
        _scanBarcode = "Invalid QR data: ${e.toString()}";
      });
    }
  }

  void parseQRData(String data) {
    final parts = data.split(",");

    switch (widget.type) {
      case "switch":
        validateData(parts, 8, "Switch");
        switchDetails = SwitchDetails(
          switchld: parts[0],
          switchSSID: parts[1],
          switchPassKey: parts[2],
          switchPassword: parts[3],
          iPAddress: routerIP,
          contactsModel: createContactModel(parts.sublist(4)),
        );
        break;

      case "router":
        validateData(parts, 10, "Router");
        routerDetails = RouterDetails(
          switchID: parts[0],
          switchName: parts[1],
          name: parts[2],
          password: parts[3],
          switchPasskey: parts[4],
          iPAddress: parts[5],
          contactsModel: createContactModel(parts.sublist(6)),
        );
        break;

      case "group":
        parseGroupData(data);
        break;

      default:
        throw Exception("Unknown QR type.");
    }
  }

  void parseGroupData(String data) {
    final cleanedData = data.replaceAll(RegExp(r'[\[\]]'), '');
    final parts = cleanedData.split(",");

    if (parts.length < 12 ||
        parts[0] == "GROUP" ||
        parts[0] == "ROUTER" ||
        parts[0] == "SWITCH") {
      throw Exception("Not correct data for Group");
    }

    final groupContacts = createContactModel(parts.sublist(parts.length - 4));
    final routers = <RouterDetails>[];

    for (int i = 2; i < parts.length - 4; i += 6) {
      routers.add(RouterDetails(
        switchID: parts[i],
        switchName: parts[i + 1],
        name: parts[i + 2],
        password: parts[i + 3],
        switchPasskey: parts[i + 4],
        iPAddress: parts[i + 5],
        contactsModel: groupContacts,
      ));
    }

    groupDetails = GroupDetails(
      groupName: parts[0],
      selectedRouter: parts[1],
      selectedSwitches: routers,
      contactsModel: groupContacts,
    );
  }

  void validateData(List<String> data, int expectedLength, String type) {
    if (data.length != expectedLength) {
      throw Exception(
          "Invalid $type data. Expected $expectedLength fields but got ${data.length}.");
    }
  }

  ContactsModel createContactModel(List<String> parts) {
    return ContactsModel(
      name: parts[0],
      accessType: parts[1],
      startDateTime: DateTime.parse(parts[2]),
      endDateTime: DateTime.parse(parts[3]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: CustomAppBar(
          heading: widget.type.toUpperCase(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(_scanBarcode),
            ),
            CustomButton(
              text: "Submit",
              onPressed: () async {
                if (_scanBarcode == "Unknown") {
                  showToast(context, "QR data is not valid.");
                  return;
                }

                try {
                  if (widget.type == "switch" && switchDetails != null) {
                    _storageController.addSwitches(context, switchDetails!);
                  } else if (widget.type == "router" && routerDetails != null) {
                    _storageController.addRouters(context, routerDetails!);
                  } else if (widget.type == "group" && groupDetails != null) {
                    await _storageController.saveGroupDetails(
                        context, groupDetails!);
                  }
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                } catch (e) {
                  showToast(context, "Failed to save: ${e.toString()}");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
