import 'package:flutter/material.dart';
import 'package:flutter1/DataModels/profile_model.dart';
import 'package:flutter1/Database/profile_details.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileDetails profile = ProfileDetails();
  final _ratingFormKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commenterController = TextEditingController();
  late final userProfiles;
  bool isEdited = false;
  late double newRating;
  double appRating = 0;

  List<String> imgPathList = [
    'assets/images/young_man.png',
    'assets/images/teen_boy.png',
    'assets/images/teen_girl.png',
    'assets/images/grown_man.png',
    'assets/images/young_woman.png',
  ];
  String imgPath = 'assets/images/grown_man.png';

  initializeProfile() async {
    final ProfileModel? data = await profile.getProfile();
    return data;
  }

  initializeRating() async {
    final rating = await profile.getRatings();
    setState(() {
      appRating = rating;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeRating();
    initializeProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.purpleAccent, title: Text(' Profile')),
        drawer: Drawer(
          backgroundColor: Colors.grey[400],
          elevation: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder(
                  future: initializeProfile(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        semanticsLabel: 'Loading ...',
                      ));
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('SnapshotError: ${snapshot.error}'));
                    }
                    final ProfileModel? user = snapshot.data! as ProfileModel?;
                    return SingleChildScrollView(
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: user!.imgPath.toString().isEmpty
                                  ? AssetImage(imgPath)
                                  : AssetImage(imgPath),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  int currentIndex =
                                      imgPathList.indexOf(imgPath);
                                  int nextIndex =
                                      (currentIndex + 1) % imgPathList.length;
                                  imgPath = imgPathList[nextIndex];
                                });
                              },
                              icon: Icon(Icons.refresh),
                            )
                          ],
                        ),
                        TextButton(
                            onPressed: () async {
                              await profile.addProfilePhoto(imgPath);
                            },
                            child: Text("save photo")),
                        ListTile(
                          title: Text("Username : ${user.username} "),
                          subtitle: Text("Email :${user.email} "),
                        ),
                        Divider(
                          color: Colors.cyan,
                        ),
                        Text("Health Conditions :"),
                        for (int i = 0; i < user.conditions.length; i++)
                          ListTile(title: Text(user.conditions[i].toString())),
                        Divider(
                          color: Colors.cyan,
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isEdited = !isEdited;
                              });
                            },
                            icon: Icon(Icons.edit))
                      ]),
                    );
                  }),
              Spacer(),
              if (isEdited)
                Form(
                  key: _nameFormKey,
                  child: TextFormField(
                    maxLength: 20,
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value.toString().isEmpty || value == null) {
                        return "Name cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
              TextButton(
                onPressed: isEdited
                    ? () async {
                        if (_nameFormKey.currentState!.validate()) {
                          await profile.addUserName(name: _nameController.text);
                          setState(() {
                            isEdited = false;
                          });
                        }
                      }
                    : null,
                child: Text("Save Username"),
              )
            ],
          ),
        ),
        body: Form(
            key: _ratingFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RatingBar(
                    minRating: 1,
                    maxRating: 5,
                    ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          color: Colors.green,
                        ),
                        half: Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),
                        empty: Icon(
                          Icons.star,
                          color: Colors.grey,
                        )),
                    onRatingUpdate: (rating) => newRating = rating),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _commentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _commentController.text = "No Comment";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Add a comment',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _commenterController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      _commenterController.text = "Anonymous";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'You can also add your name here',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                    onPressed: () async {
                      if (_ratingFormKey.currentState!.validate()) {
                        //check if rating is not null
                        if (newRating.isNaN) {
                          Fluttertoast.showToast(
                              msg: "Please provide a rating before submitting",
                              toastLength: Toast.LENGTH_SHORT);
                          return;
                        }
                        await profile.addRating(_commenterController.text,
                            rateValue: newRating,
                            review: _commentController.text);
                        setState(() {
                          initializeRating();
                        });
                      }
                    },
                    child: Text("Send Feedback")),
                const SizedBox(
                  height: 30,
                ),
                Text("Our App Rating is at : $appRating",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                RatingBarIndicator(
                  rating: appRating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 20.0,
                  direction: Axis.horizontal,
                ),
              ],
            )));
  }
}
