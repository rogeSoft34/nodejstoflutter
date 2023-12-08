import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class AnimatedBtn1 extends StatelessWidget {
  const AnimatedBtn1({
    super.key,
    required RiveAnimationController btnAnimationController,
    required this.press1,
  }) : _btnAnimationController = btnAnimationController;

  final RiveAnimationController _btnAnimationController;
  final VoidCallback press1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press1,
      child: SizedBox(
        height: 64,
        width: 260,
        child: Stack(children: [
          RiveAnimation.asset(
            "lib/assets/RiveAssets/button.riv",
            controllers: [_btnAnimationController],
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
                  Text("Giriş yap",
                      style: TextStyle(fontWeight: FontWeight.w600))
                ],
              )),
        ]),
      ),
    );
  }
}
