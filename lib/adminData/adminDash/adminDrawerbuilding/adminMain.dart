import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/Login%20Page/login_page.dart';
import 'package:project/bloc_internet/internet_bloc.dart';
import 'package:project/bloc_internet/internet_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Login Page/login_bloc/loginbloc.dart';
import '../adminDashBloc/admin_dash_bloc.dart';
import '../adminDrawerPages/AdminReports_page/adminScreens/adminReports_page.dart';
import '../adminDrawerPages/adminLogout/adminHomepage.dart';
import '../adminDrawerPages/adminMap/adminMapdisplay.dart';
import '../adminDrawerPages/adminProfile_page/adminProfilePage.dart';
import 'admindDrawer.dart';
import 'adminDraweritems.dart';
import 'admindash/adminHome.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _MainPageState();
}

class _MainPageState extends State<AdminMainPage> {
  final AdminDashBloc dashBloc = AdminDashBloc();

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('Login', false); // Set the login status to false

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Builder(
            builder: (context) => BlocProvider(
              create: (context) => SignInBloc(),
              child: LoginPage(),
            ),
          ); // Navigate back to LoginPage
        },
      ),
    );
  }

  late double xoffset;
  late double yoffset;
  late double scaleFactor;
  bool isDragging = false;
  bool isDrawerOpen = false;
  DrawerItem item = DrawerItems.home;

  @override
  void initState() {
    super.initState();
    closeDrawer();
  }

  void openDrawer() {
    setState(() {
      xoffset = 230;
      yoffset = 170;
      scaleFactor = 0.6;
      isDrawerOpen = true;
    });
  }

  void closeDrawer() {
    setState(() {
      xoffset = 0;
      yoffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<InternetBloc, InternetStates>(listener: (context, state) {
        // TODO: implement listener
      }, builder: (context, state) {
        if (state is InternetGainedState) {
          return Scaffold(
            // setting background color of drawer
            backgroundColor: const Color(0xFFFAF9F6),
            body: Stack(
              children: [
                buildDrawer(),
                buildPage(),
              ],
            ),
          );
        } else if (state is InternetLostState) {
          return Expanded(
            child: Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No Internet Connection!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Lottie.asset('assets/no_wifi.json'),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Expanded(
            child: Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No Internet Connection!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
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
      });

  Widget buildDrawer() =>
      BlocConsumer<InternetBloc, InternetStates>(listener: (context, state) {
        // TODO: implement listener
      }, builder: (context, state) {
        if (state is InternetGainedState) {
          return SafeArea(
            child: AnimatedOpacity(
              opacity: isDrawerOpen ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: xoffset,
                child: MyDrawer(
                  onSelectedItems: (selectedItem) {
                    setState(() {
                      item = selectedItem;
                      closeDrawer();
                    });

                    switch (item) {
                      case DrawerItems.home:
                        dashBloc.add(NavigateToHomeEvent());
                        break;

                      case DrawerItems.geofence:
                        dashBloc.add(NavigateToGeofenceEvent());
                        break;

                      case DrawerItems.reports:
                        dashBloc.add(NavigateToReportsEvent());
                        break;

                      case DrawerItems.profile:
                        dashBloc.add(NavigateToProfileEvent());
                        break;

                      case DrawerItems.logout:
                        dashBloc.add(NavigateToLogoutEvent());
                        break;

                      default:
                        dashBloc.add(NavigateToHomeEvent());
                        break;
                    }
                  },
                ),
              ),
            ),
          );
        } else if (state is InternetLostState) {
          return Expanded(
            child: Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No Internet Connection!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Lottie.asset('assets/no_wifi.json'),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Expanded(
            child: Scaffold(
              body: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No Internet Connection!",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
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
      });

  Widget buildPage() {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpen) {
          closeDrawer();
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: closeDrawer,
        onHorizontalDragStart: (details) => isDragging = true,
        onHorizontalDragUpdate: (details) {
          const delta = 1;

          if (!isDragging) return;

          if (details.delta.dx > delta) {
            openDrawer();
          } else if (details.delta.dx < -delta) {
            closeDrawer();
          }
          isDragging = false;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.translationValues(xoffset, yoffset, 0)
            ..scale(scaleFactor),
          child: AbsorbPointer(
            absorbing: isDrawerOpen,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0),
              child: Container(
                color: isDrawerOpen
                    ? Colors.white12.withOpacity(0.23)
                    : const Color(0xFFFDF7F5),
                child: getDrawerPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerPage() {
    return BlocBuilder<AdminDashBloc, AdminDashboardkState>(
      bloc: dashBloc,
      builder: (context, state) {
        if (state is NavigateToProfileState) {
          return AdminProfilePage(openDrawer: openDrawer);
        } else if (state is NavigateToGeofenceState) {
          return AdminMapDisplay(
            openDrawer: openDrawer,
          );
        } else if (state is NavigateToHomeState) {
          return AdminDashboard(openDrawer: openDrawer);
        } else if (state is NavigateToReportsState) {
          return AdminReportsPage(
            openDrawer: openDrawer,
          );
        } else if (state is NavigateToLogoutState) {
          return AlertDialog(
            title: const Text("Confirm Logout"),
            content: const Text("Are you sure?"),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminMainPage(),
                    ),
                  ); // Close the dialog
                  // Close the dialog
                },
              ),
              TextButton(
                child: const Text('Logout'),
                onPressed: () {
                  // Add the logic to perform logout here
                  _logout(context); // Close the dialog
                },
              ),
            ],
          );
        } else {
          return AdminDashboard(openDrawer: openDrawer);
        }
      },
    );
  }
}
