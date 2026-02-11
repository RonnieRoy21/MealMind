import 'package:flutter/material.dart';
import 'package:flutter1/Database/customer_ratings.dart';

class CustomerRatings extends StatefulWidget {
  const CustomerRatings({super.key});

  @override
  State<CustomerRatings> createState() => _CustomerRatingsState();
}

class _CustomerRatingsState extends State<CustomerRatings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text('Customer Ratings'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: Ratings().fetchRatings(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final ratingsList = snapshot.data!;
            return ListView.builder(
                itemCount: ratingsList.length,
                itemBuilder: (context, index) {
                  final rating = ratingsList[index];
                  return ListTile(
                    leading: Icon(Icons.person, color: Colors.amber),
                    title: Text(
                      "${rating['user_comment'] ?? 'No comment'}",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    trailing: Text("${rating['customer_name'] ?? 'Anonymous'}"),
                    subtitle:
                        Text("Rating : ${rating['rating_value']?.toString()}"),
                  );
                });
          }),
    );
  }
}
