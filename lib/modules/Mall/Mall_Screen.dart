import 'package:clubchat/helpers/MallHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Design.dart';
import 'package:clubchat/modules/MyDesigns/My_Designs_Screen.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/DesignServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';

import '../Loading/loadig_screen.dart';

class MallScreen extends StatefulWidget {
  const MallScreen({super.key});

  @override
  State<MallScreen> createState() => _MallScreenState();
}

class _MallScreenState extends State<MallScreen>  with TickerProviderStateMixin   {
  AppUser? user ;
  MallHelper? helper ;
  int? selectedCategory  ;
  int? selectedDesign  ;
  int tabsCount = 0 ;
  TabController? _tabController ;
  List<Widget> tabs = [] ;
  List<Widget> views = [] ;
  String preview_img = "" ;
  SVGAAnimationController? animationController;
  bool loading = false ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.animationController = SVGAAnimationController(vsync: this);
  //  this.loadAnimation();
    getData();
  }
  void loadAnimation(img_url) async {
    final videoItem = await SVGAParser.shared.decodeFromURL(img_url);
    this.animationController!.videoItem = videoItem;
    this
        .animationController
        !.repeat() // Try to use .forward() .reverse()
        .whenComplete(() => this.animationController!.videoItem = null);

    animationController!.addStatusListener((status) {
      print(status);
    });
  }
  getData() async{
    setState(() {
      loading = true ;
    });
    helper = await DesignServices().getAllCatsAndDesigns();
    DesignServices().helperSetter(helper!);
    setState(() {
      user = AppUserServices().userGetter();
      selectedCategory = helper?.categories![0].id ;
      tabsCount = helper!.categories!.length ;
      _tabController = new TabController(vsync: this, length: tabsCount);
      _tabController!.addListener((){
        setState(() {
          selectedCategory = helper!.categories![_tabController!.index].id ;
        });


      });
      getCats();
      getTabs();

    });
    setState(() {
      loading = false ;
    });
  }
  Future<void> _refresh()async{
   await getData() ;
  }

  @override
  void dispose() {
    _tabController!.dispose();
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: MyColors.whiteColor, //change your color here
        ),
        backgroundColor: MyColors.darkColor,
        title: Text("mall_title".tr , style: TextStyle(color: Colors.white , fontSize: 22.0),),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MyDesignScreen()));
              },
              icon: const Icon(
                Icons.store,
                color: Colors.white,
                size: 30.0,
              ))
        ],
      ),
      body: Container(
        color: MyColors.darkColor,
        width: double.infinity,
        height: double.infinity,
        child: loading ? Loading(): (
        tabsCount > 0 ?  Stack(
          children: [
            Column(
                children: [
                  SizedBox(height: 10.0,),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    height:40.0,
                    child: TabBar(
                      dividerColor: Colors.transparent,
                      tabAlignment: TabAlignment.center,
                      isScrollable: true ,
                      unselectedLabelColor: Colors.white,
                      labelColor: MyColors.darkColor,
                      indicatorColor: Colors.transparent,
                      controller: _tabController,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0), // Creates border
                          color: MyColors.primaryColor ),
                      labelStyle: const TextStyle(fontSize: 17.0 , fontWeight: FontWeight.w900),
                      tabs:  tabs,
                    )
                  ),
                  const SizedBox(height: 10.0,),

                  Expanded(child: TabBarView(children: views ,   controller: _tabController,
                  )),


                ],
              ),
            Center(
             // child: animationController!.videoItem != null ? SVGAImage(animationController!) : Container(),
               child: preview_img != "" ?  SVGASimpleImage( resUrl: preview_img) : Container(),
            )
          ],
        ) : Container()
        ),
      ),
    );
  }
  getCats(){
    List<Widget> t = [] ;
    for(var i = 0 ; i < tabsCount ; i++){
      Widget tab = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 5.0),
        child: Tab(text: helper!.categories![i].name),
      );
      t.add(tab);
      setState(() {
        tabs = t ;
      });
    }

  }
  Widget countryListSpacer() => SizedBox(width: 10.0,);

  Widget catListItem(index) => helper!.categories!.isNotEmpty ?  GestureDetector(
    onTap: (){
      setState(() {
        selectedCategory = helper!.categories![index].id;
        print(selectedCategory);
      });
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0 , vertical: 10),
      decoration: BoxDecoration( borderRadius: BorderRadius.circular(25.0) ,
          color: helper!.categories![index].id == selectedCategory ? MyColors.primaryColor : MyColors.lightUnSelectedColor),
      child:  Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(helper!.categories![index].name , style:
          TextStyle(color: helper!.categories![index].id == selectedCategory ? MyColors.darkColor :MyColors.whiteColor ,
              fontSize: 13.0 , fontWeight: FontWeight.bold),)
        ],),
    ),
  ) : Container();

  Widget designListItem(design) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      setState(() {
        selectedDesign = design!.id ;
        print(selectedDesign);
      });
      showModalBottomSheet(
          context: context,
          builder: (ctx) => DesignBottomSheet(design));
    },
    child: Container(
      decoration: BoxDecoration(color: Colors.black26 , borderRadius: BorderRadius.circular(15.0) ,
      border: selectedDesign == design.id ? Border.all(color: MyColors.primaryColor , width: 3.0) : Border.all(color: Colors.transparent)),
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: MyColors.lightUnSelectedColor ,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0) , topRight: Radius.circular(15.0))),
              child: Center(
                child: Image(image: NetworkImage(ASSETSBASEURL + 'Designs/' + design.icon),),
                // child: SVGASimpleImage(
                //     resUrl: "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(  borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              children: [
                Text(design.name , style: TextStyle(color: Colors.white , fontSize: 15.0),),
                SizedBox(height: 3.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                    Text(design.price , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0),)
                  ],
                ),
                SizedBox(height: 3.0,),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  getTabs() {
    print('my selectedCategory is '+ selectedCategory.toString());
    List<Widget> t = [] ;
    for(var i = 0 ; i < tabsCount ; i++){
      Widget tab = getTab(helper!.categories![i].id);
      t.add(tab);
    }
    setState(() {
      views = t ;
    });
  }
  Widget getTab(catId) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Expanded(
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: MyColors.primaryColor,
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: .7,
            children: helper!.designs!.where((element) => element.category_id == catId).map((design ) => designListItem(design)).toList() ,
          ),
        ),
      ),
    ],
  );

  Widget DesignBottomSheet( design) => Container(
    height: 310.0,
      decoration: BoxDecoration(color: MyColors.darkColor, borderRadius: BorderRadius.only(topRight: Radius.circular(15.0) , topLeft: Radius.circular(15.0))),
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  color: MyColors.darkColor.withAlpha(100),
                  child: Center(
                    child: (design!.category_id == 3 || design!.category_id == 5) ? Image(image: NetworkImage(ASSETSBASEURL + 'Designs/' + design.icon),)
                      : design!.category_id == 4 ?

                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                          backgroundImage: user?.img != "" ? (user!.img.startsWith('https') ? NetworkImage(user!.img)  :  NetworkImage('${ASSETSBASEURL}AppUsers/${user?.img}'))  :    null,
                          radius: 80.0,
                          child: user?.img== "" ?
                          Text(user!.name.toUpperCase().substring(0 , 1) +
                              (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                            style: const TextStyle(color: Colors.white , fontSize: 22.0 , fontWeight: FontWeight.bold),) : null,
                        ),
                        SizedBox(height: 200.0, width: 200.0, child: SVGASimpleImage( resUrl: ASSETSBASEURL + 'Designs/Motion/' + design.motion_icon +'?raw=true')),
                      ],
                    ) :

                    SVGASimpleImage( resUrl: ASSETSBASEURL + 'Designs/Motion/' + design.motion_icon +'?raw=true'),
                  // /  SVGASimpleImage( resUrl: "https://chat.gifty-store.com/images/Designs/Motion/1703720610motion_icon.svga" ),
                  ),
                ),
                (design!.category_id == 3 || design!.category_id == 5) ? Container(
                  width: 40.0,
                  height: 40.0,

                  decoration: BoxDecoration(color: Colors.black12 , borderRadius: BorderRadius.circular(10.0)),
                  child:  IconButton(onPressed: (){
                    setState(() {
                       var img =  ASSETSBASEURL + 'Designs/Motion/' + design.motion_icon ;
                       preview(img , design);
                    });
                  },  icon: Icon(Icons.remove_red_eye_outlined , color: Colors.white,))
                ): Container(),
              ],
            ),
          ),
          SizedBox(height: 5.0,),
          Container(
            color: MyColors.darkColor.withAlpha(180),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(design.name , style: TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                            Text(design!.price , style: TextStyle(color: MyColors.primaryColor , fontSize: 15.0 , fontWeight: FontWeight.bold),)                      ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 5.0),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.only(start: 3.0),
                        decoration: BoxDecoration(color: Colors.black12 , borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          children: [
                            Image(image: AssetImage('assets/images/gold.png') , width: 25.0,),
                            SizedBox(width: 5.0,),
                            Text(user!.gold.toString() , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0),),
                            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_outlined , color: MyColors.primaryColor, size: 20.0,)  )
                          ],
                        ),
                      ),
                      Expanded(child:
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: (){
                                purchaseDesign(design);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 8.0),
                                decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(20.0)),
                                child: Text("mall_purchase".tr , style: TextStyle(color:  MyColors.darkColor , fontSize: 16.0),),
                              ),
                            ),
                            // SizedBox(width: 10.0,),
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 8.0),
                            //   decoration: BoxDecoration(color: MyColors.blueColor , borderRadius: BorderRadius.circular(20.0)),
                            //   child: Text("Send" , style: TextStyle(color:  MyColors.darkColor , fontSize: 16.0),),
                            // ),
                          ],
                        ),
                      )
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )
  
  );

  preview(img , design) async{
    Navigator.pop(context);
      setState(() {
        preview_img = img ;
      });
     await Future.delayed(Duration(seconds: 10));
      setState(() {
        preview_img = "" ;
      });
    showModalBottomSheet(
        context: context,
        builder: (ctx) => DesignBottomSheet(design));



    // Navigator.pop(context);
    // final videoItem = await SVGAParser.shared.decodeFromURL(img);
    // this.animationController!.videoItem = videoItem;
    // this
    //     .animationController
    // !.repeat()
    // .whenComplete(() => this.animationController!.videoItem = null);
    //  await Future.delayed(Duration(seconds: 8));
    // animationController!.stop();
    // this.animationController!.videoItem = null ;
    // showModalBottomSheet(
    //     context: context,
    //     builder: (ctx) => DesignBottomSheet(design));

  }

  purchaseDesign(design) async{
    if( NumberFormat().parse(user!.gold) >= NumberFormat().parse(design.price) ){
      await DesignServices().purchaseDesign(user!.id, user!.id, design!.id);
      Navigator.pop(context);
      AppUser? res = await AppUserServices().getUser(user!.id);
      setState(() {
        user = res ;
      });
      AppUserServices().searchUser(user);
    } else {
      Fluttertoast.showToast(
          msg: "mall_msg".tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black26,
          textColor: Colors.orange,
          fontSize: 16.0
      );
    }

  }


}
