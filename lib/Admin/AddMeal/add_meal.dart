import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter1/Database/manage_meals.dart';
import 'package:image_picker/image_picker.dart';


class AddMeal extends StatefulWidget {
  const AddMeal({super.key});

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? image;
  Uint8List? imageBytes;
  bool isLoading=false;

  @override
  void dispose(){
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
  }


  Future<void> selectImage() async {
    ImagePicker imagePicker = ImagePicker();
    final selectedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    imageBytes = await selectedImage?.readAsBytes();

    if (selectedImage != null) {
      setState(() {
        image = File(selectedImage.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No image selected")));
    }
  }
  _textFormField({required BuildContext context,required TextEditingController controller,required TextInputType keyboardType, required String labelText,}){
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText.toString()
      ),
      validator: (value){
        if(value == null || value.isEmpty){
          return 'Please enter $labelText';
        }
        return null;
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Meal'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _textFormField(context: context,controller: _nameController,labelText: 'Name',keyboardType: TextInputType.text,),
              const SizedBox(height: 10,),
              _textFormField(context:context,controller: _priceController,labelText: 'Price',keyboardType: TextInputType.number,),
              const SizedBox(height: 10,),
              _textFormField(context:context, controller:_descriptionController,keyboardType: TextInputType.multiline, labelText: 'Description'),
              const SizedBox(height: 10,),
              Row(
                children: [
                  image==null ? Text('No image selected') : Image.file(image!,height: 200,width: 200,fit: BoxFit.fitHeight,),
                  TextButton(
                   style:ButtonStyle(
                     foregroundColor: WidgetStatePropertyAll(Colors.black,),
                     backgroundColor: WidgetStateProperty.all(Colors.blue),
                   ),
                      onPressed: ()async{
                      await selectImage();
                      },
                      child: Text('Upload Image')),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: ()async{
                    isLoading=true;
                    //upload to my database bucket
                   if(_formKey.currentState!.validate()){
                     await ManageMeals().uploadMeal(
                         fileName: _nameController.text,
                         price: int.tryParse(_priceController.text.toString())!,
                         description: _descriptionController.text,
                         image: imageBytes!
                     );
                   }
                   isLoading=false;
                  }, child: Text('Upload Meal')),
                  ElevatedButton(onPressed :isLoading ? null : (){
                    Navigator.pop(context);
                  }, child: Text('Exit'))
                
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
