import 'package:driving_app_its/app/routes/app_routes.dart';
import 'package:driving_app_its/app/ui/global_widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Text(
                "Cab",
                style: GoogleFonts.catamaran(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 20),
            _DrawerTile(
              isSelected: true,
              title: 'Contact us',
              icon: Icons.mail,
              onTap: () {
                Get.toNamed(AppRoutes.CONTACT);
              },
            ),
            const VerticalSpacer(),
            _DrawerTile(
              isSelected: false,
              title: 'Sign out',
              icon: Icons.exit_to_app,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed(AppRoutes.SPLASH);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        selected: isSelected,
        selectedColor: Colors.white,
        selectedTileColor: Colors.green,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
          right: Radius.circular(9999.0),
        )),
        onTap: onTap,
      ),
    );
  }
}
