import 'package:flutter/material.dart';
import '../main_screen.dart';
import '../auth/auth_state.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  // Controllers cho các ô nhập liệu
  final TextEditingController nameController =
      TextEditingController();
  final TextEditingController emailController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'imgs/anh_nen.png',
              fit: BoxFit.cover,
            ),
          ),

          // Form đăng ký
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(
                  25,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(
                      0.1,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "ĐĂNG KÝ",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Ô nhập Tên
                  TextField(
                    controller:
                        nameController, // ✅ GẮN controller
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person_outline,
                      ),
                      hintText: "Tên",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Ô nhập Email
                  TextField(
                    controller:
                        emailController, // ✅ GẮN controller
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                      ),
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Ô nhập Mật khẩu
                  TextField(
                    controller:
                        passwordController, // ✅ GẮN controller
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),
                      hintText: "Mật khẩu",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // 🔘 Nút đăng ký
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // ✅ Cập nhật thông tin user khi đăng ký
                        final name = nameController
                            .text
                            .trim();
                        final email = emailController
                            .text
                            .trim();

                        AuthState.username =
                            name.isNotEmpty
                            ? name
                            : email;
                        AuthState.isLoggedIn.value =
                            true;
                        // 🔄 Chuyển đến MainScreen và xoá hết lịch sử
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const MainScreen(
                                  initialIndex: 3,
                                ),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF6C63FF,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                15,
                              ),
                        ),
                      ),
                      child: const Text(
                        "ĐĂNG KÝ",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                        context,
                      ); // 🔙 quay về màn hình login
                    },
                    child: const Text(
                      "Đã có tài khoản? Đăng nhập",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
