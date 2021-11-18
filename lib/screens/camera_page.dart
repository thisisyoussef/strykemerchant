import 'package:flutter/material.dart';
import 'package:strykepay_merchant/screens/qr_screen.dart';
import 'package:strykepay_merchant/values/colors.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:strykepay_merchant/widgets/wide_rounded_button.dart';
import 'dart:convert';
import 'package:strykepay_merchant/dataHandling/userProfile/onboarding_user_credentials.dart';

class Collectionpage extends StatefulWidget {
  const Collectionpage({Key key}) : super(key: key);

  @override
  State<Collectionpage> createState() => _CollectionpageState();
}

class _CollectionpageState extends State<Collectionpage> {
  double amount;
  @override
  void initState() {
    myProfile();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Collect",
              style: TextStyle(fontSize: 50),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "How much are you collecting?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 135.0, vertical: 8),
              child: TextFormField(
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.accentElement, width: 5.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0),
                  ),
                ),
                onChanged: (String input) {
                  amount = double.parse(input);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: WideRoundedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QRScreen(amount: amount)),
                  );
                },
                title: "Generate Code",
                isEnabled: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
