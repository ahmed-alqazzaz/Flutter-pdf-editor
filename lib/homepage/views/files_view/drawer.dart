import 'package:flutter/material.dart';

class HomePageDrawer extends StatelessWidget {
  factory HomePageDrawer({required String email}) {
    return HomePageDrawer._(
      options: <Option>[
        Option(
          icon: Icons.arrow_outward_outlined,
          title: 'Account',
          onPressed: () {},
        ),
        Option(
          title: "Log Out",
          icon: Icons.logout_sharp,
          onPressed: () {},
        ),
        Option(
          icon: Icons.star_border_sharp,
          title: 'Rate the app',
          onPressed: () {},
        ),
        Option(
          icon: Icons.arrow_forward_outlined,
          title: 'Report a bug',
          onPressed: () {},
        ),
        Option(
          icon: Icons.arrow_forward_outlined,
          title: 'Privacy and terms',
          onPressed: () {},
        ),
      ],
      email: email,
    );
  }

  const HomePageDrawer._({required this.options, required this.email});

  final List<Option> options;
  final String email;

  Widget _profilePictureBuilder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.amber.shade600,
      ),
      child: Center(
        child: Text(
          email.substring(0, 2).toUpperCase(),
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Padding _emailBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        email,
        style: const TextStyle(color: Colors.black38),
      ),
    );
  }

  Widget _optionBuilder(Option option) {
    return RawMaterialButton(
      constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      onPressed: option.onPressed,
      child: ListTile(
        title: Text(
          option.title,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
        trailing: Icon(
          option.icon,
          color: Colors.black.withOpacity(0.7),
        ),
      ),
    );
  }

  ListView _optionsBuilder() {
    return ListView.builder(
      itemCount: options.length,
      itemBuilder: (context, index) => _optionBuilder(options[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Theme(
        data: ThemeData(
          drawerTheme: const DrawerThemeData(
              scrimColor: Colors.transparent, elevation: 0.5),
        ),
        child: Drawer(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              _profilePictureBuilder(),
              _emailBuilder(),
              const Divider(color: Color.fromRGBO(186, 186, 186, 100)),
              Expanded(child: _optionsBuilder()),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class Option {
  const Option(
      {required this.title, required this.icon, required this.onPressed});

  final IconData icon;
  final void Function() onPressed;
  final String title;
}
