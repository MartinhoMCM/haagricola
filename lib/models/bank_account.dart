class BankAccount{

  String name;
  String account_number;
  String iban;

  BankAccount({this.name, this.account_number, this.iban});

  BankAccount.fromMap(Map snapshot, [String id]):
      name=snapshot['name'],
      account_number=snapshot['account_number'],
        iban=snapshot['iban'];

}