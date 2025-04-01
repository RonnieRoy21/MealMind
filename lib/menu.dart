import 'package:flutter/material.dart';


class Menu extends StatefulWidget {
  const Menu({super.key});
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  Map<String, int> appetizer = {
    "Garlic Bread": 100,
    "Brochette": 150,
    "Stuffed Mushrooms": 180,
    "Mozzarella Sticks": 200,
    "Spring Rolls": 130,
    "Chicken Wings (6 pcs)": 220,
    "Onion Rings": 120,
    "Cheese Nachos": 170,
    "Mini Tacos": 190,
    "Spinach & Artichoke Dip": 250,
    "Hummus with Pita": 140,
    "Deviled Eggs": 90,
    "Loaded Potato Skins": 200,
    "Shrimp Cocktail": 250,
    "Meatballs in Marinara": 210,
    "Samosas (2 pcs)": 110,
    "Caprese Salad": 160,
    "Crispy Calamari": 230,
    "Vegetable Tempura": 190,
    "Cheesy Garlic Knots": 150
  };

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: appetizer.length,
        itemBuilder: (context, index) {
          return Card(
              margin: EdgeInsets.fromLTRB(60.0, 5.0, 60.0, 0),
              color: Colors.cyanAccent[700],
              child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                        onTap: () {},
                          // method to execute when clicked

                        title: Text(
                          appetizer.keys.elementAt(index),
                          style: TextStyle(
                              fontSize: 19.0,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                        subtitle: Text(
                          'price : Ksh ${appetizer.values.elementAt(index)}',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                  

                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:[
                        TextButton(
                            onPressed: (){
                              Navigator.pushNamed(context, '/pay',arguments: {
                                'foodName':appetizer.keys.elementAt(index),
                                'priceToPay':appetizer.values.elementAt(index).toString()
                              });
                            },
                            style: ButtonStyle(
                              textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.white)),
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                            ),
                            child: Text("BUY")
                        )
                      ]
                  )
          ],
                  ),
          );
        }
    );
  }

}




