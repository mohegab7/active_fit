import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const Camera_Page());
}

class Camera_Page extends StatelessWidget {
  const Camera_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Calorie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FoodRecognitionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FoodRecognitionScreen extends StatefulWidget {
  const FoodRecognitionScreen({super.key});

  @override
  State<FoodRecognitionScreen> createState() => _FoodRecognitionScreenState();
}

class _FoodRecognitionScreenState extends State<FoodRecognitionScreen> {
  File? _image;
  String? _foodName;
  Map<String, dynamic>? _nutritionInfo;
  bool _isLoading = false;
  String _errorMessage = '';

  final ImagePicker _picker = ImagePicker();
  final String clarifaiApiKey = "44d2af4b2fd948c0b9f8d229360bd45d";
  final String spoonacularApiKey = "eb46c977109a474eb4e42d4fd4258530";

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _foodName = null;
          _nutritionInfo = null;
          _isLoading = true;
          _errorMessage = '';
        });

        await _recognizeFood(_image!);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'An error occurred while selecting the image: ${e.toString()}';
      });
    }
  }

  Future<void> _recognizeFood(File image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(
          "https://api.clarifai.com/v2/users/clarifai/apps/main/models/food-item-recognition/versions/1d5fd481e0cf4826aa72ec3ff049e044/outputs",
        ),
        headers: {
          "Authorization": "Key $clarifaiApiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "inputs": [
            {
              "data": {
                "image": {"base64": base64Image},
              },
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final concepts = data["outputs"][0]["data"]["concepts"];

        if (concepts != null && concepts.isNotEmpty) {
          final foodName = concepts[0]["name"];
          setState(() {
            _foodName = foodName;
          });
          await _getNutritionInfo(foodName);
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No food was detected in the image';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Food recognition error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'An error occurred while recognizing the food: ${e.toString()}';
      });
    }
  }

  Future<void> _getNutritionInfo(String foodName) async {
    try {
      // الخطوة 1: البحث عن ID المكون
      final searchResponse = await http.get(
        Uri.parse(
          "https://api.spoonacular.com/food/ingredients/search?query=$foodName&apiKey=$spoonacularApiKey",
        ),
      );

      if (searchResponse.statusCode == 200) {
        final searchData = jsonDecode(searchResponse.body);
        if (searchData["results"] != null && searchData["results"].isNotEmpty) {
          final ingredientId = searchData["results"][0]["id"];

          // الخطوة 2: الحصول على المعلومات الغذائية
          final nutritionResponse = await http.get(
            Uri.parse(
              "https://api.spoonacular.com/food/ingredients/$ingredientId/information?amount=100&apiKey=$spoonacularApiKey",
            ),
          );

          if (nutritionResponse.statusCode == 200) {
            final nutritionData = jsonDecode(nutritionResponse.body);
            setState(() {
              _nutritionInfo = {
                "calories": nutritionData["nutrition"]["nutrients"][0]["amount"]
                        ?.round() ??
                    0,
                "fat": nutritionData["nutrition"]["nutrients"][1]["amount"]
                        ?.round() ??
                    0,
                "carbs": nutritionData["nutrition"]["nutrients"][2]["amount"]
                        ?.round() ??
                    0,
                "protein": nutritionData["nutrition"]["nutrients"][3]["amount"]
                        ?.round() ??
                    0,
              };
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
              _errorMessage =
                  'Error retrieving nutritional information: ${nutritionResponse.statusCode}';
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No information available for..$foodName';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Error searching for the food: ${searchResponse.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage =
            'An error occurred while fetching the nutritional information: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text("تطبيق السعرات الحرارية للطعام"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_image != null)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.file(_image!, fit: BoxFit.cover),
              )
            else
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.fastfood, size: 80, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Analyzing the image..."),
                ],
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_foodName != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Identified: $_foodName",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            if (_nutritionInfo != null) ...[
              const SizedBox(height: 20),
              const Text(
                "Nutritional Information:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildNutritionCard(),
            ],
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: Container(
                    width: 120,
                    height: 55,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        backgroundColor: Color.fromARGB(255, 44, 216, 145),
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black,
                      ),
                      label: Text('Camera',
                          style: Theme.of(context).textTheme.labelLarge!),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: Container(
                    width: 120,
                    height: 55,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 16,
                        ),
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                        backgroundColor: Color.fromARGB(255, 44, 216, 145),
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      icon: const Icon(
                        Icons.photo_outlined,
                        color: Colors.black,
                      ),
                      label: Text('gallery',
                          style: Theme.of(context).textTheme.labelLarge!),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildNutritionRow(
              "Calories",
              "${_nutritionInfo!["calories"]} kcal",
            ),
            const Divider(),
            _buildNutritionRow("Fat", "${_nutritionInfo!["fat"]} g"),
            const Divider(),
            _buildNutritionRow(
                "Carbohydrates", "${_nutritionInfo!["carbs"]} g"),
            const Divider(),
            _buildNutritionRow("Protein", "${_nutritionInfo!["protein"]} g"),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
