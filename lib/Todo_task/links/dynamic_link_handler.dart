import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:easy_assistance_app/Pages/homePage.dart';
import 'package:easy_assistance_app/Todo_task/AcceptDenyPage.dart';

class DynamicLinkHandler {
  // Method to initialize and handle dynamic links
  void initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? dynamicLink) {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print('Received dynamic link: $deepLink');
        if (deepLink.queryParameters.containsKey('meetingId')) {
          String meetingId = deepLink.queryParameters['meetingId']!;
          print('Extracted meetingId: $meetingId');

          // Navigate to the AcceptDenyPage with the meetingId from the dynamic link
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AcceptDenyPage(meetingId: meetingId),
            ),
          );
        } else {
          print('Dynamic link does not contain a meetingId parameter. Navigating to HomePage.');
          // Navigate to HomePage if no meetingId is present
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        }
      } else {
        print('No deep link found. Navigating to HomePage.');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    }).onError((error) {
      print('Error in dynamic link: $error. Navigating to HomePage.');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    });

    // Handle initial dynamic link when the app is opened
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = initialLink?.link;

    if (deepLink != null) {
      print('Initial deep link: $deepLink');
      if (deepLink.queryParameters.containsKey('meetingId')) {
        String meetingId = deepLink.queryParameters['meetingId']!;
        print('Extracted meetingId from initial link: $meetingId');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AcceptDenyPage(meetingId: meetingId),
          ),
        );
      } else {
        print('Initial link does not contain a meetingId parameter. Navigating to HomePage.');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } else {
      print('No initial deep link found. Navigating to HomePage.');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }
}
