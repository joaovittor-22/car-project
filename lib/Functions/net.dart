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
    'X-RapidAPI-Key': '',
    'X-RapidAPI-Host': ''
  };
} 
else if (headerCntrl == 2){
     headers = {
    'X-RapidAPI-Key': '',
    'X-RapidAPI-Host': ''
  }; // chaves da api 
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