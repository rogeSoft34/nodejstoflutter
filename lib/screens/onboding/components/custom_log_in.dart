import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nodejstoflutter/screens/onboding/components/log_in_form.dart';
import 'package:nodejstoflutter/screens/onboding/components/sign_in_form.dart';



Future<Object?> customSigninDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "Giriş Yap",
      context: context,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        Tween<Offset> tween = Tween(begin: Offset(0, -1), end: Offset.zero);
        return SlideTransition(
            position: tween.animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child);
      },
      pageBuilder: (context, _, __) => Center(
            child: Container(
              height: 620,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: const BorderRadius.all(Radius.circular(40))),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset:
                    false, // avoid overflow error when keyboard shows up
                body: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(children: [
                      const Text(
                        "Giriş Yap",
                        style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "EasyList ile kolayca müşterilerinize fiyat listesi sunabilirsiniz.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const LogInForm(),
                     /* const Row(
                        children: [
                          Expanded(
                            child: Divider(),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "OR",
                              style: TextStyle(color: Colors.black26),
                            ),
                          ),
                          Expanded(
                            child: Divider(),
                          ),
                        ],
                      ),*/
                      /*const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Text("Sign up with Email, Apple or Google",
                            style: TextStyle(color: Colors.black54)),
                      ),*/
                 /*     Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                "/lib/assets/icons/email_box.svg",
                                height: 44,
                                width: 44,
                              )),
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                "/lib/assets/icons/apple_box.svg",
                                height: 44,
                                width: 44,
                              )),
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                "lib/assets/icons/google_box.svg",
                                height: 44,
                                width: 44,
                              ))
                        ],
                      )*/
                    ]),
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: -48,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.close, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )).then(onClosed);
}
