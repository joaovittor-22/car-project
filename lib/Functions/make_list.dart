import 'package:flutter/material.dart';

makeList(List list){

var listWidget = <Widget>[];

list.forEach((item){
  dynamic name = "";
  dynamic type = "";
  dynamic year = "";
  var engines = [];

      name = item["name"];
      type = item["type"];
      year = item["yearsOfProduction"]?["start"];
      engines = item ["engines"];
      engines.forEach((engine) {
         if (engine["performance_specs"]?["fuel_consumption_economy_urban"] != null){
        dynamic engineInfo = "";
        dynamic urbanConsumption = "";
        dynamic extraUrbanConsumption = "";
        dynamic fuelType = "";
        engineInfo = engine["modification_engine"];
        urbanConsumption = engine["performance_specs"]["fuel_consumption_economy_urban"] ? ["value"];
        extraUrbanConsumption = engine["performance_specs"]["fuel_consumption_economy_extra_urban"] ? ["value"];
       fuelType = engine["performance_specs"]?["fuel_type"];
        urbanConsumption = 100.005/urbanConsumption;
        extraUrbanConsumption =  100.005/extraUrbanConsumption; 
      fuelType.contains("Gasoline") ||fuelType.contains("Petrol")  ? fuelType = "Gasolina" : null;
          var widget =  SizedBox(
          width: double.infinity,
          child:Card(child: 
              Padding(
                padding: const  EdgeInsets.all(16),
                child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Text("$name $type $year",style: const TextStyle(fontSize: 18),),
                 Text("$engineInfo •	$fuelType",style: const  TextStyle(fontSize: 12.8)),
                 Text("Consumo urbano: ${urbanConsumption.toStringAsFixed(2)} km/l "),
                 Text("Consumo Estrada: ${extraUrbanConsumption.toStringAsFixed(2)} km/l"),
              ],) ,)
            ,) );

         listWidget.add(widget);
         }
   
        
      });
});

return listWidget;
}