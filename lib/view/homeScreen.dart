import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/controller/homeController.dart';
import 'package:firebase/firebase/firebase.dart';
import 'package:firebase/firebase/notification.dart';
import 'package:firebase/model/Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

FlutterLocalNotificationsPlugin? flnp;

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController txtid = TextEditingController();
  TextEditingController txtname = TextEditingController();
  TextEditingController txtmobile = TextEditingController();
  TextEditingController txtstd = TextEditingController();

  TextEditingController utxtid = TextEditingController();
  TextEditingController utxtname = TextEditingController();
  TextEditingController utxtmobile = TextEditingController();
  TextEditingController utxtstd = TextEditingController();

  HomeController homeController = Get.put(HomeController());

  List<Model> alldata = [];

  void getprofile() async {
    homeController.userdata?.value = await userprofile();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getprofile();
    initnotification();
    fireNotification();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("demo"),
          actions: [
            IconButton(
              onPressed: () {
                logout();
                Get.offNamed('/signin');
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextField(
                style: TextStyle(fontSize: 18),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: txtid,
                decoration: InputDecoration(
                  labelText: "Id",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                style: TextStyle(fontSize: 18),
                textInputAction: TextInputAction.next,
                controller: txtname,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                style: TextStyle(fontSize: 18),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: txtmobile,
                decoration: InputDecoration(
                  labelText: "Mobile",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                style: TextStyle(fontSize: 18),
                textInputAction: TextInputAction.next,
                controller: txtstd,
                decoration: InputDecoration(
                  labelText: "Standard",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  insertdata(
                      txtid.text, txtname.text, txtmobile.text, txtstd.text);
                  txtstd.clear();
                  txtmobile.clear();
                  txtname.clear();
                  txtid.clear();
                },
                child: Text("Submit"),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: readdata(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } else if (snapshot.hasData) {
                      var docList = snapshot.data!.docs;
                      alldata.clear();
                      for (QueryDocumentSnapshot x in docList) {
                        var finaldata = x.data() as Map<String, dynamic>;
                        Model m1 = Model(
                          id: finaldata['id'],
                          name: finaldata['name'],
                          mobile: finaldata['mobile'],
                          std: finaldata['std'],
                          unniqueid: x.id,
                        );
                        alldata.add(m1);
                      }

                      return ListView.builder(
                        itemCount: alldata.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text("${alldata[index].id}"),
                            title: Text("${alldata[index].name}"),
                            subtitle: Text("${alldata[index].unniqueid}"),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: InkWell(
                                      child: Text("update"),
                                      onTap: () {
                                        utxtid = TextEditingController(
                                            text: "${alldata[index].id}");
                                        utxtname = TextEditingController(
                                            text: "${alldata[index].name}");
                                        utxtmobile = TextEditingController(
                                            text: "${alldata[index].mobile}");
                                        utxtstd = TextEditingController(
                                            text: "${alldata[index].std}");
                                        Get.defaultDialog(
                                          title: "Update Data",
                                          titleStyle:
                                              TextStyle(color: Colors.black),
                                          backgroundColor: Colors.white,
                                          content: Column(
                                            children: [
                                              TextField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: utxtid,
                                                keyboardType:
                                                    TextInputType.number,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  hintText: "Id",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .blue.shade900),
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                controller: utxtname,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                  hintText: "Name",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .blue.shade900),
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: utxtmobile,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  hintText: "Mobile No.",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .blue.shade900),
                                                  ),
                                                ),
                                              ),
                                              TextField(
                                                style: TextStyle(
                                                    color: Colors.black),
                                                controller: utxtstd,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration: InputDecoration(
                                                  hintText: "Standard",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .blue.shade900),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  updateData(
                                                      "${alldata[index].unniqueid}",
                                                      utxtid.text,
                                                      utxtname.text,
                                                      utxtmobile.text,
                                                      utxtstd.text);
                                                  Get.back();
                                                },
                                                child: Text("Update"),
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue.shade900),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: Text("Delete"),
                                    onTap: () {
                                      deleteData("${alldata[index].unniqueid}");
                                    },
                                  ),
                                ];
                              },
                              icon: Icon(Icons.more_vert, color: Colors.black),
                            ),
                          );
                        },
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ),

        //**********************Drawer*******************

        drawer: Drawer(
          child: DrawerHeader(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 250,
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  color: Colors.blue,
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: homeController.userdata == null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      homeController.userdata![2] as String),
                                ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        homeController.userdata == null
                            ? Text(
                                "User",
                                style: TextStyle(fontSize: 20),
                              )
                            : Text(
                                "${homeController.userdata![1]}",
                                style: TextStyle(fontSize: 20),
                              ),
                        SizedBox(
                          height: 6,
                        ),
                        Text("${homeController.userdata![0]}",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    AndroidNotificationDetails androidn =
                        AndroidNotificationDetails(
                      "1",
                      "android",
                      priority: Priority.high,
                      importance: Importance.max,
                      sound: RawResourceAndroidNotificationSound('zoro'),
                      playSound: true,
                    );

                    NotificationDetails nd =
                        NotificationDetails(android: androidn);

                    await flnp!.show(1, "Yo!", "Ora Monkey D. Luffy", nd);
                  },
                  child: ListTile(
                    title: Text("Notication"),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 15, bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      logout();
                      Get.offNamed('/signin');
                    },
                    child: Text("Logout"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initnotification() async {
    flnp = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidSetting =
        AndroidInitializationSettings("mugiwara");
    DarwinInitializationSettings iosSetting = DarwinInitializationSettings();

    InitializationSettings flutterSetting =
        InitializationSettings(android: androidSetting, iOS: iosSetting);

    tz.initializeTimeZones();

    await flnp!.initialize(flutterSetting);
  }
}
