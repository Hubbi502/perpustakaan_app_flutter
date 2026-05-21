import 'package:flutter/material.dart';
import 'package:library_app/src/pages/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool obscureTextStatus = true;
  bool remeberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 206, 229, 247),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Library",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 22, 111, 185),
                  ),
                ),
                Text(
                  "Sign In to continue your reading journey",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "NAME",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(175, 0, 0, 0),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            prefixIcon: Icon(Icons.person),
                            hint: Text(
                              "John doe",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 155, 155, 155),
                                fontSize: 18,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "EMAIL ADDRESS",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(175, 0, 0, 0),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            prefixIcon: Icon(Icons.mail),
                            hint: Text(
                              "hello@example.com",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 155, 155, 155),
                                fontSize: 18,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 30),
                        Text(
                          "PASSWORD",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(175, 0, 0, 0),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          obscureText: obscureTextStatus,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            prefixIcon: Icon(Icons.lock_outline),
                            hint: Text(
                              "Password",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 155, 155, 155),
                                fontSize: 18,
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureTextStatus = !obscureTextStatus;
                                });
                              },
                              icon: Icon(
                                obscureTextStatus
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                          ),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 15),

                        CheckboxListTile(
                          value: remeberMe,
                          onChanged: (value) {
                            setState(() {
                              remeberMe = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Remember Me",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.all(
                                  Radius.circular(20),
                                ),
                              ),
                              backgroundColor: const Color.fromARGB(
                                255,
                                17,
                                122,
                                208,
                              ),
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Dont have account ?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Register(),));
                              },
                              child: Text(
                                " Register Here",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 30, 110, 175)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
