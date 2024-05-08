import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:smf/models/group_member_model.dart';
import 'package:smf/utils/extension/theme.dart';
import '../../../../utils/color/app_color.dart';
import '../../../../utils/functionalities/functions.dart';
import '../../../../utils/values/app_constant.dart';
import './add_man_power_screen.dart';

class ManPowerGroupListScreen extends StatefulWidget {
  ManPowerGroupListScreen({super.key, required this.selectedGroup});
  String selectedGroup;

  @override
  State<ManPowerGroupListScreen> createState() =>
      _ManPowerGroupListScreenState();
}

class _ManPowerGroupListScreenState extends State<ManPowerGroupListScreen> {
  List<String> locations = [];

  List<GroupMemberModel> groupMembers = [];
  Map<String, String> groupMap = {};

  Future<List<GroupMemberModel>>? _groupMemberFuture;

  Future<List<GroupMemberModel>> getGroupMemberList() async {
    print('Initiated Man Power Group List of ${widget.selectedGroup}');
    FirebaseDatabase database = FirebaseDatabase.instance;

    //database.ref("${AppConstant.manPowerGroupPath}/${groupNameController.text}/people0");
    DatabaseReference ref = database
        .ref("${AppConstant.manPowerGroupPath}/${widget.selectedGroup}/");
    //print(ref.);
    groupMembers.clear();
    await ref.once().then((event) {
      if (event.snapshot.exists) {
        // Extract the data as a Map
        Map<dynamic, dynamic> groupData =
            event.snapshot.value as Map<dynamic, dynamic>;
        print('Memeber List:$groupData}');
        for (var key in groupData.keys) {
          if (key != AppConstant.ignoredKey) {
            setState(() {
              groupMembers.add(GroupMemberModel(
                  key: key,
                  name: groupData[key][AppConstant.nameColumnText],
                  mobileNumber: groupData[key][AppConstant.mobileColumnText],
                  cityName: groupData[key][AppConstant.cityNameColumnText],
                  districtName: groupData[key]
                  [AppConstant.districtNameColumnText],
                  division: groupData[key][AppConstant.divisionColumnText],
                  postCode: groupData[key][AppConstant.postCodeColumnText],
                  photoUrl: groupData[key][AppConstant.profileImageColumnText]));
            });
          }
        }
        print('Group Map:$groupMap');
      } else {
        print("Group with ID '123' does not exist.");
      }
    });
    return groupMembers;
  }

  @override
  void initState() {
    _groupMemberFuture = getGroupMemberList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BasicAquaHazeBGUi(
        appBarTitle: AppConstant.manPowerListPlainText, child: initBuildUi());
  }

  Widget initBuildUi() {
    return SingleChildScrollView(
      child: Column(
        children: [
          initManPowerGroupNameUi(),
          const SizedBox(
            height: 10,
          ),
          initSearchDonorUi(),
          const SizedBox(
            height: 10,
          ),
          initManpowerListUi()
        ],
      ),
    );
  }

  Widget initManPowerGroupNameUi() {
    return BusinessTitleWithIcon(
        title: GlobalVar.customNameDecoder(widget.selectedGroup));
  }

  Widget initSearchDonorUi() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                      borderSide: BorderSide(color: AppColor.red))),
              hint: Text(
                AppConstant.locationPlainText,
                style: TextStyle(color: AppColor.alto),
              ),
              items: locations
                  .map(
                      (e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
              flex: 3,
              child: TextFormField(
                decoration: InputDecoration(
                    fillColor: AppColor.white,
                    hoverColor: AppColor.white,
                    focusColor: AppColor.white,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    suffixIcon: Icon(
                      Icons.search,
                      color: AppColor.alto,
                    ),
                    hintText: AppConstant.nameOrNumberPlainText,
                    hintStyle: TextStyle(color: AppColor.alto),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.alto))),
              )),
        ],
      ),
    );
  }

  Widget initManpowerListUi() {
    return TitleIconButtonWithWhiteBackground(
        headline:
            'মোট জনশক্তি ${GlobalVar.englishNumberToBengali(groupMembers.length.toString())} জন',
        actionIcon: Icons.add,
        action: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddManpowerScreen(
                        groupName: widget.selectedGroup,
                      )));
        },
        whatToShow: FutureBuilder<List<GroupMemberModel>>(
          future: _groupMemberFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text('Please add Blood donor.'),
              );
            } else {
              //setState(() {
              //filteredBloodDonorList = snapshot.data!;
              //});
              return ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ManPowerTile(
                    imagePath: snapshot.data![index].photoUrl,
                    name: snapshot.data![index].name,
                    address:
                        '${snapshot.data![index].cityName},${snapshot.data![index].districtName},${snapshot.data![index].division}-${snapshot.data![index].postCode}',
                    phone: snapshot.data![index].mobileNumber,
                    editFunction: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddManpowerScreen(
                                    groupName: widget.selectedGroup,
                                    editGroupMember: snapshot.data![index],
                                  )));
                    },
                    deleteFunction: () async {
                      showDialog(
                          context: context,
                          builder: (context) => Center(
                                child: CircularProgressIndicator(),
                              ));
                      if(snapshot.data![index].photoUrl.isNotEmpty){
                        final desertRef = FirebaseStorage.instance.ref().child(
                            "${AppConstant.manPowerGroupPath}/${widget.selectedGroup}/${snapshot.data![index].key}/${AppConstant.userImageName}");

                        await desertRef.delete();
                      }
                      DatabaseReference ref = FirebaseDatabase.instance.ref(
                          "${AppConstant.manPowerGroupPath}/${widget.selectedGroup}/${snapshot.data![index].key}");

                      await ref.remove();
                      setState(() {
                        snapshot.data!.removeAt(index);
                      });
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  );
                },
              );
            }
          },
        ));
  }
}

class ManPowerTile extends StatelessWidget {
  ManPowerTile({
    super.key,
    required this.imagePath,
    required this.name,
    required this.address,
    required this.phone,
    required this.editFunction,
    required this.deleteFunction,
  });
  String imagePath, name, address, phone;
  VoidCallback deleteFunction, editFunction;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        margin: EdgeInsets.only(
          left: 10,
          top: 10,
          bottom: 10,
        ),
        width: 50,
        height: 50,
        decoration: imagePath.isNotEmpty
            ? BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                      imagePath,
                    ),
                    fit: BoxFit.fill))
            : BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.sepiaBlack,
              ),
      ),
      title: Text(
        name,
        style: TextStyle(fontSize: 20, color: AppColor.sepiaBlack),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            phone,
            style: TextStyle(color: AppColor.grey),
          ),
          Text(
            address,
            style: TextStyle(color: AppColor.grey),
          ),
        ],
      ),
      trailing: PopupMenuButton(
        padding: EdgeInsets.zero,
        itemBuilder: (context) {
          return [
            PopupMenuItem(
                onTap: editFunction,
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_note,
                      color: AppColor.killarney,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppConstant.editPlainText,
                      style: TextStyle(color: AppColor.killarney),
                    )
                  ],
                )),
            PopupMenuItem(
                onTap: deleteFunction,
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete,
                      color: AppColor.butterCup,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      AppConstant.removePlainText,
                      style: TextStyle(color: AppColor.butterCup),
                    )
                  ],
                )),
          ];
        },
      ),
    );
  }
}
