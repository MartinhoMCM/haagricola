
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ha_angricola/customicons/paymentcard.dart';
import 'package:ha_angricola/customicons/paymenthandshakes.dart';
import 'package:ha_angricola/views/preform.dart';
import 'package:ha_angricola/helper/colorsUI.dart';
import 'package:ha_angricola/helper/helper.dart';
import 'package:ha_angricola/models/product.dart';
import 'package:ha_angricola/models/user.dart';
import 'package:ha_angricola/service/authentication.dart';
import 'package:ha_angricola/views/facturascreen.dart';

class Cart extends StatefulWidget
{

  double amount;
  final List<Product> product;
  final int unity;
  //Calculate total amount in Cart
  final Function(double) cbAmount;
  final User user;

  final BaseAuth auth;
  final String userId;


  Cart({this.amount, this.product, this.unity, this.cbAmount, this.user, this.auth, this.userId});


  _CartState createState()=>_CartState();

}

class _CartState extends State<Cart>
{
  double dAmount=0.0;

  @override
  void initState() {

    dAmount=widget.amount;

    //If there's no product selected dbAmount=0.0
    if(widget.product.length==0)
    {
       dAmount=0.0;
    }
    // TODO: implement initState
    super.initState();
  }


  ImageProvider displayImage(String url) {

    CachedNetworkImageProvider _cachedNetworkImageProvider= CachedNetworkImageProvider(url);
    return _cachedNetworkImageProvider;
  }

