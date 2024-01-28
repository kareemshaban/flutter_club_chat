import 'package:clubchat/helpers/DesigGiftHelper.dart';
import 'package:clubchat/helpers/MallHelper.dart';
import 'package:clubchat/models/AppUser.dart';
import 'package:clubchat/models/Category.dart';
import 'package:clubchat/models/Design.dart';
import 'package:clubchat/shared/components/Constants.dart';
import 'package:clubchat/shared/network/remote/AppUserServices.dart';
import 'package:clubchat/shared/network/remote/DesignServices.dart';
import 'package:clubchat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDesignScreen extends StatefulWidget {
  const MyDesignScreen({super.key});

  @override
  State<MyDesignScreen> createState() => _MyDesignScreenState();
}

class _MyDesignScreenState extends State<MyDesignScreen> with TickerProviderStateMixin {
  AppUser? user ;
  MallHelper? helper ;
  List<Design> designs = [] ;
  List<Category> categories = [] ;
  int tabsCount = 0 ;
  TabController? _tabController ;
  List<Widget> tabs = [] ;
  List<Widget> views = [] ;

  @override
  void initState() {
    getData();
    super.initState();

  }
  getData(){
    setState(() {
      user = AppUserServices().userGetter();
      helper = DesignServices().helperGetter();
      categories = helper!.categories! ;
      tabsCount = helper!.categories!.length ;
      _tabController = new TabController(vsync: this, length: tabsCount);
      getCats();

      getMyDesigns();
    });
    
  }
  getMyDesigns() async {
    DesignGiftHelper _helper =  await AppUserServices().getMyDesigns(user!.id);

    setState(() {
      designs = _helper.designs! ;
    });
    getTabs();
  }
  Future<void> _refresh()async{
    await getData();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.whiteColor, //change your color here
          ),
          toolbarHeight: 70.0,
          backgroundColor: MyColors.darkColor,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                backgroundImage: user?.img != "" ?  NetworkImage(getUserImage()!) : null,
                radius: 20,
                child: user?.img== "" ?
                Text(user!.name.toUpperCase().substring(0 , 1) +
                    (user!.name.contains(" ") ? user!.name.substring(user!.name.indexOf(" ")).toUpperCase().substring(1 , 2) : ""),
                  style: const TextStyle(color: Colors.white , fontSize: 18.0 , fontWeight: FontWeight.bold),) : null,
              ),
              SizedBox(width: 25.0,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Text(user!.name , style: TextStyle(color: Colors.white , fontSize: 15.0 , fontWeight: FontWeight.bold),),
                      const SizedBox(width: 10.0,),
                      CircleAvatar(
                        backgroundColor: user!.gender == 0 ? MyColors.blueColor : MyColors.pinkColor ,
                        radius: 12.0,
                        child: user!.gender == 0 ?  const Icon(Icons.male , color: Colors.white, size: 15.0,) :  const Icon(Icons.female , color: Colors.white, size: 15.0,),
                      )
                    ],
                  ),
                  SizedBox(height: 3.0,),
                  Row(
                    children: [
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.share_level_icon}') , width: 30,),
                      const SizedBox(width: 10.0,),
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.karizma_level_icon}') , width: 30,),
                      const SizedBox(width: 10.0, height: 10,),
                      Image(image: NetworkImage('${ASSETSBASEURL}Levels/${user!.charging_level_icon}') , width: 20,),
                    ],
                  ),


                ],
              ),
            ],
          ),

        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.darkColor,
        padding: EdgeInsets.all(10.0),
        child: tabsCount > 0 ? Column(
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
            Expanded(child:  TabBarView(children: views ,   controller: _tabController,
            )),
          ],
        ) : Container(),
      ),
    );
  }

  getCats(){
    List<Widget> t = [] ;
    for(var i = 0 ; i < tabsCount ; i++){
      Widget tab = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0 , vertical: 5.0),
        child: Tab(text:categories![i].name),
      );
      t.add(tab);
      setState(() {
        tabs = t ;
      });
    }

  }

  getTabs() {
    List<Widget> t = [] ;
    for(var i = 0 ; i < tabsCount ; i++){
      Widget tab = getTab(categories![i].id);
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
            children: designs!.where((element) => element.category_id == catId).map((design ) => designListItem(design)).toList() ,
          ),
        ),
      ),
    ],
  );

  useDesign(design) async{
    DesignGiftHelper res = await DesignServices().useDesign(user!.id , design.category_id , design.id);
    setState(() {
      designs = res.designs! ;
      print(designs);
      getTabs();
    });

  }

  Widget designListItem(design) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      setState(() {
       // selectedDesign = design!.id ;

      });
    },
    child: Container(
      decoration: BoxDecoration(color: Colors.black26 , borderRadius: BorderRadius.circular(15.0) ),
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Container(
                  decoration: BoxDecoration(color: MyColors.lightUnSelectedColor ,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0) , topRight: Radius.circular(15.0))),
                  child: Center(
                    child: Image(image: NetworkImage(ASSETSBASEURL + 'Designs/' + design.icon),),
                    // child: SVGASimpleImage(
                    //     resUrl: "https://github.com/yyued/SVGA-Samples/blob/master/angel.svga?raw=true"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(color: Colors.black45 , borderRadius: BorderRadius.circular(15.0)),
                  child: Text("my_designs_days".tr + getRemainDays(design) , style: TextStyle(color: MyColors.primaryColor , fontSize: 13.0),),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(  borderRadius: BorderRadius.circular(15.0)),
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: (){
                    useDesign(design);
                  },
                  child: design.isDefault == 0 ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0 , vertical: 3.0),
                    decoration: BoxDecoration(color: MyColors.primaryColor , borderRadius: BorderRadius.circular(20.0)),
                    child:
                    Text("my_designs_use".tr , style: TextStyle(color:  MyColors.darkColor , fontSize: 16.0),)

                  ): Container(),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
  String getRemainDays(design){

    final DateTime dateOne = DateTime.parse(design.available_until);
    final DateTime dateTwo = DateTime.now() ;

    final Duration duration = dateOne.difference(dateTwo);

    return (duration.inDays + 1).toString() ;
  }
  String? getUserImage(){
    if(user!.img.startsWith('https')){
      return user!.img.toString() ;
    } else {
      return '${ASSETSBASEURL}AppUsers/${user?.img}' ;
    }
  }
}
