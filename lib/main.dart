import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ha_angricola/customicons/apple.dart';
import 'package:ha_angricola/customicons/fish.dart';
import 'package:ha_angricola/customicons/food.dart';
import 'package:ha_angricola/customicons/grains.dart';
import 'package:ha_angricola/customicons/meat.dart';
import 'package:ha_angricola/customicons/oil.dart';
import 'package:ha_angricola/customicons/vegetable.dart';
import 'package:ha_angricola/helper/colorsUI.dart';
import 'package:ha_angricola/helper/helper.dart';
import 'package:ha_angricola/models/crudmodeproduct.dart';
import 'package:ha_angricola/models/product.dart';
import 'package:ha_angricola/models/user.dart';
import 'package:ha_angricola/service/authentication.dart';
import 'package:ha_angricola/service/locator.dart';
import 'package:ha_angricola/controller/rootpage.dart';
import 'package:ha_angricola/views/about.dart';
import 'package:ha_angricola/views/cart.dart';
import 'package:ha_angricola/views/productdescription.dart';
import 'package:ha_angricola/views/userprofile.dart';
import 'package:provider/provider.dart';


void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CRUDModelProduct>(
            create: (_) => locator<CRUDModelProduct>()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'HA-AGRICOLA',
          theme: ThemeData(
            textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
            primaryColor: ColorsUI.white,
            accentColor: ColorsUI.accentColor,
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/',
          routes: {
            '/':(context)=>new RootPage(auth: new Auth()),
            '/second':(context)=>HomePage(),
          },
          //home: new RootPage(auth: new Auth())
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback, this.clean})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  bool clean=false;


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String path="users";
  List<Product> products;
  bool _isLoading;
  bool selected;  // A variable to control if the A category is selected or not.
  String searchProduct;  // A variable to control the query operation
  String category;
  String _productName;

  //Select Option
  bool fruit=false;
  bool allFood=false;
  bool vegetable=false;
  bool fish=false;
  bool oil =false;
  bool all=false;
  bool fresh=false;
  bool grao=false;

  //Data variable to handle option to buy and to make cart
  double cart=0.0;
  List<Product> productInCart=new List();
  int unity;

  //FIRESTORE
  Firestore _fireStore;
  User user;


  CachedNetworkImageProvider _cachedNetworkImage;

//DatabaseReference dbRef =FirebaseDatabase.instance.reference().child("users");

  _selectFood(String food)
  {

    setState(() {
      switch (food)
      {
        case "todo":
          all=true;
          fruit=false;
          allFood=false;
          vegetable=false;
          fish=false;
          oil =false;
          grao=false;
          fresh=false;
          break;

        case "fruit":
          fruit=true;
        allFood=false;
        vegetable=false;
        fish=false;
        oil =false;
        all=false;
        fresh=false;
        grao=false;
        break;

        case "vegetable":
          fruit=false;
        allFood=false;
        vegetable=true;
        fish=false;
        oil =false;
        all=false;
        break;

        case "oil":
          fruit=false;
        allFood=false;
        vegetable=false;
        fish=false;
        oil =true;
        all=false;
        fresh=false;
        grao=false;
        break;

        case "fish":
          fruit=false;
        allFood=false;
        vegetable=false;
        fish=true;
        oil =false;
        fresh=false;
          grao=false;
        all=false;
        break;

        case "fresh":
          fruit=false;
        allFood=false;
        vegetable=false;
        fish=false;
        oil =false;
        all=false;
          grao=false;
        fresh=true;
        break;


        case "grao":
          fruit=false;
        allFood=false;
        vegetable=false;
        fish=false;
        oil =false;
        all=false;
        grao=true;
        fresh=false;
        break;

        case "search":
          fruit=false;
          allFood=true;
          vegetable=false;
          fish=false;
          oil =false;
          all=false;
          grao=false;
          fresh=false;
        break;
      }
    });

  }

  @override
  void initState() {
    _isLoading = true;
    selected=false;
    category=null;
    all=true;
    fruit=false;
    _productName=null;

    cart=0.0;
    _fireStore=Firestore.instance;

    if(widget.clean==true){

      productInCart.clear();
      cart=0.0;
    }

    getCollectionRef();

    super.initState();
  }


