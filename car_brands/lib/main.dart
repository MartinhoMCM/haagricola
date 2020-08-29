import 'package:flutter/material.dart';
void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  List<Car> cars =showTheCar();

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Flutter Day 2020'),
    ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child:ListView.builder(
          itemCount: cars.length,
            itemBuilder: (BuildContext context, index){
            return new ShowCar(car: cars[index]);
            }) ,
      ),
    );

  }
}

class ShowCar extends StatelessWidget{

  final Car car;

  ShowCar({this.car});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${car.name}'),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(car.image)
        ),

      ],
    );
  }


}

class Car
{
  String name;
  String image;

  Car({this.name, this.image});
}

List<Car> showTheCar(){

  List<Car> cars = new List();


  cars.add(new Car(name:'Jeep', image:'https://images.unsplash.com/photo-1504752259248-338119a1adac?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'));
  cars.add(new Car(name:'Audi', image:'https://images.unsplash.com/photo-1541800658-6599fffd81c1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'));
  cars.add(new Car(name:'Toyota', image:'https://images.unsplash.com/photo-1589134921123-bab9cbac7f30?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'));
  //cars.add(new Car(name:'Ferrari', image:'https://unsplash.com/photos/LX0pplSjE2g'));
  cars.add(new Car(name:'Mercedes', image:'https://images.unsplash.com/photo-1590216255837-24412b004996?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'));
  cars.add(new Car(name:'BMW', image:'https://images.unsplash.com/photo-1548783912-6647591705f7?ixlib=rb-1.2.1&q=85&fm=jpg&crop=entropy&cs=srgb&ixid=eyJhcHBfaWQiOjE0NTg5fQ'));

  return cars;
}
