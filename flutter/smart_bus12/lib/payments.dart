import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController expiryMonthController = TextEditingController();
  final TextEditingController expiryYearController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  bool isLoading = false;

  // دالة لجلب التوكن من التخزين (المفتاح الصحيح)
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  Future<void> makePayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final token = await getToken();
    print("🔥 Token: $token");
    if (token == null || token.isEmpty) {
      setState(() => isLoading = false);
      _showDialog("خطأ ❌", "المستخدم غير مسجل دخول أو التوكن غير موجود");
      return;
    }

    final url = Uri.parse(
      "http://192.168.186.176:8000/api/payments",
    ); // عدل حسب جهازك
    print("🌐 Sending payment request...");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "amount": amountController.text,
        "card_number": cardNumberController.text,
        "card_name": cardNameController.text,
        "expiry_month": expiryMonthController.text,
        "expiry_year": expiryYearController.text,
        "cvv": cvvController.text,
      }),
    );

    print("🌐 Response status: ${response.statusCode}");
    print("🌐 Response body: ${response.body}");

    setState(() => isLoading = false);

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _showDialog("نجاح ✅", data["message"] ?? "تم الدفع بنجاح");
    } else {
      _showDialog("خطأ ❌", data["message"] ?? "حدث خطأ في الدفع");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إغلاق"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("واجهة الدفع")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "أدخل المبلغ" : null,
              ),
              TextFormField(
                controller: cardNumberController,
                decoration: const InputDecoration(labelText: "Card Number"),
                validator: (v) => v!.isEmpty ? "أدخل رقم البطاقة" : null,
              ),
              TextFormField(
                controller: cardNameController,
                decoration: const InputDecoration(labelText: "Card Name"),
                validator: (v) => v!.isEmpty ? "أدخل اسم حامل البطاقة" : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: expiryMonthController,
                      decoration: const InputDecoration(labelText: "MM"),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? "أدخل الشهر" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: expiryYearController,
                      decoration: const InputDecoration(labelText: "YY"),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? "أدخل السنة" : null,
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: cvvController,
                decoration: const InputDecoration(labelText: "CVV"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "أدخل CVV" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : makePayment,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("إرسال الدفع"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
