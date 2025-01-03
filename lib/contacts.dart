import 'package:call_app/variables/dynamic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  
  List<Contact> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterContacts);
    _loadContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsString = prefs.getString('contacts');
    if (contactsString != null) {
      final contactsJson = jsonDecode(contactsString) as List;
      setState(() {
        ContactListVar.contacts   = contactsJson.map((e) => Contact.fromJson(e)).toList();
        _filteredContacts = ContactListVar.contacts;
      });
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = jsonEncode(ContactListVar.contacts.map((e) => e.toJson()).toList());
    await prefs.setString('contacts', contactsJson);
  }

  void _addContact(String fullName, String phoneNumber) {
    setState(() {
      ContactListVar.contacts.add(Contact(fullName: fullName, phoneNumber: phoneNumber));
      _filteredContacts = ContactListVar.contacts;
    });
    _saveContacts();
    Navigator.of(context).pop();
  }

  void _editContact(int index, String fullName, String phoneNumber) {
    setState(() {
      ContactListVar.contacts[index] = Contact(fullName: fullName, phoneNumber: phoneNumber);
      _filteredContacts = ContactListVar.contacts;
    });
    _saveContacts();
  }

  void _deleteContact(int index) {
    setState(() {
      ContactListVar.contacts.removeAt(index);
      _filteredContacts = ContactListVar.contacts;
    });
    _saveContacts();
  }

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = ContactListVar.contacts
          .where((contact) =>
              contact.fullName.toLowerCase().contains(query) ||
              contact.phoneNumber.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: ContactList(
        _filteredContacts,
        _editContact,
        _deleteContact,
        context: context,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String fullName = "";
              String phoneNumber = "";
              return AlertDialog(
                title: const Text('Add Contact'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      onChanged: (value) {
                        fullName = value;
                      },
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (fullName.isNotEmpty && phoneNumber.isNotEmpty) {
                        _addContact(fullName, phoneNumber);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Contact',
      ),
    );
  }
}

class ContactList extends StatelessWidget {
  final List<Contact> _contacts;
  final Function(int, String, String) onEdit;
  final Function(int) onDelete;
  final BuildContext context;

  const ContactList(this._contacts, this.onEdit, this.onDelete,
      {super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        return ContactTile(
          contact: _contacts[index],
          onEdit: (fullName, phoneNumber) =>
              onEdit(index, fullName, phoneNumber),
          onDelete: () => onDelete(index),
          context: context,
        );
      },
      itemCount: _contacts.length,
    );
  }
}

class ContactTile extends StatelessWidget {
  final Contact contact;
  final Function(String, String) onEdit;
  final Function onDelete;
  final BuildContext context;

  const ContactTile(
      {super.key,
      required this.contact,
      required this.onEdit,
      required this.onDelete,
      required this.context});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(contact.fullName),
      subtitle: Text(contact.phoneNumber),
      leading: CircleAvatar(child: Text(contact.fullName[0])),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String fullName = contact.fullName;
                    String phoneNumber = contact.phoneNumber;
                    return AlertDialog(
                      title: const Text('Edit Contact'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration:
                                const InputDecoration(labelText: 'Full Name'),
                            controller: TextEditingController(text: fullName),
                            onChanged: (value) {
                              fullName = value;
                            },
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                labelText: 'Phone Number'),
                            keyboardType: TextInputType.phone,
                            controller:
                                TextEditingController(text: phoneNumber),
                            onChanged: (value) {
                              phoneNumber = value;
                            },
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (fullName.isNotEmpty && phoneNumber.isNotEmpty) {
                              onEdit(fullName, phoneNumber);
                            }
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                onDelete();
              },
            ),
            sendCallButton(
              isVideoCall: false,
              inviteeUsersIDTextCtrl:
                  TextEditingController(text: contact.phoneNumber),
              onCallFinished: onSendCallInvitationFinished,
            ),
          ],
        ),
      ],
    );
  }

  void onSendCallInvitationFinished(
    String code,
    String message,
    List<String> errorInvitees,
  ) {
    RecentCallLog.callLog.add(contact.phoneNumber);
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

class Contact {
  final String fullName;
  final String phoneNumber;

  const Contact({required this.fullName, required this.phoneNumber});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
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
        iconSize: const Size(30, 30),
        buttonSize: const Size(40, 40),
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
