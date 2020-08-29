import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:ha_angricola/models/user.dart';


class UserProfile extends StatefulWidget {

  final User user;

  UserProfile({this.user});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserProfileState();
  }

}

class UserProfileState extends State<UserProfile> {

  int pos=0;
  String _name="Nome";
  String _email="Email";
  String _password="Palavra Passe";
  String _phoneNumber="Número do Telefone";


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('Meu Perfil'),
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: 420,
              margin: EdgeInsets.only(bottom: 8.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0)),
                  image: DecorationImage(
                      image: AssetImage('images/main_logo.jpeg'),
                      fit: BoxFit.cover
                  )
              ),
            ),
         Container(
           margin: EdgeInsets.only(top: 8.0),
           child: ListView.builder(
             shrinkWrap: true,
             itemCount: 4,
             itemBuilder: (BuildContext context, int index) {

               String firstData;
               String secondData;
               switch(index)
               {
                 case 0: firstData=_name;
                         secondData=widget.user.firstName;
                        break;
                 case 1: firstData=_email;
                          secondData=widget.user.email;
                        break;
                 case 2: firstData=_password;
                          secondData="*******";
                          break;
                 case 3: firstData=_phoneNumber;
                         secondData=widget.user.numberPhone;
                         break;
               }
               return  Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: <Widget>[
                       Container(
                           margin: EdgeInsets.only(left: 8.0, top: 8.0),
                           child: Text('$firstData',
                             textAlign: TextAlign.start,
                             style: TextStyle(
                                 fontWeight: FontWeight.bold, fontSize: 16.0),
                           )
                       ),
                       Container(
                           margin: EdgeInsets.only(left: 8.0, top: 8.0),
                           child: Text('$secondData',
                             textAlign: TextAlign.start,
                             style: TextStyle(fontSize: 16.0),),
                       ),
                     ],
                   ),
                 ],
               );
             },
        ),
         ),
          ],
        ),
    );
  }


}