import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:norway_flutter_app/core/theme/color_schemes.g.dart';

class SelectStreamType extends StatelessWidget {
  const SelectStreamType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("streams"),
        centerTitle: true,
      ),

      body: Container(
        padding: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              height: 200,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.transparent,
                          Theme.of(context).brightness == Brightness.dark? darkColorScheme.surface : lightColorScheme.surface
                        ], begin: Alignment.topRight, end: Alignment.bottomLeft)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(child: Image.asset('assets/images/nerway_full_logo.png', fit: BoxFit.fill,))
                      ],
                    ),
                  )
              ),
            ),

            Container(
              height: 200,
              color: Colors.transparent,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.transparent,
                          Theme.of(context).brightness == Brightness.dark? darkColorScheme.surface : lightColorScheme.surface
                        ], begin: Alignment.topRight, end: Alignment.bottomLeft)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Flexible(child: Image.asset('assets/images/youtube.png', fit: BoxFit.fill,))
                      ],
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
