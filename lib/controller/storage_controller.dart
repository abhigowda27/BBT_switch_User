import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/contacts.dart';
import '../model/switches.dart';
import '../model/routers.dart';
import '../widgets/toast.dart';

class StorageController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  void addContacts(ContactsModel contactsModel) async {
    List<ContactsModel> contactList = await readContacts();
    contactList.add(contactsModel);

    List listContectsInJson = contactList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "contacts", value: json.encode(listContectsInJson));
  }

  deleteContacts() async {
    await storage.delete(key: "contacts");
  }

  deleteRouters() async {
    await storage.delete(key: "routers");
  }

  deleteSwitches() async {
    await storage.delete(key: "switches");
  }

  deleteMacs() async {
    await storage.delete(key: "macs");
  }


  deleteOneContact(ContactsModel contactsModel) async {
    List<ContactsModel> contactList = await readContacts();
    contactList.removeWhere((element) => element.name == contactsModel.name);
    // for (var element in contactList) {
    //   if(element.name == contactsModel.name){}
    // }
    // contactList.(contactsModel);
    List listContectsInJson = contactList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "contacts", value: json.encode(listContectsInJson));
  }

  Future<List<ContactsModel>> readContacts() async {
    String? contacts = await storage.read(key: "contacts");
    List<ContactsModel> model = [];
    if (contacts == null) {
      List listContectsInJson = model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "contacts", value: json.encode(listContectsInJson));
    } else {
      model = [];
      var jsonContacts = json.decode(contacts);
      for (var element in jsonContacts) {
        model.add(ContactsModel.fromJson(element));
      }
    }
    return model;
  }

  Future<List<SwitchDetails>> readSwitches() async {
    String? switches = await storage.read(key: "switches");
    List<SwitchDetails> model = [];
    if (switches == null) {
      List listContectsInJson = model.map((e) {
        return e.toJson();
      }).toList();
      print(json.encode(listContectsInJson));
      storage.write(key: "switches", value: json.encode(listContectsInJson));
    } else {
      model = [];
      var jsonContacts = json.decode(switches);
      print(json.encode(jsonContacts));
      for (var element in jsonContacts) {
        model.add(SwitchDetails.fromJson(element));
      }
    }
    return model;
  }

  deleteOneSwitch(SwitchDetails switchDetails) async {
    List<SwitchDetails> switchList = await readSwitches();
    switchList.removeWhere((element) => element.switchSSID == switchDetails.switchSSID);
    List listContectsInJson = switchList.map((e) {
      return e.toJson();
    }).toList();
    deleteSwitches();
    storage.write(key: "switches", value: json.encode(listContectsInJson));
  }

  updateSwitch(BuildContext context, String idOfSwitch, String newSwitchId, String newSwitchSSID, String newSwitchPassword) async {
    List<SwitchDetails> switchesList = await readSwitches();
    print(switchesList.length);
    deleteSwitches();
    for (var element in switchesList) {
      if (element.switchld == idOfSwitch) {
        element.switchld = newSwitchId;
        element.switchPassword = newSwitchPassword;
        element.switchSSID = newSwitchSSID;
        break;
      }
      print(switchesList.length);
    }
    for (var element in switchesList) {
      addswitches(context, element);
    }
  }

  updateSwitchAutoStatus(BuildContext context, String switchname, bool status) async {
    List<SwitchDetails> switchesList = await readSwitches();
    deleteSwitches();
    for (var element in switchesList) {
      if (element.switchSSID == switchname) {
        element.isAutoSwitch = status;
        break;
      }
    }
    for (var element in switchesList) {
      addswitches(context, element);
    }
  }


  getSwitchBySSID(switchSSID) async {
    List<SwitchDetails> switchesList = await readSwitches();
    for (var element in switchesList) {
      if (element.switchSSID == switchSSID) return element;
    }
    return null;
  }

  getRouterByName(switchSSID) async {
    List<RouterDetails> routerList = await readRouters();
    for (var element in routerList) {
      if (element.name == switchSSID) return element;
    }
    return null;
  }

  getContactByPhone(phone) async {
    List<ContactsModel> switchesList = await readContacts();
    for (var element in switchesList) {
      if (element.name == phone) return element;
    }
    return null;
  }


  Future<bool> isSwitchSSIDExists(String switchSSID) async {
    List<SwitchDetails> switchesList = await readSwitches();
    for (var switchDetails in switchesList) {
      if (switchDetails.switchSSID == switchSSID) {
        return true;
      }
    }
    return false;
  }

  void addswitches(BuildContext context, SwitchDetails switchDetails) async {
    bool exists = await isSwitchSSIDExists(switchDetails.switchSSID);
    if (exists) {
      showToast(context, "Switch Name already exists.");
      return;
    }
    List<SwitchDetails> switchesList = await readSwitches();
    switchesList.add(switchDetails);

    List listContectsInJson = switchesList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "switches", value: json.encode(listContectsInJson));
  }

  Future<List<RouterDetails>> readRouters() async {
    String? switches = await storage.read(key: "routers");
    List<RouterDetails> model = [];
    if (switches == null) {
      List listContectsInJson = model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "routers", value: json.encode(listContectsInJson));
    } else {
      model = [];
      var jsonContacts = json.decode(switches);
      print(json.encode(jsonContacts));

      for (var element in jsonContacts) {
        model.add(RouterDetails.fromJson(element));
      }
    }
    return model;
  }

  deleteOneRouter(RouterDetails switchDetails) async {
    List<RouterDetails> switchList = await readRouters();
    switchList.removeWhere((element) => element.switchID == switchDetails.switchID);
    List listContectsInJson = switchList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "routers", value: json.encode(listContectsInJson));
  }

  void addRouters(RouterDetails routerDetails) async {
    List<RouterDetails> switchesList = await readRouters();
    switchesList.add(routerDetails);
    List listContectsInJson = switchesList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "routers", value: json.encode(listContectsInJson));
  }

  // Future<List<MacsDetails>> readMacs() async {
  //   String? switches = await storage.read(key: "macs");
  //   List<MacsDetails> _model = [];
  //   if (switches == null) {
  //     List listContectsInJson = _model.map((e) {
  //       return e.toJson();
  //     }).toList();
  //     storage.write(key: "macs", value: json.encode(listContectsInJson));
  //   } else {
  //     _model = [];
  //     var jsonContacts = json.decode(switches);
  //     for (var element in jsonContacts) {
  //       _model.add(MacsDetails.fromJson(element));
  //     }
  //   }
  //   return _model;
  // }

  // deleteOneMacs(MacsDetails switchDetails) async {
  //   List<MacsDetails> switchList = await readMacs();
  //   switchList.removeWhere((element) => element.id == switchDetails.id);
  //   List listContectsInJson = switchList.map((e) {
  //     return e.toJson();
  //   }).toList();
  //   storage.write(key: "macs", value: json.encode(listContectsInJson));
  // }

  // updateMacStatus(MacsDetails switchDetails) async {
  //   await deleteOneMacs(switchDetails);
  //   addmacs(switchDetails);
  // }

  // void addmacs(MacsDetails switchDetails) async {
  //   List<MacsDetails> switchesList = await readMacs();
  //   switchesList.add(switchDetails);

  //   List listContectsInJson = switchesList.map((e) {
  //     return e.toJson();
  //   }).toList();
  //   storage.write(key: "macs", value: json.encode(listContectsInJson));
  // }
}
