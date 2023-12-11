import 'package:flutter/material.dart';



class HomeDrawer extends StatelessWidget{
  const HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20),
            child: const Center(
              child: Text(
                "Image To Text",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            color: Theme.of(context).appBarTheme.backgroundColor,
            height: 120,
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Item 1'),
            //selected: _selectedDestination == 0,
            onTap: () => () {},
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Item 2'),
            //selected: _selectedDestination == 1,
            onTap: () => () {},
          ),
          ListTile(
            leading: const Icon(Icons.label),
            title: const Text('Item 3'),
            //selected: _selectedDestination == 2,
            onTap: () {},
          ),
          const Divider(
            height: 1,
            thickness: 1,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Label',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Item A'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

}