import 'package:flutter/material.dart';

class CusDialog{
  final String title ;
  final BuildContext context;
  final Color backgroundColor;
  final Color textColor ;
  CusDialog({required this.title, required this.context,required this.textColor,required this.backgroundColor});
  void showDialogX () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 10,
          scrollable: true,
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          title: Container(width: double.infinity,padding: EdgeInsets.symmetric(vertical: 20),decoration: BoxDecoration(color: backgroundColor,borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),child: Text('سُبْحَانَ اللّٰهِ  اَللّٰهُ أَكْبَر',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w900,color: textColor),textDirection: TextDirection.rtl,textAlign: TextAlign.center,)),
          content: Text(title,textAlign: TextAlign.center,textDirection: TextDirection.rtl,style: TextStyle(fontWeight: FontWeight.w600,height: 2.2,fontSize: 17,color:textColor),),
          actions: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: backgroundColor,borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))),
              child:   TextButton(
                child: Text('Done',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: textColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },

              ),
            )
          ],
        );
      },
    );
  }
}
