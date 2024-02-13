import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/ChargingOperation.dart';
import '../../shared/styles/colors.dart';
import '../Loading/loadig_screen.dart';

class AgencyChargeOperations extends StatefulWidget {
  const AgencyChargeOperations({super.key});

  @override
  State<AgencyChargeOperations> createState() => _AgencyChargeOperationsState();
}

class _AgencyChargeOperationsState extends State<AgencyChargeOperations> {

  List<ChargingOperation> operatins = [] ;
  bool loading = false ;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: MyColors.unSelectedColor, //change your color here
        ),
        centerTitle: true,
        backgroundColor: MyColors.darkColor,
        title: Text(
          "agency_charge_operation_title".tr,
          style: TextStyle(color: MyColors.unSelectedColor, fontSize: 20.0),
        ),
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(15.0),
        child: loading ? Loading() : ListView.separated(itemBuilder: (context, index) => itemBuilder(index),  separatorBuilder: (context, index) => seperatorBuilder() , itemCount: operatins.length),
      ),
    );
  }
  Widget itemBuilder  (index) => Container(
    decoration: BoxDecoration(color: Colors.black26 , borderRadius: BorderRadius.circular(15.0)),
    padding: EdgeInsets.all(10.0),
    child: Row(
      children: [
        Image(image: AssetImage('assets/images/gold_charge.png') , width: 40.0,),
        SizedBox(width:15.0),

        Expanded(
          child: Column(

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                  Text(operatins[index].gold.toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 20.0 , fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 15.0,),
              Text(operatins[index].source , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),),
              SizedBox(height: 15.0,),
              Text(operatins[index].charging_date , style: TextStyle(color: MyColors.unSelectedColor , fontSize: 15.0),)

            ],
          ),
        )
      ],
    ),
  );
  Widget seperatorBuilder  () => SizedBox(height: 10.0,);
}
