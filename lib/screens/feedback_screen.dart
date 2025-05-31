import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:darwin/constants/colors.dart';
import 'package:darwin/widgets/bottom_app_bar_widget.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  FeedbackScreenState createState() => FeedbackScreenState();
}

class FeedbackScreenState extends State<FeedbackScreen> {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'message': _messageController.text,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Спасибо за ваш отзыв!')));
        Navigator.pop(context);
      } else {
        setState(() {
          _errorMessage = 'error server (${response.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'error connect: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: const CustomBottomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.05,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Column(
            children: [
              // Заголовок
              Text(
                'Обратная связь',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Основная форма с возможностью прокрутки
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Ваш email для связи',
                            hintText: 'example@mail.com',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Пожалуйста, введите email';
                            }
                            if (!_emailRegex.hasMatch(value)) {
                              return 'Введите корректный email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: screenHeight * 0.3,
                          child: TextFormField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              labelText: 'Ваше сообщение',
                              hintText:
                                  'Опишите вашу проблему или предложение...',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Пожалуйста, введите сообщение';
                              }
                              if (value.length < 10) {
                                return 'Сообщение должно быть не менее 10 символов';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),

                        // Кнопка отправки (теперь выше сообщения об ошибке)
                        SizedBox(
                          height: screenHeight * 0.08,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.border,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            onPressed: _isLoading ? null : _submitFeedback,
                            child:
                                _isLoading
                                    ? CircularProgressIndicator()
                                    : Text(
                                      'Отправить',
                                      style: TextStyle(fontSize: 20),
                                    ),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Сообщение об ошибке (теперь под кнопкой)
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
