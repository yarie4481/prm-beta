import 'package:beta_pm/screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ParticipantLoanApp extends StatefulWidget {
  @override
  _ParticipantLoanAppState createState() => _ParticipantLoanAppState();
}

class _ParticipantLoanAppState extends State<ParticipantLoanApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.latoTextTheme()),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int totalUsers = 49;
  final double totalLoanAmount = 200;
  final double outstandingBalance = 102;
  final String nextPaymentDueDate = "25 Aug 2024";
  final double repaymentProgress = 0.7; // 70% repayment

  // void showCustomModal(BuildContext context, String title, String content) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return MeetingModal(title: title, content: content);

  //       print("object");
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),

      backgroundColor: Colors.grey[100],
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Text("data"),
          // Main Header
          Container(
            width: double.infinity,
            height: 300.0,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Color(0xFF0D3FC6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                // Center(
                //   child: Text(
                //     "Main Header",
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 24,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                SizedBox(height: 50.0),

                // User info row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Users  ",
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        Text(
                          "26", // Replace with actual username
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 16, 50, 144),
                        // Set the background color of the container
                        borderRadius: BorderRadius.circular(
                          15,
                        ), // Set your desired border radius
                      ),
                      padding: EdgeInsets.all(
                        10,
                      ), // Optional: Add padding inside the container
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius:
                                20, // Set the radius for the circular avatar
                            // Replace with your image URL
                            // Alternatively, you can use backgroundColor if you want a solid color
                            // backgroundColor: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ), // Add some spacing between the avatar and the text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Test",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "SuperAdmin", // Replace with actual role
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(
                  "Sammery", // Replace with actual username
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                // Divider
                Divider(color: Colors.white, thickness: 1.0),
                SizedBox(height: 20.0),

                // Total info row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Super Admin",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "1", // Replace with actual count
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Tenants",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "10", // Replace with actual count
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Admins",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "15", // Replace with actual count
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: 300.0, // Adjust for overlap
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        // Secondary Header
                        SizedBox(height: 20),

                        // Cards Section
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            buildCard(
                              context,
                              "Property",
                              Icons.book,
                              25,
                              "Total Property",
                            ),
                            buildCard(
                              context,
                              "Tenants",
                              Icons.monetization_on,
                              15,
                              "Total Tenants",
                            ),
                            buildCard(
                              context,
                              "Aggrements",
                              Icons.group,
                              10,
                              "Total Agreements",
                            ),
                            buildCard(
                              context,
                              "Maintenance",
                              Icons.person,
                              50,
                              "Total Maintenance",
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
        ],
      ),
    );
  }

  Widget buildCard(
    BuildContext context,
    String title,
    IconData icon,
    int count,
    String bottomText,
  ) {
    return GestureDetector(
      onTap: () {
        // Add your onTap action here
        print("$title card tapped!");
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Colors.black),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            Divider(thickness: 1, color: Colors.grey[300]),
            SizedBox(height: 10),
            Text(
              bottomText,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "$count Records",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
