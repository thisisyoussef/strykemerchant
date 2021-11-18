import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:strykepay_merchant/data/device_data.dart';
import 'package:strykepay_merchant/data/user_data.dart';
import 'dart:convert';
import 'package:strykepay_merchant/models/user.dart';
import 'package:strykepay_merchant/models/userModels/new_user.dart';
import 'package:strykepay_merchant/models/institution.dart';
import '../../models.dart';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';

newInfo(BusinessInfoDetails currentUser) async {
  var headers = {
    'Authorization': 'Bearer ${userToken}',
    'Content-Type': 'application/json'
  };
  var request = http.Request(
      'PUT',
      Uri.parse(
          'https://profile.services.strykepay.co.uk/merchant/updateInfo'));
  request.body = json.encode({
    'businessName': userInfo.name,
    'email': userInfo.email,
    "phone": currentUser.number,
    "addressLine": currentUser.addressLine,
    "streetName": "streetName",
    "buildingNumber": "buildingNumber",
    "postCode": currentUser.postcode,
    "county": "county",
    "country": "country",
    "department": "department",
    "supDepartment": "subDepartment",
    "addressType": "addressType",
    "VATNumber": currentUser.VATNumber.isNotEmpty ? currentUser.vatNumber : " "
  });
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    return true;
  } else {
    print(response.reasonPhrase);
    print(await response.stream.bytesToString());

    return false;
  }
}

getUserId() async {
  String token;
  //print("user token is " + userToken);
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
    userInfo.id = decodedData['Merchant']['_id'];
    //userInfo.dob = new DateFormat('MM/DD/yyyy').parse(userInfo.dobString);
    return userInfo.id;
  } else {
    print(userToken);
    print(response.body);
    print(response.statusCode);
    return false;
  }
}

institutionHasOptions(String sortCode) async {
  var response = await http.get(
    Uri.http(
      "institutionfilter.strykepay.co.uk",
      '/institution/institutionFilter',
      {'sortCode': sortCode},
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ${userToken}',
    },
  );
  // print(userInfo.token);
  if (response.statusCode == 200) {
    var decodedData = jsonDecode(response.body);
    print(response.body);
    print("Data check" + sortCode);
    print(decodedData.length);
    try {
      if (decodedData.length > 0) {
        print("woo");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
//    return decodedData[0]['_id'];
  } else {
    print(response.reasonPhrase);
    return false;
    // print(await response.stream.bytesToString());
    return response.reasonPhrase;
  }
}
