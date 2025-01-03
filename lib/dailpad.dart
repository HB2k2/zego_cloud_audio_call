import 'package:call_app/variables/dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class DialerScreen extends StatefulWidget {
  const DialerScreen({super.key});

  @override
  State<DialerScreen> createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  final TextEditingController _numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dialer')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 9,
                child: TextField(
                  controller: _numberController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              if (_numberController.text.isNotEmpty)
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      String currentText = _numberController.text;
                      if (currentText.isNotEmpty) {
                        setState(() {
                          _numberController.text =
                              currentText.substring(0, currentText.length - 1);
                        });
                      }
                    },
                    icon: const Icon(Icons.backspace),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                String display;
                if (index < 9) {
                  display = '${index + 1}';
                } else if (index == 9) {
                  display = '*';
                } else if (index == 10) {
                  display = '0';
                } else {
                  display = '#';
                }
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _numberController.text += display;
                    });
                  },
                  child: Card(
                    shape: const CircleBorder(),
                    child: Center(
                        child: Text(display,
                            style: const TextStyle(fontSize: 24))),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // FloatingActionButton(
          //   shape: const CircleBorder(),
          //   onPressed: () {
          //     setState(() {
          //       RecentCallLog.callLog.add(_numberController.text);
          //     });
          //   },
          //   child: const Text('Call'),
          // ),
          sendCallButton(
            isVideoCall: false,
            inviteeUsersIDTextCtrl: _numberController,
            onCallFinished: onSendCallInvitationFinished,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void onSendCallInvitationFinished(
    String code,
    String message,
    List<String> errorInvitees,
  ) {
    RecentCallLog.callLog.add(_numberController.text);
    SharedPreferencesHelper.saveList("recentCallLog", RecentCallLog.callLog);
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
}

Widget sendCallButton({
  required bool isVideoCall,
  required TextEditingController inviteeUsersIDTextCtrl,
  void Function(String code, String message, List<String>)? onCallFinished,
}) {
  return ValueListenableBuilder<TextEditingValue>(
    valueListenable: inviteeUsersIDTextCtrl,
    builder: (context, inviteeUserID, _) {
      var invitees = getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text.trim());

      return ZegoSendCallInvitationButton(
        isVideoCall: isVideoCall,
        invitees: invitees,
        resourceID: "zego_data",
        iconSize: const Size(70, 70),
        buttonSize: const Size(80, 80),
        onPressed: onCallFinished,
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
