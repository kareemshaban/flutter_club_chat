import 'package:clubchat/modules/Room/Components/themes_modal.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuModal extends StatefulWidget {
  const MenuModal({super.key});

  @override
  State<MenuModal> createState() => _MenuModalState();
}

class _MenuModalState extends State<MenuModal> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 200,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(color: Colors.black.withAlpha(180),
          borderRadius: BorderRadius.only(topRight: Radius.circular(20.0) , topLeft: Radius.circular(15.0)) ,
          border: Border(top: BorderSide(width: 3.0, color: MyColors.primaryColor),) ),
      child:  Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    showModalBottomSheet(

                        context: context,
                        builder: (ctx) => ThemesBottomSheet());
                  },
                  child: Column(
                    children: [
                      Image(image: AssetImage('assets/images/theme.png') , width: 40.0,),
                      SizedBox(height: 8.0,),
                      Text('menu_theme'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Image(image: AssetImage('assets/images/music.png') , width: 40.0,),
                    SizedBox(height: 8.0,),
                    Text('menu_music'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Image(image: AssetImage('assets/images/numbers.png') , width: 40.0,),
                    SizedBox(height: 8.0,),
                    Text('menu_lucky_number'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Image(image: AssetImage('assets/images/3d-dice.png') , width: 40.0,),
                    SizedBox(height: 8.0,),
                    Text('menu_dice'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.0,),
          Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              children: [
                Image(image: AssetImage('assets/images/lucky_bag.png') , width: 40.0,),
                SizedBox(height: 8.0,),
                Text('menu_lucky_bag'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Image(image: AssetImage('assets/images/settings.png') , width: 40.0,),
                SizedBox(height: 8.0,),
                Text('menu_settings'.tr , style: TextStyle(color: Colors.white , fontSize: 12.0),)
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [

              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [

              ],
            ),
          ),
        ],
      ),

        ],
      )

    );
  }
  Widget ThemesBottomSheet() => ThemesModal();
}
