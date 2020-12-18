import 'package:flutter/material.dart';
import 'package:overlay_container/overlay_container.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Overlay Container example",
      home: HomeMainView(),
    );
  }
}

class HomeMainView extends StatefulWidget {
  @override
  _HomeMainViewState createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> {
  final OverlayContainerController controller = new OverlayContainerController();
  int selectedIndex = 0;

  @override
  void dispose() { 
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayContainerViewWidget(
      context: context,
      controller: controller,
      duration: Duration(milliseconds: 400),
      child: Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButtonViewWidget(
                item: items[0],
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                  controller.close();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButtonViewWidget(
                    item: items[1],
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                      controller.close();
                    },
                  ),
                  SizedBox(width: 100.0,),
                  IconButtonViewWidget(
                    item: items[2],
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                      controller.close();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      content: Scaffold(
        appBar: AppBar(
          title: Text("Overlay Container Testing"),
        ),
        body: Center(
          child: Text(items[selectedIndex].title),
        ),
        floatingActionButton: GestureDetector(
          onLongPress: () {
            controller.open();
          },
          child: FloatingActionButton(
            child: Icon(items[selectedIndex].icon),
            onPressed: () {
              showDialog(context: context, builder: (context) {
                return AlertDialog(
                  title: Text(items[selectedIndex].title),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}

class IconButtonViewWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Items item;

  IconButtonViewWidget({
    @required this.onTap,
    @required this.item
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(item.icon, size: 35.0,),
      ),
    );
  }
}

class Items {
  String title;
  IconData icon;

  Items({
    this.title,
    this.icon
  });
}

final List<Items> items = [
  Items(
    icon: Icons.camera,
    title: "Camera"
  ),
  Items(
    icon: Icons.book_rounded,
    title: "Books"
  ),
  Items(
    icon: Icons.phone,
    title: "Phone"
  ),
];