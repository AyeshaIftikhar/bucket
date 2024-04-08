import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController bucket = TextEditingController(),
      region = TextEditingController(),
      subregion = TextEditingController(),
      poolid = TextEditingController();
  String uploaded = '';

  uploadToBucket(String path, String name) async {
    await AmazonS3Cognito.upload(
      path,
      bucket.text,
      poolid.text,
      name,
      region.text,
      subregion.text,
    ).then((value) {
      if (value != '') {
        setState(() {
          uploaded = value!;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image path: $value')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(value ?? '')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (uploaded != '')
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Image.network(uploaded),
                ),
              const Text('Bucket Information'),
              TextFormField(
                controller: bucket,
                decoration: const InputDecoration(labelText: 'Bucket Name'),
              ),
              TextFormField(
                controller: region,
                decoration: const InputDecoration(labelText: 'Region'),
              ),
              TextFormField(
                controller: subregion,
                decoration: const InputDecoration(labelText: 'Sub Region'),
              ),
              TextFormField(
                controller: poolid,
                decoration: const InputDecoration(labelText: 'Pool ID'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ImagePicker()
              .pickImage(source: ImageSource.gallery)
              .then((value) async {
            if (value != null) {
              await uploadToBucket(value.path, value.name);
            }
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}
