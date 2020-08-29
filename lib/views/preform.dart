
import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:ha_angricola/customicons/paymentcard.dart';
import 'package:ha_angricola/helper/colorsUI.dart';
import 'package:ha_angricola/helper/helper.dart';
import 'package:ha_angricola/models/bank_account.dart';
import 'package:ha_angricola/models/crudbank.dart';
import 'package:ha_angricola/models/product.dart';
import 'package:ha_angricola/models/user.dart';
import 'package:ha_angricola/service/authentication.dart';
import 'package:ha_angricola/views/facturascreen.dart';
import 'package:image_picker/image_picker.dart';

class Preform extends StatefulWidget
{

  final List<Product> productDetails;
  final double amout;
  final User user;

  final BaseAuth auth;
  final String userId;
  Preform({this.amout, this.user, this.productDetails, this.auth, this.userId});

  PreformState createState()=>PreformState();

}

class PreformState extends State<Preform>{

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  //Bank data
  String name;
  String iban;
  String accountNumber;


  File _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;
  bool _capturedImage=false;
  Future<List<BankAccount>> account;
  CRUD_Bank crudBank;

  Future getImage() async {
    try{
      var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 480.0, maxWidth: 650.0);
      debugPrint('image : $image');
      setState(() {
        _imageFile = image;
        debugPrint('_imageFile : $image');
        _capturedImage=true;

      });
    }
   catch(e){
      _pickImageError=e;
   }

  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response =
    await ImagePicker.retrieveLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.type == RetrieveType.image) {
         _imageFile =response.file;
        }
      });
    } else {
      if(response.exception.code!=null)
     _retrieveDataError=response.exception.code;
    }
  }
  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
    return Container(
      width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft:Radius.circular(5.0), bottomRight: Radius.circular(5.0) ),
            image: DecorationImage(
                image:FileImage(_imageFile),
                fit: BoxFit.cover
            )
        ),
      );
    //  return Image.file(_imageFile, height: 200, width: 200,);

    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'Ainda nao selecionaste uma imagem.',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  void initState() {

   this.crudBank =new CRUD_Bank();
   initConnectivity();
   _connectivitySubscription =
       _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // TODO: implement initState
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {

    switch(result) {
      case ConnectivityResult.wifi:
        setState(() {
          _connectionStatus="wifi";
        });

        break;
      case ConnectivityResult.mobile:
        setState(() {
          _connectionStatus="mobile";
        });
        break;

      default:
        setState(() {
          _connectionStatus='Unknown';
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    account = crudBank.fetchAccount();
   // debugPrint("account $account");

   if(account!=null){
  account.then((value){
    for(BankAccount bankAccount in value)
    {
      setState(() {
        name=bankAccount.name;
        iban=bankAccount.iban;
        accountNumber=bankAccount.account_number;
      });

    }
  });
  }

    return Scaffold(
      appBar: AppBar(
        title: Text('Depósito',),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: _connectionStatus=='Unknown'? Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Sem conexao a internet'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.signal_cellular_off),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.signal_wifi_off),
              ),
            ],
          ),
        ): ListView(
                children: <Widget>[
                  Container(
                    height: 200,
                    width:200,
                    decoration: BoxDecoration(
                      color: ColorsUI.primaryColor,
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('Montante', style: TextStyle(fontWeight: FontWeight.w600),),
                          ),
                          Text('${Helper.numberFormat(widget.amout)} AKZ',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),),
                        ],
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ListTile(
                      title:Text( (iban!=null)?'(IBAN) $iban':'IBAN Processando...'),
                      leading: Icon(MyFlutterAppPaymentCard.card, color: Colors.blueAccent,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: ListTile(
                      title:Text( (accountNumber!=null )?'(Nº da conta) $accountNumber':'(Nº da conta)  Processando ...'),
                      leading: Icon(MyFlutterAppPaymentCard.card, color: Colors.black,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Instruções: ', style: TextStyle(fontWeight: FontWeight.w600),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Text('1. Trasfere ou deposite o montante na conta acima, banco  $name', style: TextStyle(fontSize: 14.0),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Text('2. Tire uma fotografia do comprovativo do depósito ou transferência.', style: TextStyle(fontSize: 14.0),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Text('3. Faça o upload da imagem.', style: TextStyle(fontSize: 14.0),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Center(
                    /*  child: FlatButton(
                        color: Colors.blueAccent,
                        onPressed: getImage,
                        child: Text('Upload a imagem'),
                      ),*/
                    /*child: Platform.isAndroid? FutureBuilder<void>(
                     // future: retrieveLostData(),
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot)
                      {
                         switch(snapshot.connectionState){
                           case ConnectionState.waiting:
                             return const Text('Ainda Nao selecionaste nenhuma foto.', textAlign: TextAlign.center,);
                           case ConnectionState.done: return _previewImage();
                           default:
                             if (snapshot.hasError) {
                               return Text(
                                 'Pick image: ${snapshot.error}}',
                                 textAlign: TextAlign.center,
                               );
                             } else {
                               return const Text(
                                 'Ainda nao selecionaste numa imagem.',
                                 textAlign: TextAlign.center,
                               );
                             }
                         }
                      },
                    ): _previewImage(),*/
                    child: _previewImage(),
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: !_capturedImage,
                        child: FlatButton(
                          color: Colors.blueAccent,
                          onPressed: getImage,
                          child: Text('Clique para fazer o upload a imagem'),
                        ),
                      ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Visibility(
                      //visible: _capturedImage,
                      child: FlatButton(
                        color: ColorsUI.primaryColor,
                        onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context)=>
                                  CreatePdfOrImageStatefulWidget(productDetails: widget.productDetails,
                                amount: widget.amout,user: widget.user, file: _imageFile, auth:this.widget.auth,userId: widget.userId, )
                          ));
                        },
                        child: Text('Avancar'),
                      ),
                    ),
                  ),
                ],
              ),

      ),
    );
  }

}