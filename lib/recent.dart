// import 'package:call_app/variables/dynamic.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:zego_uikit/zego_uikit.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// class RecentContact extends StatefulWidget {
//   const RecentContact({super.key});

//   @override
//   State<RecentContact> createState() => _RecentContactState();
// }

// class _RecentContactState extends State<RecentContact> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Recents',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(right: 8, left: 8, top: 16, bottom: 8),
//         child: ListView.builder(
//             shrinkWrap: true,
//             reverse: true,
//             itemCount: RecentCallLog.callLog.length,
//             itemBuilder: (context, index) {
//               return Column(
//                 children: [
//                   ListTile(
//                     leading: const Icon(
//                       Icons.account_circle,
//                       size: 40,
//                     ),
//                     title: Text(
//                       RecentCallLog.callLog[index],
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     trailing: sendCallButton(
//                       isVideoCall: false,
//                       inviteeUsersIDTextCtrl: TextEditingController(
//                         text: RecentCallLog.callLog[index],
//                       ),
//                       onCallFinished: onSendCallInvitationFinished,
//                     ),
//                     onLongPress: () => showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: const Text('Delete Item'),
//                         content:
//                             const Text('Are you sure you want to delete ?'),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 RecentCallLog.callLog.removeAt(index);
//                               });
//                               SharedPreferencesHelper.saveList("recentCallLog",
//                                   RecentCallLog.callLog);
//                               Navigator.pop(context);
//                             },
//                             child: const Text('Delete'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.only(left: 60.0, right: 20),
//                     child: Divider(),
//                   ),
//                 ],
//               );
//             }),
//       ),
//     );
//   }

//   void onSendCallInvitationFinished(
//     String code,
//     String message,
//     List<String> errorInvitees,
//   ) {
//     if (errorInvitees.isNotEmpty) {
//       String userIDs = "";
//       for (int index = 0; index < errorInvitees.length; index++) {
//         if (index >= 5) {
//           userIDs += '... ';
//           break;
//         }

//         var userID = errorInvitees.elementAt(index);
//         userIDs += '$userID ';
//       }
//       if (userIDs.isNotEmpty) {
//         userIDs = userIDs.substring(0, userIDs.length - 1);
//       }

//       var message = 'User doesn\'t exist or is offline: $userIDs';
//       if (code.isNotEmpty) {
//         message += ', code: $code, message:$message';
//       }
//       showToast(
//         message,
//         position: StyledToastPosition.top,
//         context: context,
//       );
//     } else if (code.isNotEmpty) {
//       showToast(
//         'code: $code, message:$message',
//         position: StyledToastPosition.top,
//         context: context,
//       );
//     }
//   }

//   Widget sendCallButton({
//     required bool isVideoCall,
//     required TextEditingController inviteeUsersIDTextCtrl,
//     void Function(String code, String message, List<String>)? onCallFinished,
//   }) {
//     return ValueListenableBuilder<TextEditingValue>(
//       valueListenable: inviteeUsersIDTextCtrl,
//       builder: (context, inviteeUserID, _) {
//         var invitees =
//             getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text.trim());

//         return ZegoSendCallInvitationButton(
//           isVideoCall: isVideoCall,
//           invitees: invitees,
//           resourceID: "zego_data",
//           iconSize: const Size(40, 40),
//           buttonSize: const Size(40, 40),
//           onPressed: onCallFinished,
//           onWillPressed: () async {
//             setState(() {
//               RecentCallLog.callLog.add(invitees[0].id);
//               SharedPreferencesHelper.saveList("recentCallLog",RecentCallLog.callLog);
//             });
//             return true;
//           },
//         );
//       },
//     );
//   }

//   List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
//     List<ZegoUIKitUser> invitees = [];

//     var inviteeIDs = textCtrlText.trim().replaceAll('，', '');
//     inviteeIDs.split(",").forEach((inviteeUserID) {
//       if (inviteeUserID.isEmpty) {
//         return;
//       }

//       invitees.add(ZegoUIKitUser(
//         id: inviteeUserID,
//         name: 'user_$inviteeUserID',
//       ));
//     });

//     return invitees;
//   }
// }

import 'dart:developer';

import 'package:call_app/variables/dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class RecentContact extends StatefulWidget {
  const RecentContact({super.key});

  @override
  State<RecentContact> createState() => _RecentContactState();
}

