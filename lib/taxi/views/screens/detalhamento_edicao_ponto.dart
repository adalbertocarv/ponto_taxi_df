import 'package:flutter/material.dart';

class DetalhamentoEdicaoPonto extends StatelessWidget {
  const DetalhamentoEdicaoPonto({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar:   AppBar(

            flexibleSpace: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_filled, color: Colors.white,),
                SizedBox(width: 12,),
                Center(
                  child: Text('Informações do Ponto',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: Row(
            children: [
              // Expanded(
              //   child: Container(
              //     color: Colors.green.withValues(alpha: 0.5),
              //   ),
              // ),
              // Expanded(
              //   child: Container(
              //     color: Colors.blueAccent.withValues(alpha: 0.5),
              //   ),
              // ),
            ],
          ),
        ),
    );
  }
}
