import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CusAnimationButton extends StatefulWidget {
  final int index ;
  final String imagePath ;
  final String nameOfButton;
  // final ImageGalleryModel? gallery ;
  final GestureTapCallback fun ;
  const CusAnimationButton({super.key,required this.fun,required this.index,required this.imagePath,required this.nameOfButton,});

  @override
  State<CusAnimationButton> createState() => _CusAnimationButtonState();
}

class _CusAnimationButtonState extends State<CusAnimationButton> {
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 125.h,
      width: 125.w,
      child: InkWell(
        enableFeedback: true,
        onTap: (){
          setState(() {
           isExpanded[widget.index] = ! isExpanded[widget.index];
          });

           Future.delayed(Duration(milliseconds: 500),(){
               widget.fun();

           });
        },
        child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: isExpanded[widget.index] ? 82.w : 80.w,
                  onEnd: () {
                    setState(() {
                      isExpanded[widget.index] = false;
                    });

                  },
                  alignment: Alignment.center,
                  margin:
                  EdgeInsets.only(left: 25.w, top: 10.h, bottom: 10.h),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: isExpanded[widget.index]
                                ? Colors.transparent
                                :  Color.fromRGBO(169, 168, 168, 1.0),
                            blurRadius: 7.r,
                            spreadRadius: 1,
                            blurStyle: BlurStyle.outer)
                      ],
                      borderRadius: BorderRadius.circular(7)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height: 35.h,
                          width: 40.w,
                          child: Image.asset(
                            widget.imagePath,
                            fit: BoxFit.cover,
                          )),
                      Text(
                        '${widget.nameOfButton}',
                        style: TextStyle(
                            color: Color.fromRGBO(10, 71, 13, 1.0),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
List<bool>isExpanded = [false, false, false] ;
}