  _showCardDialogPreform(BuildContext context)
  {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 10.0,
      backgroundColor: Colors.transparent,
      child: _dialogContentChoice(context),
    );

  }

  _dialogContentChoice(BuildContext context){



    return Container(
      width: 100.0,
      height: 220.0,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Escolhe o Método de Pagamento", style: TextStyle(fontSize: 14.0, color:Colors.black, fontWeight: FontWeight.w900),),
          ),
           Card(
             color: ColorsUI.primaryColor,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Depósito'),
                trailing: Icon(MyFlutterAppPaymentCard.card, color: Colors.blueAccent,),
                onTap: (){
                  Navigator.pop(context);
                 Navigator.push(context, MaterialPageRoute(
                   builder: (context)=>Preform(user: widget.user, productDetails: widget.product, amout: widget.amount,auth: widget.auth,userId: widget.userId,)
                 ));
                },
              ),
            ),
          ),
          Card(
            color: ColorsUI.primaryColor,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Numerário'),
                trailing: Icon(MyFlutterAppPaymentShake.pay,color: ColorsUI.accentColor, ),
                onTap: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context)=>CreatePdfOrImageStatefulWidget(userId: widget.userId, auth: widget.auth,user: widget.user,
                        productDetails:widget.product, amount: widget.amount, )
                  ));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                  child: Text('CANCELAR', style: TextStyle(fontSize: 12.0, color:ColorsUI.primaryColor, fontWeight: FontWeight.w900),)),
            ),
          )
        ],
      ),
    );
  }

  _showCardDialogToDelete(BuildContext context, int index)
  {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 10.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context, index),
    );
  }
  dialogContent(BuildContext context, int index) {
    return Container(
      width: 60.0,
      height: 100.0,
      color: Colors.white,
      margin: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left:0.0,top:8.0),
              child: Text("Eliminar ${widget.product[index].name} na lista",
                  style: TextStyle( fontSize:14.0 , fontWeight: FontWeight.w600) )),
          Container(
              margin: EdgeInsets.only(left:0.0,top:8.0),
              child: Text("Tens a certeza?",
                  style: TextStyle( fontSize:12.0 , ) )),
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text("SIM", style: TextStyle(fontSize:14.0, color:ColorsUI.primaryColor )),
              onPressed: (){
                setState(() {
                  dAmount-=widget.product[index].amount;
                  widget.product.removeAt(index);
                  if(!(dAmount>0.0))
                    {
                      dAmount=0.0;
                      widget.amount=0.0;
                      widget.product.clear();
                      widget.cbAmount(0.0);
                    }
                  Navigator.of(context).pop();
                });
              },
            ),
            FlatButton(
              child: Text("NÃO", style: TextStyle(fontWeight: FontWeight.bold, fontSize:14.0, color:ColorsUI.primaryColor ),),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ],
      ),
    );
  }

  incrementQuantity(int index)
  {
    setState(() {
      widget.product[index].quantity++;
      widget.product[index].amount+=widget.product[index].price;
      widget.amount+=widget.product[index].price +.0;
      dAmount=widget.amount;
      widget.cbAmount(widget.amount);

    });

  }
  decrementQuantity(int index)
  {
    setState(() {
      if( widget.product[index].quantity>1){
        widget.product[index].quantity--;
        widget.product[index].amount-=widget.product[index].price;
        widget.amount-=widget.product[index].price +.0;
        dAmount=widget.amount;
        widget.cbAmount(widget.amount);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    var prod= widget.product;
    prod.sort((a,b)=>a.name.compareTo(b.name));
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        title: Text('Carrinho'),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.product.length,
                itemBuilder: (BuildContext context, int index)=>
                   Card(
                     elevation: 2.0,
                     child: Container(
                       margin: EdgeInsets.only(bottom: 4.0, top: 4.0, left: 4.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             Row(
                               children: <Widget>[
                                 Container(
                                   height: 70,
                                   width:70,
                                   margin: EdgeInsets.only(right: 8.0),
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(5.0),
                                       image: DecorationImage(
                                           image: displayImage(widget.product[index].img),
                                           fit: BoxFit.cover
                                       )
                                   ),
                                 ),
                                 Container(
                                   margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 22.0,top: 0.0),
                                   child: Column(
                                     mainAxisAlignment: MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: <Widget>[
                                       Text('${widget.product[index].name}', style: TextStyle(fontSize:14.0, fontWeight: FontWeight.w400, height: 1.0),),
                                       Text('${widget.product[index].quantity} x ${Helper.numberFormat(widget.product[index].price)} AKZ', style: TextStyle(fontSize:12.0),),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(top: 8.0, left: 4.0, right: 0.0, bottom: 0.0),
                                        child: GestureDetector(
                                            onTap: (){
                                              decrementQuantity(index);
                                            },
                                            child: Icon(Icons.remove, color: Colors.grey,))),
                                    Container(
                                        margin:  EdgeInsets.only(top: 8.0, left: 4.0, right: 0.0, bottom: 0.0),
                                        child: GestureDetector(
                                            onTap: (){
                                              incrementQuantity(index);
                                            },
                                            child: Icon(Icons.add, color:
                                            Colors.grey,))),
                                    Container(
                                        margin: EdgeInsets.only(top: 8.0, left: 4.0, right: 8.0, bottom: 0.0),
                                        child: GestureDetector(
                                            onTap: (){
                                              showDialog(context: context, builder: (context)=>_showCardDialogToDelete(context, index));
                                            },
                                            child: Icon(Icons.delete, color: ColorsUI.primaryColor,))),
                                  ],
                                ),
                               Container(
                                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0, right: 8.0),
                                  child: Text('${Helper.numberFormat(widget.product[index].amount)} AKZ', style: TextStyle(fontSize:10.0, color:Colors.grey),),
                                )
                              ],
                            )
                           ],
                         ),
                     ),
                   )
            ),
            Container(
              margin: EdgeInsets.only(top: 2.0, bottom: 2.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total', style: TextStyle(fontSize:16.0, fontWeight: FontWeight.w900),),
                  Text( dAmount>1.0? '${Helper.numberFormat(dAmount)} AKZ' :'0.0 AKZ', style: TextStyle(fontSize:16.0, fontWeight: FontWeight.w900),),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.all(8.0),
              child: Card(
                child: Row(
                  children: <Widget>[
                    dAmount>0.0?GestureDetector(
                  child:  Container(
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5.0),
                        topLeft: Radius.circular(5.0)),
                  ),
                  height: 50.0,
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.check, color: Colors.green, size: 30.0,),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('Facturar', style: TextStyle(fontSize: 16.0,)),
                        ]),
                  ),
                ),
                onTap: (){
                  if(widget.product.length>0){
                 
                 showDialog(context: context, builder: (context)=>_showCardDialogPreform(context));
                  
                  }
                },
              ): Container(width: 0.0, height: 0.0,),

                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          width: 200.0,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)),
                          ),
                          height: 50.0,
                          child: Padding(
                            padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment:dAmount>0.0?MainAxisAlignment.start:MainAxisAlignment.center ,
                              children: <Widget>[
                                Icon(Icons.cancel, size: 30.0,),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text('Cancelar Tudo', style: TextStyle(fontSize: 16.0,))
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                         setState(() {
                            dAmount=0.0;
                            widget.amount=0.0;
                            widget.product.clear();
                            widget.cbAmount(0.0);
                         });
                         Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}