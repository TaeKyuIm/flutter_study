import 'package:flutter/material.dart';

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
  var name = ['홍길동', '이순신', '장영실'];
  var total = 3;
  addUser(String user) {
    setState(() {
      name.add(user);
      total++;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('연락처 어플')),
        body: ListView.builder(
          itemCount: total,
          itemBuilder: (context, i) {
            return ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(name[i])
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
  var inputData = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextField(controller: inputData,),
            TextButton(onPressed: (() {
              addUser(inputData.text);
              Navigator.pop(context);
            }), child: Text('완료')),
            TextButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text('취소'))
          ],
        ),
      ),
    );
  }
}