import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/main.dart';


FirebaseAuth auth = FirebaseAuth.instance;


class Login extends StatelessWidget {
  var _email = "";
  var _pass = "";
  var _pass2 = "";

  @override
  Widget build(BuildContext context) {
    auth.signOut();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Faça seu login"),
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.login),
                    text: "Login",
                  ),
                  Tab(
                    icon: Icon(Icons.app_registration_rounded),
                    text: "Registrar",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                Padding(padding: const  EdgeInsets.all(10),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite seu email',
                        ),
                        onChanged: (email) {
                          _email = email;
                        }),
                        const SizedBox(height: 10,),
                    TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                           border: OutlineInputBorder(),
                            labelText: 'Digite sua senha'),
                        onChanged: (senha) {
                          _pass = senha;
                        }),
                        const SizedBox(height: 10),
                             ElevatedButton(
                              style: ElevatedButton.styleFrom(minimumSize: 
                             const Size(double.infinity, 55)),
                              onPressed: (){
                              if (auth.currentUser != null){
                                Get.to(ListBrands());
                              } else {
                                login(_email, _pass);
                              }
                    
                        }, child: const Text("Login"))
                  ],
                )
                ),
                Padding(padding: const EdgeInsets.all(10),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Digite seu email'),
                        onChanged: (rEmail) {
                             _email = rEmail;
                        }),
                       const SizedBox(height: 10,),
                    TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Digite sua senha'),
                        onChanged: (rPasaword) {
                          _pass = rPasaword;
                        }),
                      const SizedBox(height: 10,),
                    TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Confirme sua senha'),
                        onChanged: (rConfirmPassword) {
                          _pass2 = rConfirmPassword;
                        }),
                     const SizedBox(height: 10,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(minimumSize: 
                             const Size(double.infinity, 55)),
                          onPressed: (){
                                 register(_email, _pass, _pass2);
                        }, child: const Text("Registrar"))
                  ],
                ) ,)
              ],
            )));
  }
}

login(email,String pass)async  {
    var result = false;
   if (pass.isNotEmpty){
      if (auth.currentUser?.uid == null){
try {
   await auth.signInWithEmailAndPassword(email: email, password: pass);
    auth.authStateChanges().listen((user) {
      if (user != null ) {
       FirebaseAuth.instance.setPersistence(Persistence.SESSION);
       result = true;
       Get.to(ListBrands());
      }
    });

  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      notify("Ops","Usuário não cadastrado");
    } 
    else if (e.code == 'wrong-password') {
      notify("Ops","Algo incorreto");
    } 
  }
      }
      else {
         Get.to(ListBrands());
      }
       
    return result;
   }
   
}

register(email,pass,pass2) async {
if (pass == pass2 && pass.length >= 8){

   var firebaseUser = (
   await auth.createUserWithEmailAndPassword(
    email: email,
    password: pass,
  )).user;


  if (firebaseUser != null) {   
     notify("Uhul", "Usuário cadastrado com sucesso");
       Get.to(ListBrands());
    return true;
  }

  else {
    notify("Ops","Este email já está cadastrado ou tente novamente mais tarde");
  }

}
else if (pass.length < 8 ){
    pass.length < 8 &&  pass.length > 1 ? notify("Ops", "Digite uma senha maior"): null;

}
 else {
   notify("Ops", "As senhas devem ser iguais");
 }
}


notify(expression,message){
    Get.snackbar(
              expression,
               message,
               icon: const Icon(Icons.person, color: Colors.white),
               snackPosition: SnackPosition.BOTTOM,
               backgroundColor: const Color.fromARGB(255, 241, 115, 115),
               borderRadius: 20,
               margin: const EdgeInsets.all(15),
               colorText: Colors.white,
               duration: const Duration(seconds: 4),
               isDismissible: true,
               forwardAnimationCurve: Curves.easeOutBack,
               ); 
}