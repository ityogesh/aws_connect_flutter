import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';
import 'models/ModelProvider.dart';

void main() {
  runApp(MyAWSAmplifyApp());
}

class MyAWSAmplifyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _amplifyConfigured = false;
  String amplifyConfig;
  final _amplify = Amplify;
  var _amplifyID = 'amplifyID';

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    if (!mounted) {
      return;
    }
    final provider = ModelProvider();
    final dataStorePlugin = AmplifyDataStore(modelProvider: provider);
    _amplify.addPlugins([dataStorePlugin]);
    _amplify.configure(amplifyconfig);

    print('Amplify configured !!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AWS AMPLIFY !!'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.all(5.0)),
              /*Text(_amplifyConfigured ? '$amplifyConfig' : '$amplifyConfig;'),
              ElevatedButton(
                  onPressed: _amplifyConfigured ? _recordEvent : null,
                  child: const Text('record event'))*/
              ElevatedButton(
                onPressed: () => create(),
                child: Text('Create'),
                style: ButtonStyle(),
              ),
              ElevatedButton(
                onPressed: () => readAll(),
                child: Text('Read All'),
                style: ButtonStyle(),
              ),
              ElevatedButton(
                onPressed: () => readAllById(),
                child: Text('Read All By ID'),
                style: ButtonStyle(),
              ),
              ElevatedButton(
                onPressed: () => update(),
                child: Text('Update'),
                style: ButtonStyle(),
              ),
              ElevatedButton(
                onPressed: () => delete(),
                child: Text('Delete'),
                style: ButtonStyle(),
              )
            ],
          )
        ],
      ),
    );
  }

  void create() async {
    final amplifyObject = AmplifyTestObject(
        id: _amplifyID,
        value: 'Creating test amplify flutter app first time !!');

    try {
      await Amplify.DataStore.save(amplifyObject);

      print(
          'Saved : ${amplifyObject.toString()}\n JSON : ${amplifyObject.toJson()}');
    } catch (e) {
      print(e);
    }
  }

  void update() async {
    try {
      final amplifyObject = await readAllById();
      final updatedObject = amplifyObject.copyWith(
          value:
              amplifyObject.value + '[UPDATED THE DATA VALUE SUCCESSFULLY !!]');
      await Amplify.DataStore.save(updatedObject);
      print('Updated object : $updatedObject');
    } catch (e) {
      print(e);
    }
  }

  void readAll() async {
    try {
      final amplifyObject =
          await Amplify.DataStore.query(AmplifyTestObject.classType);
      print('Data found in DB : ${amplifyObject.toString()}');
    } catch (e) {
      print(e);
    }
  }

  void delete() async {
    try {
      final deleteObject = await readAllById();
      await Amplify.DataStore.delete(deleteObject);
      print('Deleted Object with ID : ${deleteObject.toString()}');
    } catch (e) {
      print(e);
    }
  }

  Future<AmplifyTestObject> readAllById() async {
    try {
      final amplifyObject = await Amplify.DataStore.query(
          AmplifyTestObject.classType,
          where: AmplifyTestObject.ID.eq(_amplifyID));
      if (amplifyObject.isEmpty) {
        print('No data found with ID : $_amplifyID');
        return null;
      }
      final amplifyDataObject = amplifyObject.first;
      print('Data found in DB By ID : ${amplifyDataObject.toString()}');
      return amplifyDataObject;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
