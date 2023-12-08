import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nodejstoflutter/newlist.dart';
import 'package:nodejstoflutter/screens/onboding/components/signin_form_new.dart';
import 'package:nodejstoflutter/services/api.dart';

class LogInFormNew extends StatefulWidget {
  const LogInFormNew({super.key});

  @override
  State<LogInFormNew> createState() => _LogInFormNewState();
}

class _LogInFormNewState extends State<LogInFormNew> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(heightFactor: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Center(child: Image(image: AssetImage("lib/assets/images/rogeKare.png"))),
                      const Text(
                        "Email",
                        style: TextStyle(color: Colors.black54),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "";
                            }
                            return null;
                          },
                          controller: emailController,
                          onSaved: (email) {},
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SvgPicture.asset("lib/assets/icons/email.svg"),
                              )),
                        ),
                      ),
                      const Text(
                        "Şifre",
                        style: TextStyle(color: Colors.black54),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "";
                            }
                            return null;
                          },
                          controller: passwordController,
                          onSaved: (password) {},
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SvgPicture.asset("lib/assets/icons/password.svg"),
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                        child: ElevatedButton.icon(
                            onPressed: () {
                              var data={

                                "email":emailController.text,
                                "password":passwordController.text,
                              };
                              Api.login(context,data);

                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF75016E),
                                minimumSize: const Size(double.infinity, 56),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                        bottomLeft: Radius.circular(25)))),
                            icon: const Icon(
                              CupertinoIcons.arrow_right,
                              color: Color(0xFFFFFFFF),
                            ),
                            label: const Text("Giriş Yap",style: TextStyle(color: Colors.white),)),
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Abone değilseniz "),
                          GestureDetector(
                              onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => SignInFormNew(),));},
                              child: Text("Kayıt olun",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );

  }
}
