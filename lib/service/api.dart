import 'package:cloud_firestore/cloud_firestore.dart';

class Api
{
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Api(this.path)
  {
    ref=_db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() => ref.getDocuments();

  Stream <QuerySnapshot> streamDataCollection() => ref.snapshots();

  Future<DocumentSnapshot> getDocumentById(String id) => ref.document(id).get();

  Stream<QuerySnapshot> streamDataCollectionCategory(String category)=>
      ref. where('category', isEqualTo: category).snapshots();

  Stream<QuerySnapshot> streamDataCollectionProductName(String productName)=>
      ref. where('name', isEqualTo: productName).snapshots();

  Future<void> removeDocument(String id)=>ref.document(id).delete();

  Future<void> updateDocument(Map data, String id)=> ref.document(id).updateData(data);

  Future<DocumentReference> addDocument(Map data)=>ref.add(data);



}



/*

Widget CategoryCard(int index){
  String productName;
  Icon icon;
  switch(index){
    case 0:
      productName="Frutas";
      icon =Icon(MyFlutterApp.apple, color: ColorsUI.primaryColor,);
      break;
    default:
      productName="Legumes";
      icon =Icon(MyFlutterApp.apple, color: ColorsUI.primaryColor,);

  }

  setState(() {
    index++;
  });
  return Column(
    children: <Widget>[
      Container(
        width:_width,
        height: _height,
        child: GestureDetector(
          onTap: (){

          },
          child: Card(
            elevation: 2.0,
            child:Icon(MyFlutterApp.apple, color: ColorsUI.primaryColor,),
          ),
        ),
      ),
      Text('$productName', style: TextStyle(fontSize: 12.0, color: Colors.grey),
      )
    ],
  );
}
*/
