import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nodejstoflutter/screens/onboding/components/animated_btn.dart';
import 'package:nodejstoflutter/screens/onboding/components/animated_btn1.dart';
import 'package:nodejstoflutter/screens/onboding/components/custom_sign_in.dart';
import 'package:nodejstoflutter/screens/onboding/components/login_form_new.dart';
import 'package:nodejstoflutter/screens/onboding/components/signin_form_new.dart';
import 'package:rive/rive.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: 200,
            left: 100,
            child: Image.asset('lib/assets/Backgrounds/Spline.png')),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
        )),
        const RiveAnimation.asset('lib/assets/RiveAssets/shapes.riv'),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
          child: const SizedBox(),
        )),
        AnimatedPositioned(
          duration: Duration(milliseconds: 240),
          top: isSignInDialogShown ? -50 : 0,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    const SizedBox(
                      width: 260,
                      child: Column(children: [
                        Text(
                          "EasyList & Rogesoft",
                          style: TextStyle(
                              fontSize: 60, fontFamily: "Poppins", height: 1.2),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                            "EasyList ile zaman kazanın.")
                      ]),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    /*AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;
                        Future.delayed(Duration(milliseconds: 800), () {
                          setState(() {
                            isSignInDialogShown = true;
                          });
                          customSigninDialog(context, onClosed: (_) {
                            setState(() {
                              isSignInDialogShown = false;
                            });
                          });
                        });
                      },
                    ),*/
    GestureDetector(
    onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => LogInFormNew(),));},
    child: SizedBox(
    height: 64,
    width: 260,
    child: Stack(children: [
    RiveAnimation.asset(
    "lib/assets/RiveAssets/button.riv",

    ),
    const Positioned.fill(
    top: 8,
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(CupertinoIcons.arrow_right),
    SizedBox(
    width: 8,
    ),
    Text("Giriş Yap",
    style: TextStyle(fontWeight: FontWeight.w600))
    ],
    )),
    ]),
    ),
    ),
                    const Spacer(
                      flex: 1,
                    ),
                    GestureDetector(
                      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SignInFormNew(),));},
                      child: SizedBox(
                        height: 64,
                        width: 260,
                        child: Stack(children: [
                          RiveAnimation.asset(
                            "lib/assets/RiveAssets/button.riv",

                          ),
                          const Positioned.fill(
                              top: 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.arrow_right),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text("Kayıt Ol",
                                      style: TextStyle(fontWeight: FontWeight.w600))
                                ],
                              )),
                        ]),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Text(
                        "Anlık Tekliflendirme hiç bukadar kolay olmamaıştı.",
                        style: TextStyle(),
                      ),
                    )
                  ]),
            ),
          ),
        )
      ],
    ));
  }
}
