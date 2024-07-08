import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactInfo {
  final String name;
  final String phoneNumber;

  ContactInfo(this.name, this.phoneNumber);
}

class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  int currentPage = 0;
  final int contactsPerPage = 20;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _loadContacts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMoreContacts();
    }
  }

  Future<void> _loadContacts() async {
    final PermissionStatus permissionStatus =
        await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      await _fetchContacts();
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission to access contacts denied')),
      );
    }
  }

  Future<void> _fetchContacts() async {
    final Iterable<Contact> fetchedContacts = await ContactsService.getContacts(
      withThumbnails: false,
      orderByGivenName: true,
    );

    // Filtrar los contactos que tienen nombre y al menos un número de teléfono
    List<Contact> filteredContacts = fetchedContacts.where((contact) {
      return contact.displayName != null &&
          contact.phones != null &&
          contact.phones!.isNotEmpty &&
          contact.phones!
              .any((phone) => phone.value != null && phone.value!.isNotEmpty);
    }).toList();

    setState(() {
      contacts = filteredContacts.toList();
      isLoading = false;
    });
  }

  Future<void> _loadMoreContacts() async {
    if (!isLoadingMore) {
      setState(() {
        isLoadingMore = true;
      });

      currentPage++;
      int startIndex = currentPage * contactsPerPage;
      int endIndex = startIndex + contactsPerPage;

      if (startIndex < contacts.length) {
        await Future.delayed(Duration(seconds: 1)); // Simular carga
        setState(() {
          isLoadingMore = false;
        });
      } else {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount:
                  (currentPage + 1) * contactsPerPage + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= contacts.length) {
                  if (isLoadingMore) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return SizedBox.shrink();
                  }
                }

                Contact contact = contacts[index];
                return ListTile(
                  title: Text(
                    contact.displayName ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    contact.phones?.isNotEmpty == true
                        ? contact.phones!.first.value ?? ''
                        : '',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {
                    if (contact.phones?.isNotEmpty == true) {
                      final contactInfo = ContactInfo(
                        contact.displayName ?? '',
                        contact.phones!.first.value ?? '',
                      );
                      Navigator.pop(context, contactInfo);
                    }
                    //if (contact.phones?.isNotEmpty == true) {
                    //  Navigator.pop(context, contact.phones!.first.value);
                    //}
                  },
                );
              },
            ),
    );
  }
}
