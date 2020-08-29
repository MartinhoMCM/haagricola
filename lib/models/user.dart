
class User
{

  final String id;
  final String firstName;
  final String email;
  final String location;
  final String imageUrl;
  final String numberPhone;




  const User( {this.id,this.firstName,
    this.email, this.location, this.numberPhone,this.imageUrl});


  User.fromMap(Map snapshot, [String id]) :
        id = id ?? '',
        firstName = snapshot['firstName']  ?? '',
        email = snapshot['email'] ?? '',
        imageUrl = snapshot['image'] ?? '',
        numberPhone= snapshot['numberPhone'] ?? '',
        location =snapshot['location'] ?? '';



   toJson() {
    return {
      "id": id,
      "email": email,
      "firstName": firstName,
      "numberPhone":numberPhone,
      "location":location,
      "img":imageUrl
    };
  }
}