//Retrive Specif data from Firebase
  void getCollectionRef() async{

   user=new User();
   await _fireStore.collection("users").getDocuments().then((value)
   {
     if(value.documents.length>0)
     {
       for(DocumentSnapshot snapshot in value.documents)
         {
           if(snapshot.data['id'] ==widget.userId)
             {
               setState(() {
                 user =User.fromMap(snapshot.data);
               });

             }
         }
     }

   });
  }


  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<CRUDModelProduct>(context);

    signOut() async {
      try {
        await widget.auth.signOut();
        widget.logoutCallback();
        Navigator.pop(context);
      } catch (e) {
        print(e);
      }
    }

    ImageProvider displayImage(String url) {

    _cachedNetworkImage =
          CachedNetworkImageProvider(url);

      return _cachedNetworkImage;
    }

    Widget _showCircularProgress() {

    if(products!=null && products.length>0)  {
      if (_isLoading) {
        return Center(child: CircularProgressIndicator());
      }
    }
    return Container(
        height: 0.0,
        width: 0.0,
      );
    }

    Widget _showSearchStream()
    {
      String value;
      if(_productName==null) {
        products.clear();
        return StreamBuilder(
          stream: productProvider.fetchProductCategoryAsStream(category),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              products = snapshot.data.documents
                  .map((doc) => Product.fromMap(doc.data, doc.documentID))
                  .toList();
              _isLoading=false;
              return StaggeredGridViewCountuBuilder(displayImage);
            } else {
              setState(() {
                _isLoading = true;
              });
              return ContainerIfSnapshotHasNotData();
            }
          },
        );
      }
      else{
        setState(() {
          value=_productName;
          _productName=null;
        });
        return StreamBuilder(
          stream: productProvider.fetchProductNameAsStream(productName: value),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              products = snapshot.data.documents
                  .map((doc) => Product.fromMap(doc.data, doc.documentID))
                  .toList();
              _isLoading = false;
              return StaggeredGridViewCountuBuilder(displayImage);

            }
            else {
              setState(() {
                _isLoading = true;
              });
              return ContainerIfSnapshotHasNotData();
            }

          },
        );

      }

    }

    Widget _showMainStream(){
     // _showCircularProgress();
     return   StreamBuilder(
         stream: productProvider.fetchProductAsStream(),
         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
           if (snapshot.hasData) {
             products = snapshot.data.documents
                 .map((doc) => Product.fromMap(doc.data, doc.documentID))
                 .toList();
             return StaggeredGridViewCountuBuilder(displayImage);
           } else {

             return ContainerIfSnapshotHasNotData();
           }
         },
       );
     }

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/main_logo.jpeg',),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user!= null ? '${user.firstName}' : 'Processando ...',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.person),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new UserProfile(user: this.user,),
                                ));
                          },
                          child: Text(
                            'Meu perfil',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.home),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>
                                    About()
                                ));
                          },
                          child: Text(
                            'Sobre Há-Agrícola',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            signOut();
                          },
                          child: Text(
                            'Sair',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                forceElevated: innerBoxIsScrolled,
                backgroundColor: ColorsUI.white,
                expandedHeight: 50,
                floating: false,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text('HA-AGRÍCOLA',
                      style: Theme.of(context).textTheme.title),
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                    },
                    icon: (user!=null)?Icon(Icons.person, color: Colors.black,) :Icon(Icons.person, color: Colors.white,)
                  ),
                ],
              ),
              SliverPadding(
                padding: EdgeInsets.only(left: 8.0, top: 8.0),
                sliver: new SliverList(
                    delegate: new SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, top: 8.0, right: 100.0),
                    child: Container(
                      width: 20,
                      height: 40,
                      child: TextField(
                        onSubmitted: (value){
                          if(value.length>0)
                          {
                            setState(() {
                              _isLoading=true;
                              selected=true;

                              _productName=value;
                              _showCircularProgress();
                              _selectFood("search");
                            });
                          }
                        },
                        keyboardType:TextInputType.text ,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              hintText: 'Search',
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.black),
                              fillColor: ColorsUI.color4,
                              focusColor: Colors.black,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    width: 2.0,
                                    color: Colors.transparent,
                                  ))),

                      ),

                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 0.0, top: 16.0, right: 8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 60,
                                child: GestureDetector(
                                  onTap: () {
                                    getCollectionRef();
                                    setState(() {
                                      selected=false;
                                      _selectFood("todo");
                                      setState(() {
                                        category="tudo";
                                      });
                                    });
                                  },
                                  child: Card(
                                    color: all?ColorsUI.accentColor:ColorsUI.white,
                                    elevation: 2.0,
                                    child: Icon(
                                      MyFlutterAppFood.food,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Tudo',
                                style:
                                    TextStyle(fontSize: 12.0, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 60,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selected=true;
                                      _selectFood("fruit");
                                      setState(() {
                                        category="fruit";
                                      });
                                    });
                                  },
                                  child: Card(
                                    color: fruit?ColorsUI.accentColor:ColorsUI.white,
                                    elevation: 2.0,
                                    child: Icon(
                                      MyFlutterApp.apple,
                                      color:  ColorsUI.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'fruta',
                                style:
                                TextStyle(fontSize: 12.0, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 60,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selected=true;
                                      _selectFood("vegetable");
                                      setState(() {
                                        category="vegetable";
                                      });
                                    });
                                  },
                                  child: Card(
                                    color: vegetable?ColorsUI.accentColor:ColorsUI.white,
                                    elevation: 2.0,
                                    child: Icon(
                                      MyFlutterAppVegetable.vegetable,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'legume',
                                style:
                                TextStyle(fontSize: 12.0, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                               width: 70,
                                height: 60,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selected=true;
                                      _selectFood("oil");
                                      setState(() {
                                        category="oil";
                                      });
                                    });
                                  },
                                  child: Card(
                                    color: oil?ColorsUI.accentColor:ColorsUI.white,
                                    elevation: 2.0,
                                    child: Icon(
                                     MyFlutterAppOil.oil,
                                      color: ColorsUI.accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'óleo',
                                style:
                                TextStyle(fontSize: 12.0, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 60,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selected=true;
                                      _selectFood("fish");
                                      setState(() {
                                        category="fish";
                                      });
                                    });
                                  },
                                  child: Card(
                                    color: fish?ColorsUI.accentColor:ColorsUI.white,
                                    elevation: 2.0,
                                    child: Icon(
                                      MyFlutterAppFish.fish,
                                      color: ColorsUI.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'peixe',
                                style:
                                TextStyle(fontSize: 12.0, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 60,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selected=true;
                                      _selectFood("fresh");
                                        category="fresh";
                                    });
                                  },
                                  child: Card(
                                    color: fresh?ColorsUI.accentColor:ColorsUI.white,
                                    elevation: 2.0,
                                    child: Icon(
                                      MyFlutterAppMeat.meat,
                                      color: Color(0xFFFFB4A8),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'frescos',
                                style:
                                TextStyle(fontSize: 12.0, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Expanded (
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: 70,
                                height: 60,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {

                                      selected=true;
                                      _selectFood("grao");
                                      category="grao";

                                    });
                                  },
                                  child: Card(
                                    color: grao?ColorsUI.accentColor:ColorsUI.white,
                                    elevation: 2.0,
                                    child: Icon(
                                     MyFlutterAppGrains.grains,
                                      color: ColorsUI.accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'grãos',
                                style:
                                TextStyle(fontSize: 12.0, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ])),
              ),
            ];
          },
          body: Container(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 0.0),
              child:Column(
                children: <Widget>[
                  // Insert the StreamBuilder to Fetch Product
                  Expanded(
                    child: !selected?_showMainStream(): _showSearchStream(),
                  ),
                  _showCircularProgress(),
                ],
              )


          )),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(0.0),
        child: Card(
          elevation: 10.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5.0),
                          topLeft: Radius.circular(5.0)),
                    ),
                    height: 50.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text('Total: ', style: TextStyle(fontSize: 16.0,)),
                            Text(  (cart==null || cart==0.0)?'0.00 AKZ':'${Helper.numberFormat(cart)} AKZ', style: TextStyle(fontSize: cart>10000?14.0: 16.0,)),
                          ]),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: ColorsUI.color4,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(5.0),
                          topRight: Radius.circular(5.0)),
                    ),
                    height: 50.0,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          productInCart.length>0?  Icon(Icons.add_shopping_cart, color: ColorsUI.accentColor,):  Icon(Icons.shopping_cart),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Carrinho', style: TextStyle(fontSize: cart>10000?14.0: 16.0,))
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context)=>Cart(product: productInCart,amount: cart,
                          cbAmount: (value){
                          setState(() {
                            cart=value;
                          });
                          },
                          user: this.user,
                          auth:widget.auth,
                          userId: widget.userId,
                        )
                    ));

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container ContainerIfSnapshotHasNotData() {
     return Container(width: 0.0, height: 0.0,);
  }

  StaggeredGridView StaggeredGridViewCountuBuilder(ImageProvider displayImage(String url)) {

    _isLoading=false;
     return StaggeredGridView.countBuilder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {

        Product product = products[index];
        return GestureDetector(
          onTap: () {
            _pushToDescription(context, product, index);
          },
          child: Container(
            height: 200,
            width: 20,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: ColorsUI.white,
                image: DecorationImage(
                  //Change Image
                    image: displayImage(product.img),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${product.name}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text('${Helper.numberFormat(product.price)} AKZ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0),
                        textAlign: TextAlign.start),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      staggeredTileBuilder: (index) =>
      new StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  void _pushToDescription(BuildContext context, Product product, int index) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DescriptionProduct( product: product,index: index,user: user,
                  onCountChange: (value){
                  setState(() {
                    cart+=value +.0;
                  });},onAddProduct: (value){
                     updateProductCartList(value);
                  }
                  )
        )
    );
  }

  void updateProductCartList(Product value) {
      setState(() {
          productInCart.add(value);
    });
  }
}
