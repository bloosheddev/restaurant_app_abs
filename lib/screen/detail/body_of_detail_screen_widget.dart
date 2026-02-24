import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/screen/detail/menu_card_widget.dart';

class BodyOfDetailScreenWidget extends StatelessWidget {
  final RestaurantDetail restaurant;
  const BodyOfDetailScreenWidget({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20.0),
            Hero(
              tag: restaurant.id,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(20.0)),
                child: Image.network(
                  fit: BoxFit.cover,
                  'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                  height: 250,
                  width: 375,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  SizedBox(height: 1.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange),
                            SizedBox(width: 5.0),
                            Text(restaurant.rating.toString()),
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Row(
                          children: [
                            Icon(Icons.location_city, color: Colors.red),
                            SizedBox(width: 5.0),
                            Text(restaurant.city),
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Row(
                          children: [
                            Icon(Icons.place, color: Colors.red),
                            SizedBox(width: 5.0),
                            Text(restaurant.address),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(restaurant.description),
                  SizedBox(height: 20.0),
                  Text('Makanan'),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: restaurant.foods.length,
                      itemBuilder: (context, index) {
                        final food = restaurant.foods[index]["name"];

                        return MenuCard(menuName: food);
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text('Minuman'),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: restaurant.drinks.length,
                      itemBuilder: (context, index) {
                        final drink = restaurant.drinks[index]["name"];

                        return MenuCard(menuName: drink);
                      },
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
