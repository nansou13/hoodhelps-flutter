import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String name;
  final String address;
  final String cp;
  final String city;
  final String backgroundUrl;
  final void Function()? onTap;

  const GroupCard({
    required this.name,
    required this.address,
    required this.cp,
    required this.city,
    required this.backgroundUrl,
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap, // Utilisez la fonction onTap passée en tant que gestionnaire de clic
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(backgroundUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.1)
                  ],
                  stops: const [
                    0.6,
                    1,
                  ]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 2.0),
                  child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 2.0),
                  child: Text(address),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 8.0),
                  child: Text('$cp $city'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
