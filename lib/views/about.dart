import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AboutState();
}

class AboutState extends State<About> {
  String content =
      "HA-Agrícola comercial é uma empresa Angolana, focalizada no comércio dos melhores produtos agrícolas produzidos em Angola.\n"
      "A nossa missão é levar para sua mesa ou estabelecimento de todos os cidadãos residentes em Angola, produtos de elevada qualidade produzidos nas 18 províncias de Angola.\n\n"
      "Localização:\n"
      "Contactos: 926 292 825 / 940 116 796\n"
      "Whatsapp: 915 606 795 / 995 350 508\n"
      "Facebook: HA-Agrícola\n"
      "Email: haagricola77@gmail.com";

  Future<Map<Permission, PermissionStatus>> statuses;

  @override
  void initState() {

    super.initState();
  }

  _loadPermission(){
    statuses = [
      Permission.phone,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    String phone = "915606795";
    String urlHaAgricolaFacebook =
        "https://web.facebook.com/HA-Agr%C3%ADcola-Lda-II-100890604965436";
    String PhoneCall = "tel:+244 926 292 825";
    var WhatsappUrl = "whatsapp://send?phone=$phone";

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('HA-Agrícola')),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 0.0, left: 0.0, right: 0.0, bottom: 0.0),
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              width: 420,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0)),
                  image: DecorationImage(
                      image: AssetImage('images/main_logo.jpeg'), fit: BoxFit.cover)),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
              child: Text(
                '$content',
                style: TextStyle(
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
              child: Text(
                'Acesso Directo: ',
                style: TextStyle(
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.justify,
              ),
            ),


            Container(
              margin: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0)),
                          image: DecorationImage(
                              image: AssetImage("images/gmail.png"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Container(
                    width: 10.0,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 35,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0)),
                          image: DecorationImage(
                              image: AssetImage("images/facebook.png"),
                              fit: BoxFit.cover)),
                    ),
                    onTap: () {
                      _launchURL(urlHaAgricolaFacebook);
                    },
                  ),
                  Container(
                    width: 10.0,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0)),
                          image: DecorationImage(
                              image: AssetImage("images/whatsapp.png"),
                              fit: BoxFit.cover)),
                    ),
                    onTap: () {
                      _launchURL(WhatsappUrl);
                    },
                  ),
                  Container(
                    width: 10.0,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 35,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0)),
                          image: DecorationImage(
                            image: AssetImage("images/call.png"),
                          )),
                    ),
                    onTap: () {
                      _launchURL(PhoneCall);
                      _loadPermission();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      debugPrint('Ope url');
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
