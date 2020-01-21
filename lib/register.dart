import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'login.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  
  bool visible = false;
  bool isFilled1 = false;
  bool isFilled2 = false;
  bool isFilled3 = false;
  TextEditingController usercontroller = TextEditingController();
  TextEditingController passcontroller1 = TextEditingController();
  TextEditingController passcontroller2 = TextEditingController();
  FocusNode node1 = FocusNode();
  FocusNode node2 = FocusNode();
  FocusNode node3 = FocusNode();
  bool emailok = false;
  bool passok1 = false;
  bool passok2 = false;

  void showdialog(){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Check fields again"),
              shape: RoundedRectangleBorder( //give dialogbox rounded corners
            borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
  }

  bool validate1(){
    if((usercontroller.text.contains(' ') || !usercontroller.text.contains('@') || !usercontroller.text.contains('.')) && usercontroller.text.isNotEmpty && node1.hasPrimaryFocus==false)
      {
        setState(() {
          emailok = false;
        });
        return true;
      }
      else if (usercontroller.text.isEmpty)
      {
        setState(() {
          emailok = false;
        });
        return false;
      }
    else 
      {
      setState(() {
          emailok = true;
        });
      return false;
      }
  }
  bool validatepass(){
    if (passcontroller1.text.contains(' '))
      {
        setState(() {
          passok1 = false;
        });
        return true;
      }
      else if (passcontroller1.text.isEmpty)
     { setState(() {
          passok1 = false;
        });
      return false;
      }
    else 
      {
      setState(() {
          passok1 = true;
        });
      return false;
      }
  }
  bool validateretype(){
    
    if(passcontroller2.text.isEmpty)
    {
      setState(() {
          passok2 = false;
        });
      return false;
    }
    else if (passcontroller1.text!=passcontroller2.text)
      {
        setState(() {
          passok2 = false;
        });
        return true;
      }
    else 
      {
      setState(() {
          passok2 = true;
        });
      return false;
      }
  }
  void passfill(String text){
    setState(() {
              isFilled3=true;
            });
  }
  
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future checklogin() async{
    
  print(emailok);
  print(passok1);
     setState((){
      visible=true;
    });
    String email = usercontroller.text;
    String pass = passcontroller1.text;
    FirebaseUser user;

    try{
     user =  (await auth.createUserWithEmailAndPassword(email: email, password: pass)).user;
    } catch(e){print(e.toString());}
    finally{
      if (user!=null)
      {
          Navigator.push(context, MaterialPageRoute(builder:(context) => home(email)));
      }
      else
      {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("User email already registered"),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      setState((){
      visible=false;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(   
      onWillPop: () => Navigator.push(context, MaterialPageRoute(builder: (context) => login())),
    child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('LOGIN PAGE', style: TextStyle(color: Colors.black)),
        toolbarOpacity: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading:  GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => login()));},
            child: Padding(padding: EdgeInsets.all(12.0),
              child: Image.asset('assets/Back_btn.png', 
              fit: BoxFit.cover,
                )
              )
              ),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(children: <Widget>[
            Padding(padding: const EdgeInsets.all(12.0),
            ),
            Container(
                        width: 280,
                        padding: EdgeInsets.all(10.0),
            child: TextField (autocorrect: true, 
            controller: usercontroller,
            focusNode: node1,
            onEditingComplete: validate1,
            onChanged: (String text){
                            setState((){
                              isFilled1 = text.length>0;
                            });
                          },
            decoration: new InputDecoration(
              hintText: 'Username',
              errorText: validate1() ? 'Enter a valid email' : null)
            ),
            ),
            Container(
                        width: 280,
                        padding: EdgeInsets.all(10.0),
            child: TextField (autocorrect: true, 
            controller: passcontroller1,
            focusNode: node2,
            onChanged: (String text){
                            setState((){
                              isFilled2 = text.length>0;
                            });
                          },
            obscureText: true,
            decoration: new InputDecoration(
              hintText: 'Password',
              errorText: validatepass() ? 'No white spaces allowed' : null
              )
            )
            ),
            Container(
                        width: 280,
                        padding: EdgeInsets.all(10.0),
            child: TextField (autocorrect: true, 
            controller: passcontroller2,
            focusNode: node3,
            onChanged: (String text){
                            setState((){
                              isFilled3 = text.length>0;
                            });
                          },
            obscureText: true,
            onSubmitted: passfill,
            decoration: new InputDecoration(
              hintText: 'Re-type password', 
              errorText: validateretype()? "Passwords don't match" : null,
              ),
            )
            ),
            RaisedButton(
     onPressed: () {(emailok==true && passok1==true && passok2==true) ? checklogin() : showdialog() ;},
     textColor: Colors.white,
     padding: const EdgeInsets.all(0.0),
     shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
     child: Container(
       decoration: const BoxDecoration(
         gradient: LinearGradient(
           colors: <Color>[
             Color(0xFF0D47A1),
             Color(0xFF1976D2),
             Color(0xFF42A5F5),
           ],
         ),
         borderRadius: BorderRadius.all(Radius.circular(80.0))
       ),
       padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
       child: const Text('LOGIN', style: TextStyle(fontSize: 20)
       ),
     ),
   ),
              Visibility(
                        visible: visible,
                        child: Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: CircularProgressIndicator()
                        )
                    ),
          ],
          )
        )
      )  
    )   
    );
  }
}