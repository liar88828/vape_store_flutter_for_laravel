import 'package:flutter/material.dart';
import 'package:vape_store/bloc/product/product_bloc.dart';
import 'package:vape_store/bloc/trolley/trolley_bloc.dart';
import 'package:vape_store/models/product_model.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/product/product_detail_screen.dart';
import 'package:vape_store/screen/trolley_screen.dart';
import 'package:vape_store/utils/money.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedPrice;

  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(ProductFilterEvent());
    var colorTheme = Theme.of(context).colorScheme;
    const listCategory = ['Coil', 'Mod', 'Liquid', 'Battery', "Connector", "Tank/Cartridge", 'Mouthpiece/Drip-tip', 'Atomizer', 'Accessories'];
    const listPrice = [
      'Low Price',
      'High Price',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())),

          // style: ButtonStyle(),
        ),
        toolbarHeight: 70,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  isDense: true,
                  // contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  hintText: "Search...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(ProductSearchEvent(search: _searchController.text));
                    },
                    icon: const Icon(Icons.search),
                  ))),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: BlocSelector<TrolleyBloc, TrolleyState, int>(
              selector: (stateTrolley) {
                return stateTrolley.count ?? 0;
              },
              builder: (context, stateTrolleyCount) {
                return IconButton(
                    color: colorTheme.primary,
                    style: IconButton.styleFrom(backgroundColor: colorTheme.primaryContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    // color: Colors.red,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const TrolleyScreen();
                      }));
                    },
                    icon: Badge(
                      label: Text(stateTrolleyCount.toString()),
                      child: const Icon(
                        Icons.trolley,
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    color: colorTheme.primary,
                    style: IconButton.styleFrom(backgroundColor: colorTheme.primaryContainer, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      context.read<ProductBloc>().add(
                            ProductFilterEvent(
                              category: _selectedCategory,
                              order: _selectedPrice,
                              name: _searchController.text,
                            ),
                          );
                    },
                    icon: const Icon(Icons.filter_list)),
                CategoryDropdown(
                  listCategory: listCategory,
                  selectedCategory: _selectedCategory ?? listCategory[0],
                  onChanged: (String? value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                  colorTheme: colorTheme,
                ),
                CategoryDropdown(
                  listCategory: listPrice,
                  selectedCategory: _selectedPrice ?? listPrice[0],
                  onChanged: (String? value) {
                    setState(() {
                      _selectedPrice = value!;
                    });
                  },
                  colorTheme: colorTheme,
                ),
              ],
            ),
          ),
          BlocBuilder<ProductBloc, ProductState>(
            // buildWhen: (previous, current) {
            //   return previous.products != current.products;
            // },
            builder: (context, stateProduct) {
              if (stateProduct is ProductLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (stateProduct is ProductErrorState) {
                return const Center(child: Text('Error Data Error'));
              } else if (stateProduct is ProductLoadsState) {
                return Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    primary: false,
                    // padding: const EdgeInsets.symmetric(horizontal: 10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    children: stateProduct.products.map((product) {
                      return ProductCard(product: product
                          // image: 'lib/images/banner1.png',
                          // price: product.price!,
                          // title: product.name!,
                          );
                    }).toList(),
                  ),
                );
              } else {
                return const Center(child: Text('Something went wrong Bloc or API'));
              }
            },
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  // final String image;
  // final String title;
  // final String price;
  final ProductModel product;

  const ProductCard({super.key, required this.product
      // required this.image,
      // required this.title,
      // required this.price,
      });
  @override
  Widget build(BuildContext context) {
    var colorTheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                    id: product.id!,
                    redirect: 'search',
                    lastId: 0,
                  )),
        );
      },
      child: Card(
        color: colorTheme.onPrimary,
        // margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'lib/images/banner1.png',
                        height: 150,
                        width: 150,
                        // fit: BoxFit.fill
                      ),
                      const Positioned(
                          top: 1,
                          right: 1,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          ))
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatPrice(product.price),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final List<String> listCategory;
  final String selectedCategory;
  final ValueChanged<String?> onChanged;
  final ColorScheme colorTheme;

  const CategoryDropdown({
    super.key,
    required this.listCategory,
    required this.selectedCategory,
    required this.onChanged,
    required this.colorTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colorTheme.onPrimary,
        border: Border.all(color: colorTheme.primaryContainer),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedCategory,
        icon: const Icon(Icons.arrow_downward),
        dropdownColor: colorTheme.onPrimary,
        elevation: 10,
        underline: Container(),
        onChanged: onChanged,
        items: listCategory.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: colorTheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
