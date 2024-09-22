import 'package:flutter/material.dart';
import 'package:meesho_dice/services/auth_service.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/widgets/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String? _confirmPassword;
  String? _username;
  bool loading = false;
  bool _isHidden = true;
  String errorMessage = '';

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Widget ErrorMessage() {
    if (errorMessage != '') {
      return SizedBox(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    } else
      return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return loading
        ? LoadingWidget()
        : Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/auth_background.jpg'),
                    fit: BoxFit.fill)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(width * 0.05, 30, width * 0.05, 0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: height * 0.28),
                          Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 30,
                                color: kMeeshoPurple,
                                fontFamily: "DancingScript",
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: height * 0.01),
                          TextFormField(
                            validator: (val) => val!.isEmpty
                                ? 'This is a required field'
                                : null,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black, fontSize: 19),
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                hintStyle: TextStyle(
                                    fontSize: 19, color: Colors.black87),
                                hintText: 'Email'),
                            onChanged: (val) {
                              setState(() {
                                _email = val;
                              });
                            },
                          ),
                          SizedBox(height: height * 0.02),
                          TextFormField(
                            validator: (val) => val!.isEmpty
                                ? 'This is a required field'
                                : null,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black, fontSize: 19),
                            obscureText: _isHidden,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 2)),
                              hintStyle: TextStyle(
                                  fontSize: 19, color: Colors.black87),
                              hintText: 'Password',
                              suffix: InkWell(
                                onTap: _togglePasswordView,
                                child: Icon(
                                  _isHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _password = val;
                              });
                            },
                          ),
                          SizedBox(height: height * 0.02),
                          TextFormField(
                            validator: (val) => val!.isEmpty
                                ? 'This is a required field'
                                : null,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black, fontSize: 19),
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                hintStyle: TextStyle(
                                    fontSize: 19, color: Colors.black87),
                                hintText: 'Confirm Password'),
                            onChanged: (val) {
                              setState(() {
                                _confirmPassword = val;
                              });
                            },
                          ),
                          SizedBox(height: height * 0.02),
                          TextFormField(
                            validator: (val) => val!.isEmpty
                                ? 'This is a required field'
                                : null,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black, fontSize: 19),
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                hintStyle: TextStyle(
                                    fontSize: 19, color: Colors.black87),
                                hintText: 'Name'),
                            onChanged: (val) {
                              setState(() {
                                _username = val;
                              });
                            },
                          ),
                          SizedBox(height: height * 0.02),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  elevation: 5),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (_password == _confirmPassword) {
                                    await AuthService()
                                        .registerWithEmailAndPassword(
                                            _email!, _password!, _username!);
                                  } else {
                                    setState(() {
                                      errorMessage =
                                          'Password and confirm password should be the same!';
                                    });
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 12),
                                child: Text('Proceed'),
                              )),
                          ErrorMessage(),
                          SizedBox(height: height * 0.01),

                          ///Adding the OR with horizontal line on each side
                          // Row(children: <Widget>[
                          //   Expanded(
                          //     child: new Container(
                          //         margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                          //         child: Divider(
                          //           color: Colors.white70,
                          //           height: 50,
                          //         )),
                          //   ),
                          //
                          //   Text("Or Register using",style: TextStyle( color: Colors.white70)),
                          //
                          //   Expanded(
                          //     child: new Container(
                          //         margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                          //         child: Divider(
                          //           color: Colors.white70,
                          //           height: 50,
                          //         )),
                          //   ),
                          // ]
                          // ),
                          // SizedBox(height: 20),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     ElevatedButton.icon(
                          //       icon: Icon(Icons.email_outlined,color: Colors.white,),
                          //       style: ElevatedButton.styleFrom(
                          //           primary: Colors.red,
                          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))
                          //       ),
                          //       onPressed: (){
                          //         print('Login using gmail account');
                          //       },
                          //       label: Text('Gmail',style: TextStyle(color: Colors.white)),
                          //     ),
                          //     SizedBox(width: 10),
                          //     ElevatedButton.icon(
                          //       icon: Icon(Icons.facebook_rounded,color: Colors.white,),
                          //       style: ElevatedButton.styleFrom(
                          //           primary: Colors.blue,
                          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))
                          //       ),
                          //       onPressed: (){
                          //         print('Login using facebook account');
                          //       },
                          //       label: Text('Facebook',style: TextStyle(color: Colors.white)),
                          //     ),
                          //     SizedBox(width: 10),
                          //     ElevatedButton.icon(
                          //       icon: Icon(Icons.map,color: Colors.white,),
                          //       style: ElevatedButton.styleFrom(
                          //           primary: Colors.blue,
                          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))
                          //       ),
                          //       onPressed: (){
                          //         print('Login using twitter account');
                          //       },
                          //       label: Text('Twitter',style: TextStyle(color: Colors.white)),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: height * 0.07),
                          Text('Already registered? Login',
                              style: TextStyle(color: Colors.black87)),
                          SizedBox(height: 5),
                          ElevatedButton(
                              onPressed: () {
                                widget.toggleView();
                              },
                              child: Text('Sign In')),
                        ],
                      )),
                ),
              ),
            ),
          );
  }
}
