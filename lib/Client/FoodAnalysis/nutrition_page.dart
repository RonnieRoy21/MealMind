import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter1/Database/profile_details.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class NutritionPage extends StatefulWidget {
  final String meal;
  const NutritionPage({super.key, required this.meal});

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {

  @override
  void initState() {
    super.initState();
  }

  final ProfileDetails profile=ProfileDetails();
  bool isNutritionLoading=true;
  Map<String, dynamic> nutrition={};
  Map <String, dynamic> flags={};

  Future <Map<String, dynamic>> fetchNutrition(String meal) async {
    try {
      List<String> foods=[meal];
      final separators=['and',','];
      for (final sep in separators){
        List<String> temp=[];
        for(final p in foods){
          if(p.contains(sep)){
            temp.addAll(p.split(sep));
          }else{
            temp.add(p);
          }
        }
        foods=temp;
      }
      final uri =
          "https://ronnieroy-nutritionalanalysis.onrender.com/getNutrients";
      final myUrl = Uri.parse(uri);
      final response = await http.post(
        myUrl,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({"food_names": foods}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null ) {
            nutrition.addAll(data['totalsList']);

          return data['totalsList'];
        } else {
          return {};
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Error: ${response.reasonPhrase}\n Status Code: ${response.statusCode}"),
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 2),
          ),

        );
        return {};
      }
    } catch (error) {
      return {};
    }

  }

  Future fetchFlags()async{
      try {
        final List conditions = await profile.getConditions();
        print("Conditions are : $conditions");
        if (conditions.isNotEmpty) {
          final uri = "https://ronnieroy-nutritionalanalysis.onrender.com/getInsights";

          final response =await http.post(
              Uri.parse(uri),
              headers: {
                "Content-Type": "application/json",
              },
              body: json.encode({
                "conditions": conditions,
                "foodNutrients": nutrition
              })
          );
          print("Response is : ${response.body}");
          flags=json.decode(response.body);
          return flags;
        } else {
          Fluttertoast.showToast(msg: "Empty Data from client database");
        }
      } on HttpException catch (e) {
        Fluttertoast.showToast(msg: "Error : ${e.message}");
      }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text("Meal Nutrition")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: fetchNutrition(widget.meal),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error : ${snapshot.error}"));
                }
                if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(semanticsLabel: 'Loading ...',),
                  );
                }
                  final list = snapshot.data!;
                return Card(
                  margin: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Meal : ${widget.meal}",style: TextStyle(fontFamily: 'Times New Roman',fontSize: 20,fontWeight: FontWeight.bold),),
                      Text("Calories : ${list['Calories']} kcal"),
                      Text("Fat : ${list['Fat']} g"),
                      Text("Carbs : ${list['Carbohydrates']} g"),
                      Text("Protein : ${list['Protein']} g"),
                      Text("Fiber : ${list['Fiber']} g"),
                      Text("Sugar : ${list['Sugar']} g"),
                      Text("Sodium : ${list['Sodium']} mg"),
                      Text("Potassium : ${list['Potassium']} mg"),
                      Text("Cholesterol : ${list['Cholesterol']} mg"),
                      Text("Saturated Fat : ${list['Saturated Fat']} g"),
                    ],
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: ()async{
                flags=await fetchFlags();
                print("Flags are : $flags");
               showModalBottomSheet(
                 barrierColor: Colors.amber,
                   context:context,
                   builder: (context){
                     return FutureBuilder(
                         future: fetchFlags(),
                         builder: (context,snapshot){
                           if(snapshot.hasError){
                             return Center(child: Text("Error : ${snapshot.error}"));
                           }
                           if(!snapshot.hasData && snapshot.connectionState==ConnectionState.waiting){
                             return Center(child: CircularProgressIndicator(semanticsLabel: 'Loading ...',));
                           }
                           flags=snapshot.data!;
                           final keys=flags.keys.toList();
                           return ListView.builder(
                             itemCount: keys.length,
                             itemBuilder: (context,index){
                               final key=keys[index];
                             final value=flags[key];
                             return ListTile(
                               title: Text("For $key"),
                                 subtitle: Text("Recommendation :${value['recommendation']}"),
                                 trailing: Text("Flag : ${value['flag']}"),
                             );
                             },
                             );
                           });
                         });
              },
              child: Text("Check Flags"),
            )
          ],
        ),
      ),
    );
  }
}
