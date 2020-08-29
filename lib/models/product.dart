class Product
{
  String id;
  int price;
  String name;
  String img;
  int weight;
  String description;
  String category;
  int quantity;
  //Amonut is usual to add cart a product.
  //Example, if a product costs 200 AKZ, and the client want to buy 2 quantities, amount will be 2*200 AKZ =400AKZ ,
  //In other away to understand amount=quantity*price
  double amount;

  Product(this.id, this.price, this.name,this.category, this.amount, [this.img, this.weight, this.description]);

  Product.fromMap(Map snapshot,[String id]) :
        id = id ?? '',
        price = snapshot['price'] ?? '',
        name = snapshot['name'] ?? '',
        img = snapshot['img'] ?? '',
        weight =snapshot['weight'],
        description=snapshot['description'],
        category =snapshot['category'],
        quantity =snapshot['unity'],
        amount=snapshot['amount'];



   Map toJson() {
    return {
      "price": price,
      "name": name,
      "img": img,
      "unity":quantity,
      "amount":amount
    };
  }
}

