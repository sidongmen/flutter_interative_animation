import 'package:flutter/material.dart';
import 'animations/3dRoller/3dRollerScreen.dart';
import 'animations/particles/particleScreen.dart';

class PageType {
  int id;
  String title;
  String route;
  PageType({this.id, this.title, this.route});
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) =>
            MyHomePage(title: 'Interactive Animation'),
        '/particle': (BuildContext context) => ParticleScreen(
              title: "Tab to create",
            ),
        '/3dRoller': (BuildContext context) => Three3DRollerScreen(
              title: "Tab to create",
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PageType> pageList = [
    PageType(id: 1, title: 'Tap to create particles', route: "/particle"),
    PageType(id: 2, title: 'rotate 3D roller', route: "/3dRoller"),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Animations'),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: pageList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(pageList[index].title),
                onTap: () =>
                    {Navigator.of(context).pushNamed(pageList[index].route)},
              );
            }),
      ),
    );
  }
}
