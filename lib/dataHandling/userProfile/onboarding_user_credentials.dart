import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strykepay_merchant/data/device_data.dart';
import 'package:strykepay_merchant/data/user_data.dart';
import 'dart:convert';
import 'package:strykepay_merchant/models/user.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/models/institution.dart';
import '../../models.dart';
import 'package:strykepay_merchant/main.dart';

String userToken;
BusinessInfoDetails userInfo = BusinessInfoDetails();

signUp(BusinessInfoDetails newUser) async {
  var response = await http.post(
    Uri.parse("https://profile.services.strykepay.co.uk/merchant/signUp"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "businessName": newUser.name,
      "email": newUser.email,
      "password": newUser.password,
      "companyNumber": newUser.companyNumber,
      "phone": " ",
      //  "dob": newUser.dobString,
      "streetName": newUser.streetName,
      "buildingNumber": newUser.buildingNumber,
      "postCode": "XXXX",
      "county": newUser.county,
      "country": newUser.country,
      "department": newUser.department,
      "supDepartment": newUser.supDepartment,
      "addressType": newUser.addressType,
      "addressLine": " ",
      "uniqueId": uniqueId,
    }),
  );
  if (response.statusCode == 200) {
    print(response.headers);
    print(response.body);
    var decodedData = jsonDecode(response.body);
    userToken = decodedData['token'];
    print(userToken);
    return true;
  } else {
    print(response.reasonPhrase);
    print(response.body);
    return response.body;
  }
}

setLoginPin(String email, String pin) async {
  print(email);
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/setLoginPin/$email"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "loginPin": pin,
      "confirmLoginPin": pin,
    }),
  );
  if (response.statusCode == 200) {
    print(response.headers);
    print(response.body);
    return true;
  } else {
    print(response.reasonPhrase);
    print(response.body);
    // print(await response.stream.bytesToString());
    return response.reasonPhrase;
  }
}

addDevice(String email, String pin) async {
  var response = await http.post(
      Uri.parse(
          "https://profile.services.strykepay.co.uk/merchant/addDevice/$email"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "loginPin": pin,
        "os": "IOS",
        "version.securityPatch": "build.version.securityPatch",
        "uniqueId": uniqueId,
        //"os": "Android",
      }));
  if (response.statusCode == 200) {
    print(response.body);
    return true;
  } else {
    print(response.body);
    print(response.statusCode);
    return false;
  }
}

allowDevice(String email, String pin) async {
  var response = await http.put(
      Uri.parse(
          "https://profile.services.strykepay.co.uk/merchant/allowDevice/$email"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "loginPin": pin,
        "uniqueId": uniqueId,
        //"os": "Android",
      }));
  if (response.statusCode == 200) {
    return true;
  } else {
    print(response.body);

    print(response.statusCode);
    return false;
  }
}

login(String email, String password) async {
  var response = await http.post(
    Uri.parse("https://profile.services.strykepay.co.uk/merchant/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "password": password,
      "email": email,
      "uniqueId": uniqueId, //deviceData["id"].toString(),
      //"os": "Android",
    }),
  );
  if (response.statusCode == 200) {
    print(response.body);
    var decodedData = jsonDecode(response.body);
    userToken = decodedData['token'];
    print(userToken);
    return true;
  } else if (response.statusCode == 400) {
    print(response.reasonPhrase);
    print(response.body);
    print("A");

    return 400;
    // print(await response.stream.bytesToString());
  } else if (response.statusCode == 402) {
    print(response.reasonPhrase);
    print(response.body);
    print("A");

    return 402;
    // print(await response.stream.bytesToString());
  } else if (response.statusCode == 401) {
    // print(response.reasonPhrase);
    print(response.body);
    print("A");
    return 401;
    // print(await response.stream.bytesToString());
  } else {
    print(response.body);
    return false;
  }
}

remoteLogout(String email, String pin) async {
  print(pin);
  print(email);
  var response = await http.put(
    Uri.parse(
        "https://profile.services.strykepay.co.uk/merchant/remoteLogout/$email"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(<String, String>{
      "loginPin": pin,
    }),
  );
  if (response.statusCode == 200) {
    print(response.body);
    return true;
  } else {
    print(response.body);
    print(response.statusCode);
    return false;
  }
}

myProfile() async {
  print(userToken);
  print("my profile called");
  var response = await http.get(
    Uri.parse("https://profile.services.strykepay.co.uk/merchant/myProfile"),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    var decodedData;
    decodedData = jsonDecode(response.body);
    print(response.body);
    userInfo.logoUrl = decodedData['Merchant']['logo'];
    userInfo.email = decodedData['Merchant']['email'];
    print("Email is " + userInfo.email);
    userInfo.logoUrl = decodedData["Merchant"]["logo"];
    //print("logo url is " + userInfo.logoUrl);
    userInfo.number = decodedData['Merchant']['phone'];
    userInfo.sortCode =
        decodedData['Merchant']['institution'][0]['institution']['sortCode'];
    userInfo.accountNumber =
        decodedData['Merchant']['institution'][0]['accountNumber'];
    userInfo.companyNumber = decodedData['Merchant']['companyNumber'];
    userInfo.name = decodedData['Merchant']['businessName'];
    userInfo.dobString = decodedData['Merchant']['dob'];
    userInfo.postcode = decodedData['Merchant']['address']['postCode'];
    userInfo.loginPin = decodedData['Merchant']['loginPin'];
    userInfo.id = decodedData['Merchant']['_id'];
    userInfo.addressLine = decodedData['Merchant']["address"]["addressLine"][0];
    userInfo.vatNumber = decodedData['Merchant']["VATNumber"];
    userInfo.userInstitutions.clear();
    for (var inst in decodedData['Merchant']['institution']) {
      userInfo.userInstitutions.add(
        Institution(
          id: inst['_id'],
          logo: inst['institution']['logo'],
          accountNumber: inst['accountNumber'],
          sortCode: inst['institution']['sortCode'],
          institutionID: inst['institution']['_id'],
          name: inst['institution']['name'],
          logoImage: Image.network(inst['institution']['logo']),
        ),
      );
      print("Recorded institution with id :" +
          inst['_id'].toString() +
          inst['institution']['logo'].toString());
    }
    //userInfo.dob = new DateFormat('MM/DD/yyyy').parse(userInfo.dobString);
    return true;
  } else {
    print(response.body);
    print(response.statusCode);
    return false;
  }
}

logout() async {
  var headers = {'Authorization': 'Bearer $userToken'};
  var request = http.Request('PUT',
      Uri.parse('https://profile.services.strykepay.co.uk/merchant/logOut'));
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    return true;
  } else {
    print(response.reasonPhrase);
    return false;
  }
}

loginPin(String pin) async {
  prefs = await SharedPreferences.getInstance();
  print(pin);
  print(userInfo.email.toLowerCase());
  String email;
  if (userInfo.email != null && userInfo.email != "") {
    email = userInfo.email;
  } else {
    email = prefs.getString("email");
    userToken = prefs.getString("token");
  }
  print(prefs.getString("email"));
  print(email);

  var response = await http.get(
    Uri.https(
      "profile.services.strykepay.co.uk",
      "/merchant/loginPin/${email}/$pin",
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    print(response.statusCode);
    print(response.body);

    return true;
  } else {
    print(response.statusCode);

    print(response.body);
    return false;
  }
}
