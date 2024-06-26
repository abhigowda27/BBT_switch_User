import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';
import '../controller/storage_controller.dart';
import '../model/contacts.dart';
import '../model/switches.dart';
import '../model/routers.dart';
import '../utils/constants.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/toast.dart';

class GalleryQRPage extends StatefulWidget {
  const GalleryQRPage({required this.type, super.key});
  final String type;

  @override
  State<GalleryQRPage> createState() => _GalleryQRPageState();
}

class _GalleryQRPageState extends State<GalleryQRPage> {
  String _platformVersion = 'Unknown';
  final StorageController _storageController = StorageController();

  String qrcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
    scanFromGallery();
  }

  scanFromGallery() async {
    XFile? res = (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (res != null) {
      String? str = await Scan.parse(res.path);
      if (str != null) {
        setState(() {
          qrcode = str;
          print("---------------------");
          print(qrcode);
          print("---------------------");
          parseData(qrcode);
        });
      }
    }
  }

  parseData(barcodeScanRes) {
    try {
      List<String> d = barcodeScanRes.split(",");
      print("----------------");
      print(widget.type);
      print("----------------");
      if (widget.type == "switch") {
        if (d.length != 8) throw Exception("Not correct data");
        ContactsModel contacts = ContactsModel(
            accessType: d[5],
            startDateTime: DateTime.tryParse(d[6])!,
            endDateTime: DateTime.tryParse(d[7])!,
            name: d[4]);
        details = SwitchDetails(
            contactsModel: contacts,
            iPAddress: routerIP,
            switchld: d[0],
            isAutoSwitch: false,
            privatePin: "2345",
            switchSSID: d[1],
            switchPassKey: d[2],
            switchPassword: d[3]);
      } else if (widget.type == "router") {
        if (d.length != 9) throw Exception("Not correct data");

        ContactsModel contacts = ContactsModel(
            accessType: d[6],
            startDateTime: DateTime.tryParse(d[7])!,
            endDateTime: DateTime.tryParse(d[8])!,
            name: d[5]);
        routerDetails = RouterDetails(
          switchID: d[0],
          name: d[1],
          password: d[2],
          switchPasskey: d[3],
          iPAddress: d[4],
          contactsModel: contacts,
        );
      }  else {
        print("heello");
      }
    } catch (e) {
      print(e);
      setState(() {
        qrcode = "The QR does not have the right data";
      });
    }
  }

  SwitchDetails? details;
  RouterDetails? routerDetails;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(heading: ""),
      ),
      body: Center(
        child: Column(children: [
          Text(qrcode),
          CustomButton(
              text: "Submit",
              onPressed: () {
                print(qrcode);
                if (qrcode == "Unknown") {
                  showToast(context, "QR data is not correct.");
                  return;
                }
                if (widget.type == "switch") {
                  _storageController.addswitches(context, details!);
                } else {
                  _storageController.addRouters(routerDetails!);
                }
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => const MyNavigationBar(),
                  ),
                  (route) =>
                      false, //if you want to disable back feature set to false
                );
              })
        ]),
      ),
    );
  }
}