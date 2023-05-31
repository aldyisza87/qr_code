import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailC =
      TextEditingController(text: 'admin@gmail.com');
  final TextEditingController passC = TextEditingController(text: 'qctna123');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: false,
        ),
        body: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            const SizedBox(
              height: 5,
            ),
            // form email
            TextField(
              autocorrect: false,
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // Membungkus dengan fungsi obx agar bisa di re-build ulang pada textfield password (hidden true & false)
            Obx(
              () => TextField(
                autocorrect: false,
                controller: passC,
                obscureText: controller.isHidden.value,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      // mengubah value dari  fungsi isHidden menjadi kebalikan dari value sebelumnya dengan fungsi toggle()
                      controller.isHidden.toggle();
                    },
                    icon: Icon(controller.isHidden.isFalse
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding:
                        const EdgeInsetsDirectional.symmetric(vertical: 18)),
                child: Text('LOGIN'))
          ],
        ));
  }
}
