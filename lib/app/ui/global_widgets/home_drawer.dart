import 'package:driving_app_its/app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListTile(
              title: Center(
                child: Text(
                  'Contact us',
                  style: GoogleFonts.catamaran(
                    color: Colors.green,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: const BorderSide(color: Colors.green, width: 1.0),
              ),
              onTap: () {
                Get.toNamed(AppRoutes.CONTACT);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Center(
                child: Text(
                  'Sign out',
                  style: GoogleFonts.catamaran(
                    color: Colors.green,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: const BorderSide(color: Colors.green, width: 1.0),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed(AppRoutes.SPLASH);
              },
            ),
          ),
        ],
      ),
    );
  }
}
