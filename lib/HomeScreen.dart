import 'package:flutter/material.dart';
import 'package:productsguide/FavoriteProductsScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController productController = TextEditingController();
  List<dynamic> productsList = [];

  void getProducts() async {
    final SupabaseClient supabase = Supabase.instance.client;
    final response = await supabase.from('products').select();
    productsList = response as List<dynamic>;
    List<dynamic> searchList = [];
    for (int i = 0; i < productsList.length; i++) {
      if (productsList[i]['product_name'].toLowerCase().contains(productController.text.toLowerCase())) {
        searchList.add(productsList[i]);
      }
    }
    setState(() {
      productsList = searchList;
    });
  }

  void addFavorite(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> products = prefs.getStringList('products') ?? [];

    if (products.contains(index.toString())) {
      products.removeWhere((product) => product == index.toString());
      await prefs.setStringList('products', products);

      final snackBar = SnackBar(
        content: Text('Продукт удалён из избранных'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else {
      products.add(index.toString());
      await prefs.setStringList('products', products);

      final snackBar = SnackBar(
        content: Text('Продукт добавлен в избранные'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();

    getProducts();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ПродуктХелпер',
              style: TextStyle(
                fontFamily: 'DushaRegular',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            IconButton(
              icon: Icon(Icons.star),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FavoriteProductsScreen()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(240, 255, 240, 1),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: productController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Найти продукт',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 4,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.lightBlueAccent,
                            width: 4,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 4,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'DushaRegular',
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      getProducts();
                    },
                  ),
                ],
              ),
              Expanded(
                child: productsList.isEmpty ? Center(child: CircularProgressIndicator()) : ListView.separated(
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    var product = productsList[index];
                    return ListTile(
                      title: Column(children: [Text(product['product_name'],
                        style: TextStyle(
                          fontFamily: 'DushaRegular',
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),)]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Белки: ${product['proteins']} г',
                          style: TextStyle(
                            fontFamily: 'DushaRegular',
                            fontSize: 20,
                          ),),
                          Text('Жиры: ${product['fats']} г',
                            style: TextStyle(
                              fontFamily: 'DushaRegular',
                              fontSize: 20,
                            ),),
                          Text('Углеводы: ${product['carbohydrates']} г',
                            style: TextStyle(
                              fontFamily: 'DushaRegular',
                              fontSize: 20,
                            ),),
                          Text('Калории: ${product['calories']} ккал',
                            style: TextStyle(
                              fontFamily: 'DushaRegular',
                              fontSize: 20,
                            ),),
                          Text('Порция: ${product['size']}',
                            style: TextStyle(
                              fontFamily: 'DushaRegular',
                              fontSize: 20,
                            ),),
                          Row (
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(Icons.info),
                                onPressed: () {
                                  final snackBar = SnackBar(
                                    content: Text(product['description']),
                                    duration: Duration(seconds: 5),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.star),
                                onPressed: () {
                                  addFavorite(index);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.grey);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(240, 255, 240, 1),
    );
  }
}