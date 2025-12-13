import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PreviewMeal extends StatefulWidget {
  const PreviewMeal({super.key});

  @override
  State<PreviewMeal> createState() => _PreviewMealState();
}

class _PreviewMealState extends State<PreviewMeal> {
  String imageUrl = '';
  String name = '';
  String price = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    imageUrl = args['image'];
    name = args['title'];
    price=args['price'];
    description=args['description'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview Meal"),
        centerTitle: true,
        backgroundColor: Colors.cyanAccent,
      ),
      body: imageUrl.isNotEmpty && name.isNotEmpty ?Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                  imageUrl:imageUrl
              ),
              Text("Name :\n $name"),
              const SizedBox(height: 10.0,),
              Text("Price :\n Ksh $price"),
              const SizedBox(height: 10.0,),
              Text("Description :\n $description"),
            ],
          ),
        ),
      ) :
        Center(child: Text("No Data"))
    );
  }
}
