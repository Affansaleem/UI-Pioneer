import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:project/adminData/adminDash/adminDrawerPages/adminProfile_page/view_profile/adminProfile.dart';
import 'package:project/bloc_internet/internet_state.dart';

import '../../../../bloc_internet/internet_bloc.dart';
import 'admin_profile_bloc.dart';
import 'admin_profile_event.dart';
import 'admin_profile_state.dart';

class AdminProfilePage extends StatefulWidget {
  final VoidCallback openDrawer;

  AdminProfilePage({super.key, required this.openDrawer,});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {

  final AdminProfileBloc homeBloc = AdminProfileBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InternetBloc, InternetStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if(state is InternetGainedState)
        {
        return BlocConsumer<AdminProfileBloc, AdminProfileState>(
          bloc: homeBloc,
          listenWhen: (previous, current) => current is NavigateToViewPageState,
          buildWhen: (previous, current) => current is! NavigateToViewPageState,
          listener: (context, state) {
            // TODO: implement listener

            if (state is NavigateToViewPageState) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminViewPage(),
                  ));
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const FaIcon(FontAwesomeIcons.bars),
                  color: Colors.white,
                  onPressed: widget.openDrawer,
                ),
                backgroundColor: const Color(0xFFE26142),
                elevation: 0,
                title: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 55.0), // Add right padding
                    child: Text(
                      "ATTENDANCE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(
                        width: 150,
                        height: 150,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/icons/man.png'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "@Your Name",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'Cabin'),
                        ),
                      ),
                      Text(
                        "@Your Email/Username",
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.amberAccent),
                        ),
                        onPressed: () {
                          homeBloc.add(AdminNavigateToViewPageEvent());
                        },
                        child: const Text(
                          "View Profile",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 30,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),

                      // Menu
                      const tileWidget(title: 'Settings', icon: Icons.settings),
                      const tileWidget(
                          title: 'Billing Details', icon: Icons.payment),
                      const tileWidget(
                          title: 'User Management',
                          icon: Icons.supervised_user_circle_sharp),
                      const Divider(
                        color: Colors.grey,
                        height: 30,
                        thickness: 1,
                      ),
                      const tileWidget(
                          title: 'Information', icon: Icons.info_outline),
                      const tileWidget(title: 'Logout', icon: Icons.logout),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
        else if(state is InternetLostState)
          {
            return Expanded(
              child: Scaffold(
                body: Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No Internet Connection!",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Lottie.asset('assets/no_wifi.json'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        else{
          return Expanded(
            child: Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Internet Connection!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Lottie.asset('assets/no_wifi.json'),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      }
    );
  }
}

class tileWidget extends StatelessWidget {
  final String title;
  final IconData icon;

  const tileWidget({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.amber,
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.navigate_next),
    );
  }
}
