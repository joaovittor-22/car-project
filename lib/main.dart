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
var tabIndex = 0.obs;
var resultVisible = false.obs;
var resultReact = "".obs;
dynamic resultValue = 0;
dynamic totalKm = 0;
dynamic tanque = 0;  



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
        body: Obx(() {
         return IndexedStack(
          index: tabIndex.value,
          children: [
          FutureBuilder(
          future: api.chamar("car-data.p.rapidapi.com", "/cars/makes",1), //chama api que retorna marcas de carros 
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
        ),
     Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: resultVisible.value,
            child: Column(children: [
                 const Text("O consumo do seu carro é:"),
          Text("${resultReact.value} km/L",style: const TextStyle(fontSize: 28),),
          ],)),
         const  SizedBox(height: 40,),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Quantos km seu carro anda com tanque cheio? ',
                        ),
                        onChanged: (dynamic km) {
                          resultVisible.value = false;
                           km = double.tryParse(km);
                           if (km.runtimeType == double || km.runtimeType == int){
                                    totalKm = km;
                               }
                        }),
                       const  SizedBox(height: 40,),
                       TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Quantos litros seu carro precisa para encher o tanque?',
                        ),
                        onChanged: (dynamic tanqueVar) {
                               resultVisible.value = false;
                               tanqueVar = double.tryParse(tanqueVar);
                               if (tanqueVar.runtimeType == double || tanqueVar.runtimeType == int){
                                    tanque = tanqueVar;
                               }
                        }),
                       const  SizedBox(height: 10,),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(onPressed: (){

                                resultValue = totalKm/tanque;
                                if (resultValue.runtimeType == double ){
                                  resultValue = resultValue.toStringAsFixed(2);
                                }
                                resultReact.value = resultValue;
                                resultVisible.value = true;
                        }, child:const  Text("Calcular")),)
                        

        ],)
        ]);
        },) ,
        bottomNavigationBar: Obx((){
          return  BottomNavigationBar(
        backgroundColor:Colors.red,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        selectedFontSize: 14,
        unselectedFontSize: 10,
        iconSize: 30,
        currentIndex: tabIndex.value,
        onTap: (index){
            tabIndex.value = index;
            resultVisible.value = false;
        },
        items: const [
          BottomNavigationBarItem(
            label: "Consultar consumo",
            icon: Icon(Icons.list),

          ),
          BottomNavigationBarItem(
            label: "Calcular consumo",
            icon: Icon(Icons.calculate),
          ),
        ],
      );
        }),
        );
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
          future: api.chamar("cars-specs-automotive-catalog.p.rapidapi.com", "/api/cars/models/$brand",2), // recebe uma marca e retorna os carros 
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
          future: api.chamar("cars-specs-automotive-catalog.p.rapidapi.com", "/api/cars/full-specs/$brand/$car",2), //passa carro e marca pra a api que retorna epecificações de motor 
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