class _RecentContactState extends State<RecentContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recents',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, top: 16, bottom: 8),
        child: ListView.builder(
            shrinkWrap: true,
            reverse: true,
            itemCount: RecentCallLog.callLog.length,
            itemBuilder: (context, index) {
              String phoneNumber = RecentCallLog.callLog[index];
              bool isAvailabe = false;
              String name = "";

              for (var contact in ContactListVar.contacts) {
                if (contact.phoneNumber == phoneNumber) {
                  isAvailabe = true;
                  name = contact.fullName;
                }
              }

              log(name);

              return Column(
                children: [
                  ListTile(
                    leading: isAvailabe
                        ? CircleAvatar(child: Text(name[0].toUpperCase()))
                        : const CircleAvatar(
                            child: Icon(Icons.account_circle,)),
                    title: Text(
                      isAvailabe ? name : phoneNumber,
                      // style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: isAvailabe ? Text(phoneNumber) : null,
                    trailing: sendCallButton(
                      isVideoCall: false,
                      inviteeUsersIDTextCtrl: TextEditingController(
                        text: phoneNumber,
                      ),
                      onCallFinished: onSendCallInvitationFinished,
                    ),
                    onLongPress: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Item'),
                        content:
                            const Text('Are you sure you want to delete ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                RecentCallLog.callLog.removeAt(index);
                              });
                              SharedPreferencesHelper.saveList(
                                  "recentCallLog", RecentCallLog.callLog);
                              Navigator.pop(context);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 60.0, right: 20),
                    child: Divider(),
                  ),
                ],
              );
            }),
      ),
    );
  }

  void onSendCallInvitationFinished(
    String code,
    String message,
    List<String> errorInvitees,
  ) {
    if (errorInvitees.isNotEmpty) {
      String userIDs = "";
      for (int index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        var userID = errorInvitees.elementAt(index);
        userIDs += '$userID ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = 'User doesn\'t exist or is offline: $userIDs';
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }
      showToast(
        message,
        position: StyledToastPosition.top,
        context: context,
      );
    } else if (code.isNotEmpty) {
      showToast(
        'code: $code, message:$message',
        position: StyledToastPosition.top,
        context: context,
      );
    }
  }

  Widget sendCallButton({
    required bool isVideoCall,
    required TextEditingController inviteeUsersIDTextCtrl,
    void Function(String code, String message, List<String>)? onCallFinished,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: inviteeUsersIDTextCtrl,
      builder: (context, inviteeUserID, _) {
        var invitees =
            getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text.trim());

        return ZegoSendCallInvitationButton(
          isVideoCall: isVideoCall,
          invitees: invitees,
          resourceID: "zego_data",
          iconSize: const Size(40, 40),
          buttonSize: const Size(40, 40),
          onPressed: onCallFinished,
          onWillPressed: () async {
            setState(() {
              RecentCallLog.callLog.add(invitees[0].id);
              SharedPreferencesHelper.saveList(
                  "recentCallLog", RecentCallLog.callLog);
            });
            return true;
          },
        );
      },
    );
  }

  List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
    List<ZegoUIKitUser> invitees = [];

    var inviteeIDs = textCtrlText.trim().replaceAll('，', '');
    inviteeIDs.split(",").forEach((inviteeUserID) {
      if (inviteeUserID.isEmpty) {
        return;
      }

      invitees.add(ZegoUIKitUser(
        id: inviteeUserID,
        name: 'user_$inviteeUserID',
      ));
    });

    return invitees;
  }
}

class Contact {
  final String fullName;
  final String phoneNumber;

  const Contact({required this.fullName, required this.phoneNumber});
}
