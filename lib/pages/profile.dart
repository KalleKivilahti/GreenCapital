import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Name: Kalle Kivilahti',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Email: kalle.kivilahti@gmail.com',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Links',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildLinkItem(
              context,
              title: 'Google',
              url: 'https://mail.google.com/',
            ),
            const SizedBox(height: 10),
            _buildLinkItem(
              context,
              title: 'K Plussa',
              url: 'https://www.kesko.fi/fi/',
            ),
            const SizedBox(height: 10),
            _buildLinkItem(
              context,
              title: 'S Bonus',
              url: 'https://www.s-kanava.fi/web/s-kanava',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, {required String title, required String url}) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 141, 237, 164)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ProfilePage(),
  ));
}
