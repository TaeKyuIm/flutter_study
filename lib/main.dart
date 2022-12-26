import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:contacts_service/contacts_service.dart";

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Contact> name = [];
  addUser(String givenName, String familyName) {
    var newPerson = new Contact();
    newPerson.givenName = givenName;
    newPerson.familyName = familyName;

    setState(() {
      ContactsService.addContact(newPerson);
      name.add(newPerson);
    });
  }

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      setState(() {
        name = contacts;
      });

      // var newPerson = new Contact();
      // newPerson.givenName = '민수';
      // newPerson.familyName = '김';

      // ContactsService.addContact(newPerson);

    } else if (status.isDenied){
      print('거절됨');
      Permission.contacts.request();
      openAppSettings();
    }
  }

  @override
  void initState() {
    getPermission();
    // TODO: implement initState
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('연락처 어플'), actions: [
          IconButton(onPressed: (){ getPermission(); }, icon: Icon(Icons.contacts))
        ],),
        body: ListView.builder(
          itemCount: name.length,
          itemBuilder: (context, i) {
            return ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(name[i].givenName ?? '이름이 없음')
            );
          }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(context: context, builder: ((context) {
              return DialogUI(addUser: addUser,);
            }));
          },
        ),
      );
  }
}

class DialogUI extends StatelessWidget {
  DialogUI({Key? key, this.addUser }) : super(key: key);
  final addUser;
  var givenName = TextEditingController();
  var familyName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Text('이름'),
            TextField(controller: givenName,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.green,
                  width: 1.0,
                )
              )
            ),),
            Text('성'),
            TextField(controller: familyName,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: (() {
                  addUser(givenName.text, familyName.text);
                  Navigator.pop(context);
                }), child: Text('완료')),
                TextButton(onPressed: () {
                  Navigator.pop(context);
                }, child: Text('취소')),
              ],
            )
          ],
        ),
      ),
    );
  }
}