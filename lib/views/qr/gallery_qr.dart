import 'package:BBTS/model/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';

import '../../controller/storage_controller.dart';
import '../../model/contacts.dart';
import '../../model/routers.dart';
import '../../model/switches.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/toast.dart';
import '../home_page.dart';

class GalleryQRPage extends StatefulWidget {
  const GalleryQRPage({required this.type, super.key});
  final String type;

  @override
  State<GalleryQRPage> createState() => _GalleryQRPageState();
}

class _GalleryQRPageState extends State<GalleryQRPage> {
  final StorageController _storageController = StorageController();
  String _scanResult = 'Unknown';
  SwitchDetails? switchDetails;
  RouterDetails? routerDetails;
  GroupDetails? groupDetails;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  Future<void> _initPlatformState() async {
    try {
      String platformVersion = await Scan.platformVersion;
      if (mounted) setState(() {});
    } on PlatformException {
      // Handle platform version error
    }
    _scanFromGallery();
  }

  Future<void> _scanFromGallery() async {
    XFile? res = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (res != null) {
      String? scannedData = await Scan.parse(res.path);
      if (scannedData != null) {
        setState(() {
          _scanResult = scannedData;
          _parseData(scannedData);
        });
      }
    }
  }

  void _parseData(String data) {
    try {
      List<String> parsedData = data.split(",");
      if (widget.type == "switch" && parsedData.length == 8) {
        switchDetails = SwitchDetails(
          contactsModel: ContactsModel(
            accessType: parsedData[5],
            startDateTime: DateTime.parse(parsedData[6]),
            endDateTime: DateTime.parse(parsedData[7]),
            name: parsedData[4],
          ),
          iPAddress: parsedData[0],
          switchld: parsedData[1],
          switchSSID: parsedData[2],
          switchPassKey: parsedData[3],
          switchPassword: parsedData[4],
        );
      } else if (widget.type == "router" && parsedData.length == 10) {
        routerDetails = RouterDetails(
          switchID: parsedData[0],
          switchName: parsedData[1],
          name: parsedData[2],
          password: parsedData[3],
          switchPasskey: parsedData[4],
          iPAddress: parsedData[5],
          contactsModel: ContactsModel(
            accessType: parsedData[7],
            startDateTime: DateTime.parse(parsedData[8]),
            endDateTime: DateTime.parse(parsedData[9]),
            name: parsedData[6],
          ),
        );
      } else if (widget.type == "group") {
        _parseGroupData(parsedData);
      } else {
        throw Exception("Unknown type or incorrect data format.");
      }
    } catch (e) {
      setState(() {
        _scanResult = "The QR does not have the right data";
      });
    }
  }

  void _parseGroupData(List<String> data) {
    if (data.length < 12 || ["GROUP", "ROUTER", "SWITCH"].contains(data[0])) {
      throw Exception("Not correct data for Group");
    }
    String groupName = data[0];
    String selectedRouter = data[1];
    ContactsModel groupContacts = ContactsModel(
      name: data[data.length - 4],
      accessType: data[data.length - 3],
      startDateTime: DateTime.parse(data[data.length - 2]),
      endDateTime: DateTime.parse(data[data.length - 1]),
    );

    List<RouterDetails> selectedSwitches = [];
    for (int i = 2; i < data.length - 4; i += 6) {
      selectedSwitches.add(RouterDetails(
        switchID: data[i],
        switchName: data[i + 1],
        name: data[i + 2],
        password: data[i + 3],
        switchPasskey: data[i + 4],
        iPAddress: data[i + 5],
        contactsModel: groupContacts,
      ));
    }

    groupDetails = GroupDetails(
      groupName: groupName,
      selectedRouter: selectedRouter,
      selectedSwitches: selectedSwitches,
      contactsModel: groupContacts,
    );
  }

  void _handleSubmit() async {
    if (_scanResult == "Unknown") {
      showToast(context, "QR data is not correct.");
      return;
    }

    switch (widget.type) {
      case "switch":
        _storageController.addSwitches(context, switchDetails!);
        break;
      case "router":
        _storageController.addRouters(context, routerDetails!);
        break;
      case "group":
        await _storageController.saveGroupDetails(context, groupDetails!);
        break;
      default:
        showToast(context, "Unknown type.");
    }

    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const HomePage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(heading: widget.type.toUpperCase()),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_scanResult),
            ),
            CustomButton(
              text: "Submit",
              onPressed: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
