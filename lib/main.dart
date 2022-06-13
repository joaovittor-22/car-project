import 'package:flutter/material.dart';
import 'Functions/net.dart';
import "package:get/get.dart";
import 'Functions/make_list.dart';
import 'Screens/login.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

var api = Net("", "");
var brand = "";
var car = "carro";
void main() async  {
     WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: Login(),
    );
  }
}


class ListBrands extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const  Text("Consulte o consumo de algum carro"),
        ),
        body: FutureBuilder(
          future: api.chamar("car-data.p.rapidapi.com", "/cars/makes",1),
          builder: (context, snapshot) {
            if (snapshot.hasData == true) {
              dynamic list = snapshot.data;
              list?.toList();
              return Column(
                children: <Widget>[
                  Container(
                    color: Colors.amber,
                    alignment: Alignment.center,
                    height: 100,
                    child: const Text('Selecione uma marca',
                        style: TextStyle(fontSize: 18)),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                               brand= list[index];
                            Get.to(_ListCars());
                             },
                              child: Card(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.red[50],
                                    width: double.infinity,
                                    height: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(list[index]),
                                    )),
                              ),
                            );
                          }))
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
    }
}

class _ListCars extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const  Text("Consulte o consumo de algum carro"),
      ),
      body:
      FutureBuilder(
          future: api.chamar("cars-specs-automotive-catalog.p.rapidapi.com", "/api/cars/models/$brand",2),
          builder: (context, snapshot) {
        
            if (snapshot.hasData == true) {   
              dynamic listCars = snapshot.data;
              listCars = listCars["data"]?[0]?["models"].toList();
     return Column(
        children: <Widget>[
            Container(
                    color: Colors.amber,
                    alignment: Alignment.center,
                    height: 100,
                    child: const Text('Selecione um carro',
                        style: TextStyle(fontSize: 18)),
                  ),
          Expanded(child:     ListView.builder(
              itemCount: listCars.length,
              itemBuilder: (context, index) {
                return  InkWell(
                              onTap: () {
                                car = listCars[index];
                                Get.to(_ListModelsCar());
                             },
                              child: Card(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    color: Colors.red[50],
                                    width: double.infinity,
                                    height: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Text(listCars[index]),
                                    )),
                              ),
                            );
              }))
      
        ],
      );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
     
    );
  }
}

class _ListModelsCar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Versões $brand - $car "),
      ),
      body:   FutureBuilder(
          future: api.chamar("cars-specs-automotive-catalog.p.rapidapi.com", "/api/cars/full-specs/$brand/$car",2),
          builder: (context, snapshot) {
            if (snapshot.hasData == true) {   
              dynamic listModels = snapshot.data;
                listModels= listModels ["data"]?["generations"].toList();
           return SingleChildScrollView(
              child:  Column(
        children: makeList(listModels)
      ));

            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }
}