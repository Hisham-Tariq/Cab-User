import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driving_app_its/controller/controller.dart';
import 'package:driving_app_its/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../routes/paths.dart';

class RideFeedBackScreen extends StatelessWidget {
  RideFeedBackScreen({Key? key}) : super(key: key);
  int rideRating = 3;
  int driverRating = 3;
  int appRating = 3;
  var comment = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 0.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'How was client behaviour',
                            style: GoogleFonts.catamaran(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Center(
                          child: RatingBar.builder(
                            initialRating: rideRating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            glowColor: Colors.green.shade200,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.green,
                              size: 50,
                            ),
                            onRatingUpdate: (rating) {
                              rideRating = rating.toInt();
                            },
                          ),
                        ),
                        const VerticalAppSpacer(space: 24.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'How is app working?',
                            style: GoogleFonts.catamaran(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Center(
                          child: RatingBar.builder(
                            initialRating: driverRating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            glowColor: Colors.green.shade200,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.green,
                              size: 50,
                            ),
                            onRatingUpdate: (rating) {
                              driverRating = rating.toInt();
                            },
                          ),
                        ),
                        const VerticalAppSpacer(space: 24.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'How is app working?',
                            style: GoogleFonts.catamaran(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        Center(
                          child: RatingBar.builder(
                            initialRating: appRating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            glowColor: Colors.green.shade200,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.green,
                              size: 50,
                            ),
                            onRatingUpdate: (rating) {
                              appRating = rating.toInt();
                            },
                          ),
                        ),
                        const VerticalAppSpacer(space: 24.0),
                        Row(children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Any Comment',
                              style: GoogleFonts.catamaran(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ]),
                        const VerticalAppSpacer(space: 4.0),
                        TextField(
                          minLines: 6,
                          maxLines: 10,
                          controller: comment,
                          style: GoogleFonts.catamaran(
                            fontSize: 14.0,
                            color: Colors.grey.shade700,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        const VerticalAppSpacer(space: 12.0),
                        FullOutlinedTextButton(
                          onPressed: () async {
                            var currentBooking =
                                Get.find<UserController>().user.currentBooking;
                            await FirebaseFirestore.instance
                                .collection('BookedTrips')
                                .doc(currentBooking)
                                .collection('feedback')
                                .doc('user')
                                .set({
                              'appRating': appRating,
                              'driverRating': driverRating,
                              'rideRating': rideRating,
                              'comment': comment.text,
                              'filledAt': FieldValue.serverTimestamp(),
                            });
                            printInfo(info: 'Feedback has been uploaded');
                            Get.offAllNamed(AppPaths.tripBooking);
                          },
                          text: 'Submit',
                          backgroundColor: Colors.white.withOpacity(0.0),
                        ),
                        const VerticalAppSpacer(space: 12.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Ride Finished',
                      style: GoogleFonts.catamaran(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.clear_rounded,
                size: 32,
              ),
              onPressed: () => Get.offAllNamed(AppPaths.tripBooking),
            ),
          ],
        ),
      ),
    );
  }
}
