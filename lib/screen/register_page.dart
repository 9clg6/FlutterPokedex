import 'package:flutter/material.dart';
import 'package:pokedex/utils/debug_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    DebugLogger.debugLog("register_page", "initState()", "First connection 🆕", 3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final sharePref = snapshot.data! as SharedPreferences;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            bottomSheet: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Clément Guyon | Ynov Lyon Campus",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            body: InkWell(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage('https://i.pinimg.com/736x/05/b7/08/05b708bffd640ba6868448dd42defaa0.jpg'),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 50.0,
                      right: 50,
                      top: 50,
                      bottom: 100,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "Flutter Pokedex",
                          style: TextStyle(
                            color: Color.fromARGB(255, 250, 135, 104),
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        buildButtonAndTextField(sharePref, context)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Column buildButtonAndTextField(SharedPreferences sharePref, BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty || value == "") {
                return "Merci d'entrer un pseudo";
              }
              return null;
            },
            controller: _textEditingController,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              hintText: "Pseudo",
              fillColor: Colors.white,
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 30),
        InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              sharePref.setBool("isFirstConnection", false);
              sharePref.setString("nickname", _textEditingController.text);
              Navigator.of(context).pushReplacementNamed("/home");
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 135, 104),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.2), offset: const Offset(3, 3))]),
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            alignment: Alignment.center,
            width: 150,
            child: const Text(
              "Valider",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
