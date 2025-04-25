import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: ProductScreen(),
    );
  }
}

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildProductCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Recommended for\nyour devices",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "See All",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(
                Icons.bookmark_border,
                color: Colors.blue,
              ),
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://th.bing.com/th/id/OIP.OExUEZaIe9dvm7xnanS_hQHaGk?rs=1&pid=ImgDetMain',
                          height: 120,
                        ),
                        const SizedBox(width: 20),
                  
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Free Engraving",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "AirPods Max — Silver",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      "A\$899.00",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    _buildColorOption(Colors.grey),
                    _buildColorOption(Colors.red),
                    _buildColorOption(Colors.blue),
                    _buildColorOption(Colors.green),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
    );
  }
}