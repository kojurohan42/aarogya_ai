// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/plant.dart';
import 'pages/search_page.dart';

String? message = '';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? use = '';
  late int index;

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();
  dynamic res, thresh, matrix;
  dynamic plant;

  loadData() async {
    final catalogJson = await rootBundle.loadString("assets/catalog.json");
    // final response = await http.get(Uri.parse(url));
    // final catalogJson = response.body;
    final decodedData = jsonDecode(catalogJson);
    var plantsData = decodedData["plants"];
    PlantModel.plants = List.from(plantsData)
        .map<Plant>((item) => Plant.fromMap(item))
        .toList();

    setState(() {});
  }

  Future _getImage() async {
// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
    ].request();
    final pickedImage = await _picker.pickImage(source: ImageSource.camera);
    selectedImage = File(pickedImage!.path);
    _scanImage();
    setState(() {});
  }

  Future _getImageGallery() async {
// You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.mediaLibrary,
    ].request();
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(pickedImage!.path);
    await _scanImage();
    setState(() {});
  }

  _scanImage() async {
    final request = http.MultipartRequest(
        "POST", Uri.parse("https://df48-120-89-104-30.in.ngrok.io/upload"));
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile('image',
        selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
        filename: selectedImage!.path.split("/").last));
    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    message = resJson['message'];
    if (message == "Basale") {
      index = 0;
    } else if (message == "Guava") {
      index = 1;
    } else if (message == "Neem") {
      index = 2;
    } else if (message == "Sandalwood") {
      index = 3;
    } else if (message == "Tulsi") {
      index = 4;
    } else {
      index = 5;
    }
    print(message);
    plant = PlantModel.plants[index];

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Navigate to the Search Screen
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              icon: const Icon(Icons.search))
        ],
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            selectedImage == null
                ? Text("Please pick a image to scan")
                : Column(
                    children: [
                      Container(
                          child: Image.file(
                        selectedImage!,
                        width: 300,
                        height: 150,
                      )),
                      HomeDetail(plant: plant),
                    ],
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: _getImage,
                          child: const Text('Image from Camera'),
                        ),
                        ElevatedButton(
                          onPressed: _getImageGallery,
                          child: const Text('Image from Gallery'),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        tooltip: 'getImage',
        child: const Icon(Icons.add_a_photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// ngrok http 4000
class HomeDetail extends StatelessWidget {
  const HomeDetail({
    Key? key,
    required this.plant,
  }) : super(key: key);
  final Plant plant;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 500,
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  new SliverAppBar(
                    centerTitle: true,
                    backgroundColor: Colors.blue.shade400,
                    title: Text(
                      plant.name,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    automaticallyImplyLeading: false,
                    pinned: true,
                    floating: true,
                    bottom: TabBar(
                      tabs: [
                        Tab(child: Text('About')),
                        Tab(child: Text('Usage')),
                        Tab(child: Text('Growth')),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                children: <Widget>[
                  Text(plant.about),
                  Text(plant.usage),
                  Text(plant.growth),
                ],
              ),
            ),
          ),
        ));
  }
}
