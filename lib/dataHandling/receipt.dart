import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';
import 'package:strykepay_merchant/models/receipt.dart';
import 'dart:convert';

getAllReceipts() async {
  String token = userToken;
  print(userToken);
  var response = await http.get(
    Uri.https(
      "profile.services.strykepay.co.uk",
      '/merchant/allReceipts',
    ),
    headers: <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $userToken',
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  print(response.body);
  if (response.statusCode == 200) {
    List<Receipt> receipts = [];
    print(response.body);
    var decodedData = jsonDecode(response.body);
    print("DATA IS " + decodedData.toString());
    print(decodedData.length);
    userInfo.userReceipts.clear();
    print(response.body);
    for (var receipt in decodedData) {
      print("The id is " + receipt["payer"]);
      receipts.add(Receipt(
          BUSINESSNAME: receipt['payee']['businessName'],
          ID: receipt["_id"],
          PAYER: receipt["payer"],
          PAYEE: receipt["payeee"],
          AMOUNT: receipt['amount'],
          DESCRIPTION: receipt["description"],
          TIP: double.parse(receipt["tip"].toString()),
          TRANSACTIONNUMBER: receipt["transactionNumber"],
          TRANSACTION: receipt["transaction"],
          DATE: receipt["date"],
          TOTALAMOUNT: receipt["totalAmount"],
          //payerSortCode: receipt["payerBank"]["sortCode"],
          //payerAccountNumber: receipt["payerBank"]["accountNumber"],
          // payeeSortCode: receipt["payeeBank"]["sortCode"],
          //payeeAccountNumber: receipt["payeeBank"]["accountNumber"],
          CREATEDAT: receipt["createdAt"],
          UPDATEDAT: receipt["updatedAt"],
          V: 0));
    }
    return receipts;
  } else {
    print("The error is " + response.body);
    List<Receipt> receipts = [];
    return receipts;
  }
}
