
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ha_angricola/models/bank_account.dart';

class CRUD_Bank
{
  final Firestore _db = Firestore.instance;
  final String path="company_bank_data";
  CollectionReference ref;
  List<BankAccount> account;

  CRUD_Bank(){
    ref=_db.collection(path);
  }

  Future<List<BankAccount>> fetchAccount() async
  {
    var result = await ref.getDocuments();
    account =result.documents.map((doc)=>BankAccount.fromMap(doc.data, doc.documentID)).toList();
    return account;
  }

}
