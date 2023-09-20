import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/bloc_internet/internet_bloc.dart';
import 'package:project/bloc_internet/internet_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Login Page/login_bloc/loginbloc.dart';
import '../../../Login Page/login_page.dart';
import '../empDrawerPages/EmpReports/reports_page_employee.dart';
import '../empDrawerPages/empProfilePage/profilepage.dart';
import '../employee_Dashboard_Bloc/EmpDashboardk_bloc.dart';
import 'empDash/empDashHome.dart';
import 'empDrawer.dart';
import 'empDrawerItems.dart';

class EmpMainPage extends StatefulWidget {
  const EmpMainPage({Key? key}) : super(key: key);

  @override
  State<EmpMainPage> createState() => _EmpMainPageState();
}

class _EmpMainPageState extends State<EmpMainPage> {
  final EmpDashboardkBloc dashBloc = EmpDashboardkBloc();
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
  EmpDrawerItem item = EmpDrawerItems.home;

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
            // backgroundColor: const Color(0xFF454545),
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/ideogram.jpeg"),
                      // Replace with your image path
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                buildDrawer(),
                buildPage(),
              ],
            ),
          );
        }
        else if (state is InternetLostState) {
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
        } else {
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
      });

  Widget buildDrawer() => SafeArea(
        child: AnimatedOpacity(
          opacity: isDrawerOpen ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Container(
            width: xoffset,
            child: MyDrawer(
              onSelectedItems: (selectedItem) {
                setState(() {
                  item = selectedItem;
                  closeDrawer();
                });

                switch (item) {
                  case EmpDrawerItems.home:
                    dashBloc.add(NavigateToHomeEvent());
                    break;

                  case EmpDrawerItems.reports:
                    dashBloc.add(NavigateToReportsEvent());
                    break;

                  case EmpDrawerItems.profile:
                    dashBloc.add(NavigateToProfileEvent());
                    break;

                  case EmpDrawerItems.logout:
                    dashBloc.add(NavigateToLogoutEvent());
                    break;

                  default:
                    dashBloc.add(NavigateToLogoutEvent());
                    break;
                }
              },
            ),
          ),
        ),
      );

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
                    : const Color(0xFFFAF9F6),
                child: getDrawerPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDrawerPage() {
    return BlocBuilder<EmpDashboardkBloc, EmpDashboardkState>(
      bloc: dashBloc,
      builder: (context, state) {
        if (state is NavigateToProfileState) {
          return EmpProfilePage(openDrawer: openDrawer);
        } else if (state is NavigateToHomeState) {
          return EmpDashboard(openDrawer: openDrawer);
        } else if (state is NavigateToReportsState) {
          return EmpReportsPage(
            openDrawer: openDrawer,
          );
        } else if (state is NavigateToLogoutState) {
          return AlertDialog(
            title: Text("Confirm Logout"),
            content: Text("Are you sure?"),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EmpMainPage(),),);// Close the dialog
                },
              ),
              TextButton(
                child: Text('Logout'),
                onPressed: () {
                  // Add the logic to perform logout here
                  _logout(context); // Close the dialog
                },
              ),
            ],
          );
        } else {
          return EmpDashboard(openDrawer: openDrawer);
        }
      },
    );
  }
}
