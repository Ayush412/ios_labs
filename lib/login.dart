import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'main.dart';
import 'register.dart';
import 'package:page_transition/page_transition.dart';


class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  
  bool visible = false;
  bool emailok = false;
  bool isFilled1 = false;
  TextEditingController usercontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  FocusNode node1 = FocusNode();
  FocusNode node2 = FocusNode();
    void showdialog(){
      print(emailok);
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
  void handle1(String text){
    validate1();
  }
  
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future checklogin() async{
   setState((){
      visible=true;
    });
    String email = usercontroller.text;
    String pass = passcontroller.text;
    FirebaseUser user;

    setState(() {
      visible = true;
    });

    try{
     user =  (await auth.signInWithEmailAndPassword(email: email, password: pass)).user;
    } catch(e){print(e.toString());}
    finally{
      if (user!=null)
      {
          Navigator.push(context,PageTransition(type: PageTransitionType.rightToLeftWithFade, child:home(email)));
      }
      else
      {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("User credentials not found"),
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
      onWillPop: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp())),
    child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('LOGIN PAGE', style: TextStyle(color: Colors.black)),
        toolbarOpacity: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading:  GestureDetector(
              onTap: (){Navigator.push(context,PageTransition(type: PageTransitionType.leftToRightWithFade, child:MyApp()));},
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
            onSubmitted: handle1,
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
            controller: passcontroller,
            focusNode: node2,
            obscureText: true,
            decoration: new InputDecoration(
              hintText: 'Password',)
            )
            ),
            RaisedButton(
     onPressed: () {(emailok==true) ? checklogin() : showdialog();},
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
   GestureDetector(
                      onTap: (){
                        Navigator.push(context,PageTransition(type: PageTransitionType.downToUp, child:register()));
                      },
                      child: Text('Click here to register', style: TextStyle(fontSize: 15.0, color: Colors.grey),)
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