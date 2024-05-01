import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smf/utils/extension/theme.dart';
import '../../../../utils/color/app_color.dart';
import '../../../../utils/functionalities/functions.dart';
import '../../../../utils/values/app_constant.dart';
import './add_man_power_screen.dart';

class ManPowerGroupListScreen extends StatefulWidget {
  ManPowerGroupListScreen({super.key,required this.selectedGroup});
  String selectedGroup;

  @override
  State<ManPowerGroupListScreen> createState() => _ManPowerGroupListScreenState();
}

class _ManPowerGroupListScreenState extends State<ManPowerGroupListScreen> {

  List<String> locations = ['Dhaka','Barisal','Chittagong'];

  List<String> groups = [];
  Map<String,String> groupMap = {};

  Future<List<String>>? _groupMemberFuture;

  Future<List<String>> getGroupMemberList() async {
    print('Initiated Man Power Group List of ${widget.selectedGroup}');
    FirebaseDatabase database = FirebaseDatabase.instance;
    final firebaseApp = Firebase.app();
    final rtdb = FirebaseDatabase.instanceFor(
        app: firebaseApp,
        databaseURL: 'https://smfmobileapp-5b74e-default-rtdb.firebaseio.com/');

    //database.ref("${AppConstant.manPowerGroupPath}/${groupNameController.text}/people0");
    DatabaseReference ref = database.ref("${AppConstant.manPowerGroupPath}/${widget.selectedGroup}/");
    //print(ref.);
    groups.clear();
    await ref.once().then((event) {
      if (event.snapshot.exists) {
        // Extract the data as a Map
        Map<dynamic, dynamic> groupData =
        event.snapshot.value as Map<dynamic, dynamic>;
        print('Memeber List:$groupData}');
        for (var key in groupData.keys) {

        }
        print('Group Map:$groupMap');
      } else {
        print("Group with ID '123' does not exist.");
      }
    });
    return groups;
  }


  @override
  void initState(){
    super.initState();
    _groupMemberFuture = getGroupMemberList();
  }
  @override
  Widget build(BuildContext context) {
    return BasicAquaHazeBGUi(appBarTitle: AppConstant.manPowerListPlainText,
        child: initBuildUi());
  }

  Widget initBuildUi(){
    return SingleChildScrollView(
      child: Column(
          children: [
            initManPowerGroupNameUi(),
            const SizedBox(height: 10,),
            initSearchDonorUi(),
            const SizedBox(height: 10,),
            initManpowerListUi()
          ],
      ),
    );
  }

  Widget initManPowerGroupNameUi(){
    return BusinessTitleWithIcon(title: GlobalVar.customNameDecoder(widget.selectedGroup));
  }

  Widget initSearchDonorUi(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
      color: AppColor.white,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              isDense: true,
              dropdownColor: AppColor.white,
              icon: Icon(Icons.keyboard_arrow_down),
              isExpanded: false,
              //padding: EdgeInsets.all(10),
              decoration: InputDecoration(
                fillColor: AppColor.white,
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.red))
              ),
              hint: Text(AppConstant.locationPlainText,style: TextStyle(color: AppColor.alto),),
              items: locations.map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e))).toList(),
              onChanged: (value) {

              },
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
              flex: 3,
              child: TextFormField(
                decoration: InputDecoration(
              fillColor: AppColor.white,
                hoverColor: AppColor.white,
                focusColor: AppColor.white,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                suffixIcon: Icon(Icons.search,color: AppColor.alto,),
                hintText: AppConstant.nameOrNumberPlainText,
                hintStyle: TextStyle(color: AppColor.alto),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.alto)
                )
                          ),
                        )),
        ],
      ),
    );
  }

  Widget initManpowerListUi(){
    return TitleIconButtonWithWhiteBackground(
      headline: 'মোট জনশক্তি ১৫৬ জন',
      actionIcon: Icons.add,
      action: (){
      Navigator.push(context,MaterialPageRoute(builder: (context)=>AddManpowerScreen(groupName: widget.selectedGroup,)));
    },
      whatToShow:
      Column(
          children: [
            ManPowerTile(imagePath: '',name: 'Tahmid',address: 'Dhaka',phone: '328939428'),
            ManPowerTile(imagePath: '',name: 'Tahmid',address: 'Dhaka',phone: '328939428'),
            ManPowerTile(imagePath: '',name: 'Tahmid',address: 'Dhaka',phone: '328939428'),
            ManPowerTile(imagePath: '',name: 'Tahmid',address: 'Dhaka',phone: '328939428'),
            ManPowerTile(imagePath: '',name: 'Tahmid',address: 'Dhaka',phone: '328939428'),
            ManPowerTile(imagePath: '',name: 'Tahmid',address: 'Dhaka',phone: '328939428'),
            ManPowerTile(imagePath: '',name: 'Tahmid',address: 'Dhaka',phone: '328939428'),
          ],
        ),
    );
  }

}

class ManPowerTile extends StatelessWidget {
  ManPowerTile({super.key,required this.imagePath,required this.name,required this.address,required this.phone});
  String imagePath,name,address,phone;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
      ),
      title: Text(name,style: TextStyle(fontSize: 20,color: AppColor.sepiaBlack),),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(phone,style: TextStyle(color: AppColor.grey),),
        Text(address,style: TextStyle(color: AppColor.grey),),
      ],),
      trailing: PopupMenuButton(
        padding: EdgeInsets.zero,
        itemBuilder: (context) {
          return [
            PopupMenuItem(
                padding: EdgeInsets.zero,
                child: Row(mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_note,color: AppColor.killarney,),
              const SizedBox(width: 10,),
              Text(AppConstant.editPlainText,style: TextStyle(color: AppColor.killarney),)
            ],
            )),
            PopupMenuItem(
                padding: EdgeInsets.zero,
                child: Row(mainAxisSize: MainAxisSize.min,

            children: [
              Icon(Icons.delete,color: AppColor.butterCup,),
              const SizedBox(width: 10,),
              Text(AppConstant.removePlainText,style: TextStyle(color: AppColor.butterCup),)
            ],
            )),
          ];
        },
      ),
    );
  }
}
