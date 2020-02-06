import 'package:flutter/material.dart';
import 'login.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class home extends StatefulWidget {

    final String name;
    home(this.name);
  @override
  _homeState createState() => _homeState(name);
}

class _homeState extends State<home> {

 _homeState(this.name);
String name;
String barcodetext='Scan a barcode';
String desc='';
String addedby='';
String username='';
TextEditingController descinp = TextEditingController();
TextEditingController costinp = TextEditingController();
int cost;
int index;
final databaseref = Firestore.instance;

@override
void initState() { 
  super.initState();
  int i=0;
  while(name[i]!='@')
  {
    username+=name[i];
    i+=1;
  }
}

Future getData(String docID) async{
await databaseref
  .collection("barcodes")
  .document(docID)
  .get()
  .then((DocumentSnapshot snap){
    setState(() {
       desc=snap.data['Title'].toString();
       cost=snap.data['Cost'];
       int i=0;
       while(snap.data['AddedBy'].toString()[i] != '@')
       {
        addedby+=snap.data['AddedBy'].toString()[i];
        i+=1;
       }
    });
  });
}

Future addcode(String barcodetext) async {
  return showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder( //give dialogbox rounded corners
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text('Add details for $barcodetext'),
        actions: <Widget>[
                FlatButton(
                  child: new Text("Add"),
                  onPressed: () {
                    addData(barcodetext);
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ],
        content: new Column(
          children: [
            TextField(
              controller: descinp,
              decoration: new InputDecoration(labelText: 'Item description:', icon: Icon(Icons.description)),
            ),
            TextField(
              controller: costinp,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
               WhitelistingTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              decoration: new InputDecoration(labelText: 'Item cost:', icon: Icon(Icons.monetization_on)),
            ),
          ]
        ));
    }
  );
  
  }

Future addData(String docID) async{
  await databaseref
  .collection("barcodes")
  .document(docID)
  .setData({
    'Title':descinp.text,
    'Cost':int.parse(costinp.text),
    'AddedBy':name
  });
  setState(() {
    desc=descinp.text;
    cost=int.parse(costinp.text);
    addedby=name;
  });
}

Future scan(int index) async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => barcodetext = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          barcodetext = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => barcodetext= 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => barcodetext= 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => barcodetext = 'Unknown error: $e');
    }
    if(index==1)
    getData(barcodetext);
    else 
    addcode(barcodetext);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(    //prevent back button accidental touch, has exit app option
      onWillPop: () => showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Warning'),
        shape: RoundedRectangleBorder( //give dialogbox rounded corners
            borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
        content: Text('Do you really want to logout?'),
        actions: [
          FlatButton(
            child: Text('Yes'),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => login())), 
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(c, false),
          ),
        ],
      ),
    ),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text('Welcome ${username.toUpperCase()}', style: TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'Roboto'),),
        backgroundColor: Colors.white,
        elevation: 0.0,
        ),
        body: Center(
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
              GestureDetector(
              onTap: (){Navigator.push(context,PageTransition(type: PageTransitionType.upToDown, child:login()));},
            child: Padding(padding: EdgeInsets.all(12.0),
              child: Image.asset('assets/Back_btn.png', 
              fit: BoxFit.cover,
                )
              )
              ),
              Container( //SCAN code
              width: 200,
              height: 30,
              margin: EdgeInsets.only(top: 40),
              child: IconButton(icon: Icon(Icons.scanner),
              onPressed:() => scan(1),
              ) 
               ),
               Container( //ADD code
              width: 200,
              height: 30,
              margin: EdgeInsets.only(top: 30),
              child: IconButton(icon: Icon(Icons.add),
              onPressed: () => scan(0),
              ) 
               ),
              Container(
              width: 400,
              height: 25,
              margin: EdgeInsets.only(top: 50),
              child: Center(
              child: Text('Code: $barcodetext', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
              )),
              Container(
              width: 400,
              height: 25,
              margin: EdgeInsets.only(top: 30),
              child: Center(
              child: Text('Title: $desc', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              )),
              Container(
              width: 400,
              height: 25,
              margin: EdgeInsets.only(top: 30),
              child: Center(
              child: Text('Cost: $cost', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              )),
              Container(
              width: 400,
              height: 25,
              margin: EdgeInsets.only(top: 30),
              child: Center(
              child: Text('Added By: ${addedby.toUpperCase()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              )),
           ],
           )
        )

      )
      )
    );
  }
}