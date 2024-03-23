import 'package:flutter/material.dart';

class FoodItem {
  final String name;
  final int calories;
  final String imageUrl;
  final String
      servingSize; // เพิ่มฟิลด์ servingSize เพื่อเก็บข้อมูลหน่วยปริมาตร

  FoodItem({
    required this.name,
    required this.calories,
    required this.imageUrl,
    required this.servingSize, // รับค่า servingSize เข้ามา
  });

  int compareTo(FoodItem other) {
    return name.compareTo(other.name);
  }
}

class FoodCategory {
  final String name;
  final List<FoodItem> foods;

  FoodCategory({required this.name, required this.foods}) {
    foods.sort((a, b) => a.compareTo(b));
  }
}

void main() {
  runApp(CalorieApp());
}

class CalorieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FoodListScreenWithSearch(),
    );
  }
}

class FoodListScreenWithSearch extends StatefulWidget {
  @override
  _FoodListScreenWithSearchState createState() =>
      _FoodListScreenWithSearchState();
}

class _FoodListScreenWithSearchState extends State<FoodListScreenWithSearch> {
  final List<FoodCategory> foodCategories = [
    FoodCategory(
      name: 'เครื่องดื่ม',
      foods: [
        FoodItem(
          name: 'น้ำเปล่า',
          calories: 0,
          imageUrl:
              'https://s.isanook.com/he/0/ud/6/34305/drinking-water.jpg?ip/resize/w850/q80/jpg',
          servingSize: 'แก้ว', // เพิ่มค่า servingSize
        ),
        FoodItem(
          name: 'กาแฟ',
          calories: 5,
          imageUrl:
              'https://www.aromathailand.com/wp-content/uploads/2023/09/shutterstock_560673421.jpeg',
          servingSize: 'ถ้วย', // เพิ่มค่า servingSize
        ),
        // เพิ่มเครื่องดื่มเพิ่มเติมตามต้องการ
      ],
    ),
    FoodCategory(
      name: 'ขนม',
      foods: [
        FoodItem(
          name: 'คุกกี้',
          calories: 100,
          imageUrl:
              'https://static.cdntap.com/tap-assets-prod/wp-content/uploads/sites/25/2022/02/cookie-lead.jpg',
          servingSize: 'ชิ้น', // เพิ่มค่า servingSize
        ),
        FoodItem(
          name: 'ช็อคโกแลต',
          calories: 150,
          imageUrl:
              'https://helenathailand.co/wp-content/uploads/elementor/thumbs/CraftChoccover_web-ommxmxuj0bb39ddtx0nufq4tn5qvz78jdaf3r35i5s.jpg',
          servingSize: 'ชิ้น', // เพิ่มค่า servingSize
        ),
        // เพิ่มขนมเพิ่มเติมตามต้องการ
      ],
    ),
    // เพิ่มประเภทอาหารเพิ่มเติมตามต้องการ
  ];
  late List<FoodItem> filteredFoods;

  @override
  void initState() {
    super.initState();
    // คัดลอกข้อมูลอาหารทั้งหมดมาเพื่อใช้ในการค้นหา
    filteredFoods = foodCategories
        .expand((category) => category.foods)
        .toList(); // แปลง List<List<FoodItem>> เป็น List<FoodItem>
  }

  void filterFoods(String query) {
    setState(() {
      filteredFoods = foodCategories
          .expand((category) => category.foods)
          .where(
              (food) => food.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประเภทอาหาร',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FoodSearchDelegate(filteredFoods),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: foodCategories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              foodCategories[index].name,
              style: TextStyle(
                fontWeight: FontWeight.bold, // ตั้งค่าให้เป็นตัวหนา
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FoodCategoryScreen(foodCategory: foodCategories[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class FoodSearchDelegate extends SearchDelegate<FoodItem> {
  final List<FoodItem> foodItems;

  FoodSearchDelegate(this.foodItems);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(
            context,
            FoodItem(
                name: '',
                calories: 0,
                imageUrl: '',
                servingSize:
                    '')); // Pass an empty FoodItem or any default value
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<FoodItem> results = foodItems
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            close(context, results[index]);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.blue[200],
            ),
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    results[index].imageUrl,
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  results[index].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${results[index].calories} kcal / ${results[index].servingSize}',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<FoodItem> suggestions = foodItems
        .where((food) => food.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            close(context, suggestions[index]);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.blue[200],
            ),
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    suggestions[index].imageUrl,
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  suggestions[index].name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${suggestions[index].calories} kcal / ${suggestions[index].servingSize}',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FoodCategoryScreen extends StatelessWidget {
  final FoodCategory foodCategory;

  FoodCategoryScreen({required this.foodCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          foodCategory.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: foodCategory.foods.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
// Handle tap action
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.blue[200],
                ),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        foodCategory.foods[index].imageUrl,
                        width: 120,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      foodCategory.foods[index].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      '${foodCategory.foods[index].calories} kcal / ${foodCategory.foods[index].servingSize}',
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
