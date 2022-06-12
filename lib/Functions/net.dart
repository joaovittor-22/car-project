import 'dart:convert' as convert;
import 'package:http/http.dart' as http;



class Net{
  String  url;    
  dynamic url2;

  Net(this.url,this.url2);

 Future <dynamic> chamar(url,url2,headerCntrl)async {
Map<String, String> headers = {};
if (headerCntrl == 1){
   headers = {
    'X-RapidAPI-Key': '7eb466d5a5msh4838e49cc9ee945p183f39jsn69f7832af908',
    'X-RapidAPI-Host': 'car-data.p.rapidapi.com'
  };
} 
else if (headerCntrl == 2){
     headers = {
    'X-RapidAPI-Key': '7eb466d5a5msh4838e49cc9ee945p183f39jsn69f7832af908',
    'X-RapidAPI-Host': 'cars-specs-automotive-catalog.p.rapidapi.com'
  };
}




 final urlv = Uri.https(
    '$url',
    '$url2',
  );

    final response = await http.get(urlv,headers: headers).then((value){
         return value; 
         } );
     var valor = response.body;                 
        if (response.statusCode == 200 ) {
                return convert.jsonDecode(valor);
    } 
}




}