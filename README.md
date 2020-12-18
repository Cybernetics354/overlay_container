# overlay_container

Widget helper to achieve overlay container

## Usage

Create a `OverlayContainerController` first

```dart
final OverlayContainerController controller = new OverlayContainerController();
```

Then we can use the widget in the top level of widget tree, or whatever do you want

```dart
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
```

you can use controller to control the view of overlay, just use `controller.open()` to open the overlay and `controller.close()` to close it,
Happy Fluttering @Cybernetics Core