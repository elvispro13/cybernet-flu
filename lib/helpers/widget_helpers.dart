import 'package:cybernet/helpers/size_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget appPrincipal(
    {required Widget child,
    required String titulo,
    Widget bottomSheet = const SizedBox()}) {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  return Scaffold(
    key: scaffoldKey,
    drawer: Drawer(
      child: Container(
        color: Colors.white,
      ),
    ),
    appBar: AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          scaffoldKey.currentState!.openDrawer();
        },
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: const Image(image: AssetImage('assets/logo.png'), width: 50),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: child,
      ),
    ),
    bottomSheet: bottomSheet,
  );
}

Widget appPrincipalSinSlide({
  required Widget child,
  required String titulo,
  required Function()? onBack,
  Widget footer = const SizedBox(),
}) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
        onPressed: onBack,
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: const Image(image: AssetImage('assets/logo.png'), width: 50),
          ),
          const SizedBox(width: 10),
          Text(
            titulo,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ],
      ),
    ),
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: child,
          ),
          footer,
        ],
      ),
    ),
  );
}

Widget btScreenPrincipal(
    {required String label, required FaIcon icono, Function()? onPressed}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: const TextStyle(fontSize: 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icono,
          Expanded(
            child: Center(child: Text(label)),
          ),
        ],
      ),
    ),
  );
}

void modalGeneral(BuildContext context, Widget hijo) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return hijo;
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}

void modalGeneralInferiror(BuildContext context, Widget hijo) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Container(
          width: SizeConfig.screenWidth! * 0.95,
          margin: EdgeInsets.only(top: SizeConfig.screenHeight! * 0.50),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.bottomCenter,
            child: hijo,
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(0, 1), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}
