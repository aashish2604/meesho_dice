import 'package:flutter/material.dart';
import 'package:meesho_dice/services/auth_service.dart';

class Login extends StatefulWidget {
  final Function toggleView;

  const Login({super.key, required this.toggleView});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      // decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/auth.jpg'),fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(width * 0.05, 30, width * 0.05, 0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      height: height * 0.38,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            'LOGIN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "DancingScript",
                                fontSize: 30,
                                color: Color(0xFF4B2711)),
                          ),
                          SizedBox(height: height * 0.01),
                          TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? 'Enter email' : null,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white, fontSize: 19),
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),
                                hintStyle: TextStyle(
                                    fontSize: 19, color: Colors.white70),
                                hintText: 'Email'),
                            onChanged: (val) {
                              setState(() {
                                _email = val;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white, fontSize: 19),
                            obscureText: _isHidden,
                            validator: (val) =>
                                val!.isEmpty ? 'Enter Password' : null,
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              hintStyle: TextStyle(
                                  fontSize: 19, color: Colors.white70),
                              hintText: 'Password',
                              suffix: InkWell(
                                onTap: _togglePasswordView,
                                child: Icon(
                                  _isHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            onChanged: (val) {
                              setState(() {
                                _password = val;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  elevation: 5),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await AuthService()
                                      .signInWithEmailAndPassword(
                                          _email!, _password!);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontSize: 15),
                                ),
                              )),

                          SizedBox(height: 10),

                          ///Adding the OR with horizontal line on each side
                          //         Row(children: <Widget>[
                          //           Expanded(
                          //             child: new Container(
                          //                 margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                          //                 child: Divider(
                          //                   color: Colors.white70,
                          //                   height: 50,
                          //                 )),
                          //           ),
                          //
                          //           Text("Or Sign In using",style: TextStyle( color: Colors.white70),),
                          //
                          //           Expanded(
                          //             child: new Container(
                          //                 margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                          //                 child: Divider(
                          //                   color: Colors.white70,
                          //                   height: 50,
                          //                 )),
                          //           ),
                          //         ]
                          // ),
                          //         SizedBox(height: 20),
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //           children: [
                          //             ElevatedButton.icon(
                          //               icon: Icon(Icons.email_outlined,color: Colors.white,),
                          //                 style: ElevatedButton.styleFrom(
                          //                   primary: Colors.red,
                          //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))
                          //                 ),
                          //                 onPressed: (){
                          //                   print('Login using gmail account');
                          //                 },
                          //                 label: Text('Gmail',style: TextStyle(color: Colors.white)),
                          //             ),
                          //             SizedBox(width: 10),
                          //             ElevatedButton.icon(
                          //               icon: Icon(Icons.facebook_rounded,color: Colors.white,),
                          //               style: ElevatedButton.styleFrom(
                          //                   primary: Colors.blue,
                          //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))
                          //               ),
                          //               onPressed: (){
                          //                 print('Login using facebook account');
                          //               },
                          //               label: Text('Facebook',style: TextStyle(color: Colors.white)),
                          //             ),
                          //             SizedBox(width: 10),
                          //             ElevatedButton.icon(
                          //               icon: Icon(Icons.map,color: Colors.white,),
                          //               style: ElevatedButton.styleFrom(
                          //                   primary: Colors.blue,
                          //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))
                          //               ),
                          //               onPressed: (){
                          //                 print('Login using twitter account');
                          //               },
                          //               label: Text('Twitter',style: TextStyle(color: Colors.white)),
                          //             ),
                          //           ],
                          //         ),
                          SizedBox(height: height * 0.08),
                          Text(
                            'New User? Register',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 5),
                          ElevatedButton(
                              onPressed: () {
                                widget.toggleView();
                              },
                              child: Text('Create new Account')),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
