import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'District.dart';
import 'Services.dart';
import 'DistrictMaterial.dart';

class LoginUser extends StatefulWidget {
 
LoginUserState createState() => LoginUserState();
 
}
 
class LoginUserState extends State {
 
  // For CircularProgressIndicator.
  bool visible = false ;
 
  // Getting value from TextField widget.
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  //final departmentCodeController = TextEditingController();
 
Future userLogin() async{
 
  // Showing CircularProgressIndicator.
  setState(() {
  visible = true ; 
  });
 
  // Getting value from Controller
  String username = usernameController.text;
  String password = passwordController.text;

  // SERVER LOGIN API URL
  var url = 'http://192.168.1.11/auth/login';
 
  // Store all data with Param Name.
  //var data = {'email': username, 'password' : password};
  var map = Map<String, dynamic>();
  map['username'] = username;
  map['password'] = password;
  // Starting Web API Call.
  var response = await http.post(url, body: map);
  // Getting Server response into variable.
  var message = jsonDecode(response.body);
  //message = message['message'];
  print(message);  
  // If the Response Message is Matched.
  if(message['message'] == 'Success')
  {
      var deptcode = message['deptcode'] as int;
    // Hiding the CircularProgressIndicator.
      setState(() {
      visible = false; 
      });
    // Navigate to Profile Screen & Sending Email to Next Screen.
      //Navigator.push(
        //context,
        //MaterialPageRoute(builder: (context) => DistrictMaterials(username : usernameController.text, departmentcode : deptcode)),
      //);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DistrictMaterials(username : usernameController.text, departmentcode : deptcode)),
      );
  }else{
 
    // If Email or Password did not Matched.
    // Hiding the CircularProgressIndicator.
    setState(() {
      visible = false; 
      });
 
    // Showing Alert Dialog with Response JSON Message.
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(message['message']),
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
    );}
 
}
 
@override
Widget build(BuildContext context) {
return Scaffold(
  body: SingleChildScrollView(
    child: Center(
    child: Column(
      children: <Widget>[
 
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text('User Login Form', 
                  style: TextStyle(fontSize: 21))),
 
        Divider(),          
 
        Container(
        width: 280,
        padding: EdgeInsets.all(10.0),
        child: TextField(
            controller: usernameController,
            autocorrect: true,
            decoration: InputDecoration(hintText: 'Enter Username'),
          )
        ),
 
        Container(
        width: 280,
        padding: EdgeInsets.all(10.0),
        child: TextField(
            controller: passwordController,
            autocorrect: true,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Enter Password'),
          )
        ),
 
        RaisedButton(
          onPressed: userLogin,
          color: Colors.blue,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
          child: Text('Login'),
        ),
 
        Visibility(
          visible: visible, 
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            child: CircularProgressIndicator()
            )
          ),
 
      ],
    ),
  )));
}
}

class DistrictMaterials extends StatefulWidget {
  //DistrictMaterial({String departmentcode, String email}) : super();
  final String username;
  final int departmentcode;
  DistrictMaterials({Key key, @required this.username, @required this.departmentcode}) : super(key: key);
  final String title = 'District Materials';
  @override
  //State<StatefulWidget> createState() {
  // TODO: implement createState
  //return null;
  //}
  DistrictMaterialState createState() => DistrictMaterialState(username, departmentcode);
}

class DistrictMaterialState extends State<DistrictMaterials> {
  List<DistrictMaterial> _districtMaterial;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _firstFieldController;
  TextEditingController _secondFieldController;
  DistrictMaterial _selectedDistrictMaterial;
  bool _isUpdating;
  String _titleProgess;
  final int departmentcode;
  final String username;
  DistrictMaterialState(this.username, this.departmentcode);
  @override
  void initState() {
    super.initState();
    _districtMaterial = [];
    _isUpdating = false;
    _titleProgess = widget.title;
    _scaffoldKey = GlobalKey();
    _firstFieldController = TextEditingController();
    _secondFieldController = TextEditingController();
    _getDistrictMaterials();
  }

    // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgess = message;
    });
  }

  //Method to clear TextField values
  _clearValues() {
    _firstFieldController.text = '';
    _secondFieldController.text = '';
  }

    _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _getDistrictMaterials() {
    _showProgress('Loading District Materials...');
    //print(departmentcode);
    Services.getDistrictMaterials(departmentcode.toString()).then((districtMaterials){
      setState((){
        print(districtMaterials);
        _districtMaterial = districtMaterials;
      });
      _showProgress(widget.title);
    });
  }

  _updateDistrictMaterial(DistrictMaterial districtMaterial){
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating District Material....');
    print(districtMaterial.id);
    print(_firstFieldController.text);
    print(_secondFieldController.text);
    Services.updateDistrictMaterials(districtMaterial.id.toString(), 
    _firstFieldController.text.toString(), 
    _secondFieldController.text.toString()).then((result){
      if('Success' == result){
        _showSnackBar(context, 'Update Successful');
        _getDistrictMaterials();
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      } else {
        _showSnackBar(context, result);
      }
    });
  }

  _showValues(DistrictMaterial districtMaterial) {
    _firstFieldController.text = districtMaterial.workingStatus.toString();
    _secondFieldController.text = districtMaterial.issuedTo.toString();
  }

  SingleChildScrollView _dataBody() {
    //Both Vertical and Horizontal
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
             label: Text('MATERIAL CODE'),  
            ),
            DataColumn(
             label: Text('MATERIAL NAME'),  
            ),
            DataColumn(
             label: Text('CATEGORY CODE'),  
            ),
            DataColumn(
             label: Text('WORKING STATUS'),  
            ),
            DataColumn(
             label: Text('COLOR'),  
            ),
            DataColumn(
             label: Text('ISSUED TO'),  
            )
          ],
          rows: _districtMaterial.map((districtMaterial) => DataRow(
            cells: [
              DataCell(
                Text(districtMaterial.materialCode.toString()),
                onTap: () {
                  _showValues(districtMaterial);
                  _selectedDistrictMaterial = districtMaterial;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(districtMaterial.materialName.toUpperCase()),
                onTap: () {
                  _showValues(districtMaterial);
                  _selectedDistrictMaterial = districtMaterial;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(districtMaterial.categoryCode.toString()),
                onTap: () {
                  _showValues(districtMaterial);
                  _selectedDistrictMaterial = districtMaterial;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(districtMaterial.workingStatus.toString()),
                onTap: () {
                  _showValues(districtMaterial);
                  _selectedDistrictMaterial = districtMaterial;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(districtMaterial.color.toUpperCase()),
                onTap: () {
                  _showValues(districtMaterial);
                  _selectedDistrictMaterial = districtMaterial;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              ),
              DataCell(
                Text(districtMaterial.issuedTo.toString()),
                onTap: () {
                  _showValues(districtMaterial);
                  _selectedDistrictMaterial = districtMaterial;
                  setState(() {
                    _isUpdating = true;
                  });
                },
              )
            ]),
          )
          .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgess),
        actions: <Widget>[
                IconButton(
                icon: Icon(Icons.refresh),
                   onPressed: () {
                  _getDistrictMaterials();
                  },
                ),
                RaisedButton(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => MaterialRequest(username : username, departmentcode : departmentcode)),
                 );
                },
               color: Colors.deepOrange,
               textColor: Colors.white,
               child: Text('Request Material'),
              ),
            ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _firstFieldController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Status',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _secondFieldController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Issued To',
                ),
              ),
            ),
            // Add an update button and a Cancel Button
            // show these buttons only when updating an employee
            _isUpdating
            ? Row(
                children: <Widget>[
                  OutlineButton(
                    child: Text('UPDATE'),
                    onPressed: () {
                        _updateDistrictMaterial(_selectedDistrictMaterial);
                      },
                    ),
                    OutlineButton(
                      child: Text('CANCEL'),
                      onPressed: () {
                        setState(() {
                          _isUpdating = false;
                        });
                        _clearValues();
                      },
                    ),
                  ],
                )
                : Container(),
          //_getDistrictMaterials(),
          Expanded ( child: _dataBody(),
          ),
          ],
        ),
        ),
      );
  }
} 

class MaterialRequest extends StatefulWidget {
  //MaterialRequest() : super();
  final String username;
  final int departmentcode;
  MaterialRequest({Key key, @required this.username, @required this.departmentcode}) : super(key: key);
  final String title = 'Request Material';
  @override
  //State<StatefulWidget> createState() {
  // TODO: implement createState
  //return null;
  //}
  MaterialRequestState createState() => MaterialRequestState(departmentcode);
}

class MaterialRequestState extends State<MaterialRequest> {
  
