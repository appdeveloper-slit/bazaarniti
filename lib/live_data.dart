import 'package:flutter/material.dart';
import 'package:flutterx_live_data/flutterx_live_data.dart';

import 'manager/static_method.dart';

// void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  MutableLiveData<bool> bStatus = MutableLiveData(value: false);

  @override
  void initState() {
    super.initState();
    status();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'LiveData',
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LiveDataBuilder<bool>(
                data: bStatus,
                builder: (context, value) {
                  return Text(
                    'Gold value: $value',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<MutableLiveData<bool>> status() async {
    var result = await STM().getWithoutDialog(context, 'status');
    setState(() {
      bStatus.postValue(result['status']);
      debugPrint(bStatus.value.toString());
    });
    return bStatus;
  }
}
