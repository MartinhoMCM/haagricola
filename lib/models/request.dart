
import 'package:ha_angricola/models/product.dart';
import 'package:ha_angricola/models/user.dart';

class Request{


  final String id;
  final String date;
  final double amount;
  final List<Product> products;
  final User user;
  final String img;
  Request({this.id, this.date, this.amount, this.products, this.user, this.img});

  Request.fromMap(Map snapshot, String id):
        id=id??'',
        date=snapshot['date'],
        amount=snapshot['amount'],
        img=snapshot['image'],
        user =User.fromMap(snapshot, id),
        products=[Product.fromMap(snapshot)];


  toJson()
  {
    Map user =this.user!=null?this.user.toJson():null;
    List<Map> products=this.products!=null?this.products.map((i)=>i.toJson()).toList():null;

    return {
      "date":date,
      "amount":amount,
      "img":img,
      "user":user,
      "product":products,
    };
  }





}