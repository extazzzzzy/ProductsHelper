import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteProductsScreen extends StatefulWidget {
  @override
  _FavoriteProductsScreenState createState() => _FavoriteProductsScreenState();
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
  List<dynamic> productsList = [];

  void getFavoriteProducts() async {
    final SupabaseClient supabase = Supabase.instance.client;
    final response = await supabase.from('products').select();
    productsList = response as List<dynamic>;

    final prefs = await SharedPreferences.getInstance();
    List<String> productsCacheList = prefs.getStringList('products') ?? [];

    List<dynamic> searchList = [];

    for (int i = 0; i < productsList.length; i++) {
      if (productsCacheList.contains(i.toString())) {
        searchList.add(productsList[i]);
      }
    }

    setState(() {
      productsList = searchList;
    });
  }

  void deleteFavorite(int index) async {
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

    getFavoriteProducts();
  }

  @override
  void initState() {
    super.initState();

    getFavoriteProducts();
  }


  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Избранное',
              style: TextStyle(
                fontFamily: 'DushaRegular',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
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
                                  deleteFavorite(index);
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