import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ha_angricola/helper/colorsUI.dart';
import 'package:ha_angricola/helper/helper.dart';
import 'package:ha_angricola/models/product.dart';
import 'package:ha_angricola/models/user.dart';

Color color4 =Color(0xFFBC5835);

class DescriptionProduct extends StatefulWidget
{

  final Product product;
  final int index;
  final User user;
  final Function(double) onCountChange;
  final Function(Product) onAddProduct;

   const DescriptionProduct({this.product, this.index, this.user, this.onCountChange, this.onAddProduct});

  @override
  State<StatefulWidget> createState() {
    return DescriptionProductState();
  }

}
class DescriptionProductState extends State<DescriptionProduct>
{


  int unity;
  double price;
  double realPrice;

  String add="Adicionar no Carrinho";
  Icon addCartIcon=Icon(Icons.add_shopping_cart);
  bool isTapped;

  @override
  void initState() {
    unity=1;

    if(widget.product.price!=null){
      price=widget.product.price+.0;
      realPrice=price;
    }
    isTapped=false;
    super.initState();
  }

  incrementUnity()
  {
    setState(() {
      unity++;
      realPrice =unity*price;
    });
  }

  decrementUnity(){

    if(unity>0)
    {
      setState(() {
        if(unity>0){
          unity--;
          realPrice =unity*price;
        }
      });
    }
  }


  ImageProvider displayImage(String url) {

    CachedNetworkImageProvider _cachedNetworkImageProvider= CachedNetworkImageProvider(url);

    return _cachedNetworkImageProvider;
  }





  @override
  Widget build(BuildContext context) {
    TextStyle patternStyleTitle =Theme.of(context).textTheme.title;

  return Scaffold(
      appBar: AppBar(
        title: Text('Descrição do Producto', style:patternStyleTitle ,),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        children: <Widget>[
                Container(
                  height: 200,
                  width:420,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft:Radius.circular(5.0), bottomRight: Radius.circular(5.0) ),
                      image: DecorationImage(
                          image: displayImage(widget.product.img),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text('${widget.product.name}'.toUpperCase() ,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0), )
                ),
                Container(
                    margin: EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Text('1 Unidade  (${widget.product.weight} kg)',
                      textAlign: TextAlign.start,
                      style: TextStyle( fontSize: 12.0),)
                ),
                Container(
                    margin: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                    child: Text('Caracteristica',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),)
                ),
                Container(
                    margin: EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
                    child: Text('${widget.product.description}',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 13.0, ),)
                ),

                Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 8.0),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only( top: 8.0,bottom: 8.0),
                            child: Text('Unidade (s)',
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),)
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                     decrementUnity();

                                  },
                                  child: CircleAvatar(
                                    maxRadius: 20.0,
                                    minRadius: 20.0,
                                    backgroundColor: ColorsUI.accentColor,
                                    foregroundColor: Colors.black,
                                    child: Icon(Icons.remove),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Text( '$unity', style: TextStyle(fontSize: 16.0),),
                                ),

                                GestureDetector(
                                  onTap: (){
                                    incrementUnity();

                                  },
                                  child: CircleAvatar(
                                    maxRadius: 20.0,
                                    minRadius: 20.0,
                                    backgroundColor: ColorsUI.accentColor,
                                    foregroundColor: Colors.black,
                                    child: Icon(Icons.add),
                                  ),
                                ),

                              ],
                            ),

                            Container(
                                margin: EdgeInsets.only(left: 8.0, top: 8.0),
                                //Calculate price after click
                                child: Text('AKZ ${Helper.numberFormat(realPrice)}',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),)
                            ),
                          ],
                        ),
                      ],
                    )

          ),
        ],
      ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
            elevation: 10.0,
            child:
            GestureDetector(
                    child: Container(
                      width:155,
                      decoration: BoxDecoration(
                        color:  color4,
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                      ),
                      height: 50.0,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                             isTapped? Icon(Icons.add_shopping_cart, color: ColorsUI.accentColor,):  Icon(Icons.shopping_cart),
                            Text( 'Adicionar no Carrinho', style: TextStyle(
                                    fontSize: 16.0,)),


                          ],
                        ),),
                    ),
                    onTap:(){
                      setState(() {
                        isTapped=true;
                        widget.product.quantity=unity;
                        widget.product.amount=realPrice;
                        widget.onCountChange(realPrice);
                        widget.onAddProduct(widget.product);
                      });

                    } ,
                  ),


          )
      ),
    );
  }

}