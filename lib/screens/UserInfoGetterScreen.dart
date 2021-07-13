import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoGetterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Easy',
                    style: GoogleFonts.catamaran(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Drive',
                    style: GoogleFonts.catamaran(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Text(
                'Designed for living in a better world.',
                style: GoogleFonts.catamaran(
                  color: Colors.black45,
                  fontSize: 11,
                ),
              ),
              SizedBox(height: 50),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.catamaran(
                        color: Colors.black45,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty ? 'Invalid Value' : null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 4),
                    // Password
                    Text(
                      'Password',
                      style: GoogleFonts.catamaran(
                        color: Colors.black45,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty ? 'Invalid Value' : null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Name',
                      style: GoogleFonts.catamaran(
                        color: Colors.black45,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty ? 'Invalid Value' : null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Continue',
                              style: GoogleFonts.catamaran(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: Size(100, 45),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
