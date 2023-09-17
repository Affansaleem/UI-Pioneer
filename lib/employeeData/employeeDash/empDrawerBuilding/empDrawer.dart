import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:project/bloc_internet/internet_bloc.dart';
import 'package:project/bloc_internet/internet_state.dart';
import 'empDrawerItems.dart';

class EmpDrawerItem {
  final String title;
  final IconData icon;

  const EmpDrawerItem({required this.title, required this.icon});
}

class MyDrawer extends StatelessWidget {
  final ValueChanged<EmpDrawerItem> onSelectedItems;

  const MyDrawer({super.key, required this.onSelectedItems});

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<InternetBloc, InternetStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {

          if(state is InternetGainedState){
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  Image.asset(
                    "assets/images/pioneer_logo_app1.png",
                    height: 150,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildDrawerItems(context),
                ],
              ),
            ),
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
          else {
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

  Widget buildDrawerItems(BuildContext context) =>
      Column(
        children: EmpDrawerItems.all
            .map(
              (item) =>
              ListTile(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: Icon(item.icon, color: Colors.black87),
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.grey, // Color of the shadow
                        offset: Offset(2, 2), // Offset of the shadow from the text
                        blurRadius: 3, // Blur radius of the shadow
                      ),
                      // You can add more Shadow objects for multiple shadows
                    ],
                  ),
                ),
                onTap: () => onSelectedItems(item),
              ),
        )
            .toList(),
      );
}
