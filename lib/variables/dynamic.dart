import 'dart:convert'; // For JSON encoding and decoding
import 'package:call_app/contacts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentCallLog{

  static List<String> callLog = [];
}

class ContactListVar {

  static List<Contact> contacts = [];
}

class SharedPreferencesHelper {
  static const String listKey = "myListKey";

  // Save List
  static Future<void> saveList(String listKey, List<String> list) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convert list to JSON string
    String jsonString = jsonEncode(list);
    await prefs.setString(listKey, jsonString);
  }

  // Get List
  static Future<List<String>> getList(String listKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(listKey);

    if (jsonString != null) {
      // Convert JSON string back to List
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.cast<String>();
    }
    return []; // Return empty list if no data found
  }

  // Clear List
  static Future<void> clearList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(listKey);
  }
}




// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// class ContactsPage extends StatefulWidget {
//   @override
//   _ContactsPageState createState() => _ContactsPageState();
// }

// class _ContactsPageState extends State<ContactsPage> {
//   List<Contact> _contacts = [];
//   List<Contact> _filteredContacts = [];
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_filterContacts);
//     _loadContacts();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadContacts() async {
//     final prefs = await SharedPreferences.getInstance();
//     final contactsString = prefs.getString('contacts');
//     if (contactsString != null) {
//       final contactsJson = jsonDecode(contactsString) as List;
//       setState(() {
//         _contacts = contactsJson.map((e) => Contact.fromJson(e)).toList();
//         _filteredContacts = _contacts;
//       });
//     }
//   }

//   Future<void> _saveContacts() async {
//     final prefs = await SharedPreferences.getInstance();
//     final contactsJson = jsonEncode(_contacts.map((e) => e.toJson()).toList());
//     await prefs.setString('contacts', contactsJson);
//   }

//   void _addContact(String fullName, String phoneNumber) {
//     setState(() {
//       _contacts.add(Contact(fullName: fullName, phoneNumber: phoneNumber));
//       _filteredContacts = _contacts;
//     });
//     _saveContacts();
//     Navigator.of(context).pop();
//   }

//   void _editContact(int index, String fullName, String phoneNumber) {
//     setState(() {
//       _contacts[index] = Contact(fullName: fullName, phoneNumber: phoneNumber);
//       _filteredContacts = _contacts;
//     });
//     _saveContacts();
//   }

//   void _deleteContact(int index) {
//     setState(() {
//       _contacts.removeAt(index);
//       _filteredContacts = _contacts;
//     });
//     _saveContacts();
//   }

//   void _filterContacts() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredContacts = _contacts
//           .where((contact) =>
//               contact.fullName.toLowerCase().contains(query) ||
//               contact.phoneNumber.contains(query))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Contacts"),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50.0),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search contacts',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 prefixIcon: const Icon(Icons.search),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: ContactList(_filteredContacts, _editContact, _deleteContact),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               String fullName = "";
//               String phoneNumber = "";
//               return AlertDialog(
//                 title: const Text('Add Contact'),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       decoration: const InputDecoration(labelText: 'Full Name'),
//                       onChanged: (value) {
//                         fullName = value;
//                       },
//                     ),
//                     TextField(
//                       decoration:
//                           const InputDecoration(labelText: 'Phone Number'),
//                       keyboardType: TextInputType.phone,
//                       onChanged: (value) {
//                         phoneNumber = value;
//                       },
//                     ),
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: const Text('Cancel'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       if (fullName.isNotEmpty && phoneNumber.isNotEmpty) {
//                         _addContact(fullName, phoneNumber);
//                       }
//                     },
//                     child: const Text('Add'),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//         child: const Icon(Icons.add),
//         tooltip: 'Add Contact',
//       ),
//     );
//   }
// }

// class ContactList extends StatelessWidget {
//   final List<Contact> _contacts;
//   final Function(int, String, String) onEdit;
//   final Function(int) onDelete;

//   const ContactList(this._contacts, this.onEdit, this.onDelete, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       itemBuilder: (context, index) {
//         return ContactTile(
//           contact: _contacts[index],
//           onEdit: (fullName, phoneNumber) =>
//               onEdit(index, fullName, phoneNumber),
//           onDelete: () => onDelete(index),
//         );
//       },
//       itemCount: _contacts.length,
//     );
//   }
// }

// class ContactTile extends StatelessWidget {
//   final Contact contact;
//   final Function(String, String) onEdit;
//   final Function onDelete;

//   const ContactTile(
//       {required this.contact, required this.onEdit, required this.onDelete});

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: Text(contact.fullName),
//       subtitle: Text(contact.phoneNumber),
//       leading: CircleAvatar(child: Text(contact.fullName[0])),
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: const Icon(Icons.edit, color: Colors.blue),
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     String fullName = contact.fullName;
//                     String phoneNumber = contact.phoneNumber;
//                     return AlertDialog(
//                       title: const Text('Edit Contact'),
//                       content: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           TextField(
//                             decoration:
//                                 const InputDecoration(labelText: 'Full Name'),
//                             controller: TextEditingController(text: fullName),
//                             onChanged: (value) {
//                               fullName = value;
//                             },
//                           ),
//                           TextField(
//                             decoration: const InputDecoration(
//                                 labelText: 'Phone Number'),
//                             keyboardType: TextInputType.phone,
//                             controller:
//                                 TextEditingController(text: phoneNumber),
//                             onChanged: (value) {
//                               phoneNumber = value;
//                             },
//                           ),
//                         ],
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text('Cancel'),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             if (fullName.isNotEmpty && phoneNumber.isNotEmpty) {
//                               onEdit(fullName, phoneNumber);
//                             }
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text('Save'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () {
//                 onDelete();
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.call, color: Colors.green),
//               onPressed: () {
//                 // Add call functionality if needed
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class Contact {
//   final String fullName;
//   final String phoneNumber;

//   const Contact({required this.fullName, required this.phoneNumber});

//   factory Contact.fromJson(Map<String, dynamic> json) {
//     return Contact(
//       fullName: json['fullName'],
//       phoneNumber: json['phoneNumber'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'fullName': fullName,
//       'phoneNumber': phoneNumber,
//     };
//   }
// }
