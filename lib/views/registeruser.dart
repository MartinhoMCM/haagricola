/*


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ha_angricola/controller/colorsUI.dart';
import 'package:ha_angricola/controller/validators.dart';
import 'package:ha_angricola/main.dart';
import 'package:ha_angricola/views/loginUser.dart';


class RegisterUI extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterUIState();
  }
}

class _RegisterUIState extends State<RegisterUI>{

  final GlobalKey<FormState> _formkey =GlobalKey<FormState>();
  bool _autoValidate=false;
  String _name;
  String  _email;
  String _password;
  String  _phoneNumber;

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title:Text('Sign Up',textAlign: TextAlign.center,),
      ),
      body: new SingleChildScrollView(
        child: new Container(
          margin:  new EdgeInsets.all(15.0),
          child: new Form(
            key: _formkey,
              autovalidate: _autoValidate,
              child: FormUI()),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    widget.aut
  }

  Widget FormUI() {
    return new Column(

      children: <Widget>[
        new TextFormField(
          decoration: const InputDecoration(labelText: 'Nome'),
          keyboardType: TextInputType.text,
          validator: Validators.validateName,
          onSaved: (String val) {
            _name = val;
          },
        ),
        new TextFormField(
          decoration: const InputDecoration(labelText: 'Palavra Passe'),
          keyboardType: TextInputType.visiblePassword,
          validator: Validators.validatePassword,
          onSaved: (String val) {
            _password = val;
          },
        ),
        new TextFormField(
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateEmail,
          onSaved: (String val) {
            _email = val;
          },
        ),
        new SizedBox(
          height: 10.0,
        ),
        new TextFormField(
          decoration: const InputDecoration(

              labelText: 'Número'),
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateMobile,
          onSaved: (String val) {
            _phoneNumber = val;
          },
        ),
        new SizedBox(
          height: 10.0,
        ),

        Container(
          margin: EdgeInsets.only(left: 16.0, top: 16.0),
          child: Column(

            children: <Widget>[
              new RaisedButton(
                onPressed: _validateInputs,
                child: new Text('REGISTRAR'),
                color:ColorsUI.primaryColor,
              ),
              new Container(
                margin: EdgeInsets.all(4.0),
                child: Text("ou"),
              ),
              new RaisedButton(
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      LoginUser()));
                },
                child: new Text('Fazer o Login'),
                color: ColorsUI.accentColor
              ),
            ],
          ),
        ),

      ],
    );
  }
  void  _validateInputs(){
    if(_formkey.currentState.validate())
    {
      _formkey.currentState.save();

      Navigator.push(context, MaterialPageRoute(builder: (context)=>
          MyHomePage()));
    }
    else{
      setState(() {
        _autoValidate=true;
      });

    }
  }


  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

}*/
import 'package:flutter/material.dart';
import 'package:ha_angricola/helper/colorsUI.dart';
import 'package:ha_angricola/service/authentication.dart';


class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _name;
  String _location;
  String _phoneNumber;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;


  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {

          userId = await widget.auth.signUp(_email, _password, _name, _location, _phoneNumber);
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');

          if(userId != null ){
            showDialog(context: context, builder: (BuildContext context)
            {
              return _showCardDialog(context);
            });
          }

        }
        setState(() {

          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
           widget.loginCallback();

        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(_isLoginForm ? 'Login' : 'Criar uma conta'),
        ),
        body: Stack(
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
          ],
        ));
  }


  _showCardDialog(BuildContext context)
  {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 10.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }
  dialogContent(BuildContext context) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),

      ),
      child: Container(
        width: 60.0,
        height: 150.0,
        margin: EdgeInsets.all(0.0),
         child: Column(
           children: <Widget>[
             Container(
               margin: EdgeInsets.all(8.0),
                 child: Text('Sejam Bem Vindo. Agora faca o login',style: TextStyle(fontSize: 14.0), ) ,),
             Container(
                 margin: EdgeInsets.all(8.0),
                 child: Icon(Icons.check_circle_outline, color: ColorsUI.accentColor, size: 60.0,)),
           ],
         ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(backgroundColor: ColorsUI.primaryColor,));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showEmailName(),
              showEmailInput(),
              showPasswordInput(),
              showLocationInput(),
              showNumberInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('images/logo.jpg'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Palavra Passe',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Palavra Passe não pode ser vazia' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showLocationInput() {
    return Visibility(
      visible: !_isLoginForm,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          autofocus: false,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
              hintText: 'Localização, ex.:(Luanda, Kilamba, casa nº 355)',
              icon: new Icon(
                Icons.location_on,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Palavra Passe não pode ser vazia' : null,
          onSaved: (value) => _location = value.trim(),
        ),
      ),
    );
  }

  Widget showEmailName() {
    return Visibility(
      visible: !_isLoginForm,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Nome',
              icon: new Icon(
                Icons.person,
                color: Colors.grey,
              )),
          validator: (value) => value.isEmpty ? 'Nome nao pode ser vazio' : null,
          onSaved: (value) => _name = value.trim(),
        ),
      ),
    );
  }

Widget showNumberInput() {
  return Visibility(
    visible: !_isLoginForm,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        keyboardType: TextInputType.phone,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Número tel.',
            icon: new Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Numero do telefone não pode ser vazio' : null,
        onSaved: (value) => _phoneNumber = value.trim(),
      ),
    ),
  );
}

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Cria uma conta' : 'Tens uma conta? Entrar',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: ColorsUI.primaryColor,
            child: new Text(_isLoginForm ? 'Entrar' : 'Criar uma conta',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit
          ),
        ));
  }
}