  GlobalKey<ScaffoldState> _scaffoldKey;
  //TextEditingController _firstFieldController;
  TextEditingController _secondFieldController;
  TextEditingController _thirdFieldController;
  TextEditingController _fourthFieldController;
  //TextEditingController _fifthFieldController;
  TextEditingController _sixthFieldController;
  final int departmentcode;
  MaterialRequestState(this.departmentcode);

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    //_firstFieldController = TextEditingController();
    _secondFieldController = TextEditingController();
    _thirdFieldController = TextEditingController();
    _fourthFieldController = TextEditingController();
    //_fifthFieldController = TextEditingController();
    _sixthFieldController = TextEditingController();
  }

  // User Logout Function.
  // logout(BuildContext context1){
  //    Navigator.pop(context1);
  // }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _requestDistrictMaterials() async {
    if (//_firstFieldController.text.isEmpty ||
        _secondFieldController.text.isEmpty ||
        _thirdFieldController.text.isEmpty ||
        _fourthFieldController.text.isEmpty ||
        //_fifthFieldController.text.isEmpty ||
        _sixthFieldController.text.isEmpty) {
      //print('Empty Fields');
      _showSnackBar(context, 'Empty Fields');
      return;
    }
    //_showProgess("Request processing....");
    Services.requestDistrictMaterials(
            //int.parse(_firstFieldController.text),
            departmentcode.toString(),
            _secondFieldController.text,
            _thirdFieldController.text,
            _fourthFieldController.text,
            //_fifthFieldController.text,
            _sixthFieldController.text)
        .then((result) {
          if ('Success' == result) {
        _showSnackBar(context, 'Request Sent Successfully');
        _clearValues();
      }
      else { _showSnackBar(context, 'Error');
      }
    });
    // Getting value from Controller
  // String materialcode = _secondFieldController.text;
  // String materialname = _thirdFieldController.text;
  // String quantity = _fourthFieldController.text;
  // String remarks = _sixthFieldController.text;

  // // SERVER LOGIN API URL
  // var url = 'http://192.168.1.11/requirement/requestdistrictmaterial';
 
  // // Store all data with Param Name.
  // //var data = {'email': username, 'password' : password};
  // var map = Map<String, dynamic>();
  // //map['DeptCode'] = departmentcode.toString();
  // map['DeptCode'] = departmentcode.toString();
  // map['MaterialCode'] = materialcode;
  // map['MaterialName'] = materialname;
  // map['Quantity'] = quantity;
  // map['Remarks'] = remarks;
  // // Starting Web API Call.
  // print(json.encode(map));
  // var response = await http.post(url, body: map);
  // // Getting Server response into variable.
  // String message = jsonDecode(response.body);
  // print(message);
  //     if ('Success' == message) {
  //       _showSnackBar(context, 'Request Sent Successfully');
  //       _clearValues();
  //     }
  //     else { _showSnackBar(context, 'Error');
  //     }
    }
  

//Method to clear TextField values
  _clearValues() {
    //_firstFieldController.text = '';
    _secondFieldController.text = '';
    _thirdFieldController.text = '';
    _fourthFieldController.text = '';
    //_fifthFieldController.text = '';
    _sixthFieldController.text = '';
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Request Material'),
        //actions: <Widget>[
          //IconButton(
            //icon: Icon(Icons.refresh),
            //onPressed: () {
              //logout(context);
            //},
          //)
        //],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.all(20.0),
            //   child: TextField(
            //     controller: _firstFieldController,
            //     decoration: InputDecoration.collapsed(
            //       hintText: 'Department Code',
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _secondFieldController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Material Code',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _thirdFieldController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Material Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _fourthFieldController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Quantity',
                ),
              ),
            ),
            //Padding(
              //padding: EdgeInsets.all(20.0),
              //child: TextField(
                //controller: _fifthFieldController,
                //decoration: InputDecoration.collapsed(
                  //hintText: 'Status',
                //),
              //),
            //),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _sixthFieldController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Remarks',
                ),
              ),
            ),
            //Add an update button and a Cancel Button
            //_isUpdating?
                 Row(
                   mainAxisAlignment : MainAxisAlignment.center,
                    children: <Widget>[
                      OutlineButton(
                        child: Text('REQUEST'),
                        onPressed: () {
                          _requestDistrictMaterials();
                        },
                      ),
                      OutlineButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          // setState(() {
                          //   _isUpdating = false;
                          // });
                          _clearValues();
                        },
                      ),
                    ],
                  )
                //: Container(),
          ],
        ),
      ),
    );
  }
}
