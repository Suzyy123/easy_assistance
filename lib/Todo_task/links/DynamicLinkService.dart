import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  // Method to create a dynamic link
  Future<Uri> createMeetingLink(String meetingId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://easyassistance.page.link',
      link: Uri.parse('https://easyassistance.page.link/meeting_invitation_link?meetingId=$meetingId'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.easy_assistance_app',  // Replace with your Android package name
        minimumVersion: 1,
      ),
    );

    final Uri dynamicUrl = await FirebaseDynamicLinks.instance.buildLink(parameters);
    return dynamicUrl;
  }
}
