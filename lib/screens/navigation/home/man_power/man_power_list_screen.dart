import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smf/models/group_member_model.dart';
import 'package:smf/utils/extension/theme.dart';
import '../../../../utils/color/app_color.dart';
import '../../../../utils/functionalities/functions.dart';
import '../../../../utils/functionalities/shared_prefs_manager.dart';
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
  TextEditingController searchController = TextEditingController();

  bool loadData = true;
  bool showSuggestion = false;
  int total = 0 ;

  List<String> locations = [];
  String selectedLocation = '';

  List<GroupMemberModel> groupMembers = [];
  List<GroupMemberModel> filteredGroupMembers = [];
  Map<String, String> groupMap = {};

  List<GroupMemberModel> searchFilteredMemberList = [];
  List<GroupMemberModel> filteredMemberList = [];
  Future<List<GroupMemberModel>> getSearchedGroupMemberList() async {
    searchFilteredMemberList = groupMembers
        .where((element) =>
            element.name.toLowerCase().startsWith(searchController.text))
        .toList();
    return searchFilteredMemberList;
  }

  Future<List<GroupMemberModel>>? _groupMemberFuture;

  Future<List<GroupMemberModel>> getFilteredGroupMemberList() async {
    total = groupMembers.length;
    return groupMembers;
  }

  Future<List<GroupMemberModel>> getGroupMemberList() async {
    print('Initiated Man Power Group List of ${widget.selectedGroup} and base path is:${GlobalVar.basePath}');
    FirebaseDatabase database = FirebaseDatabase.instance;

    //database.ref("${AppConstant.manPowerGroupPath}/${groupNameController.text}/people0");
    DatabaseReference ref = database.ref(
        "${GlobalVar.basePath}/${AppConstant.manPowerGroupPath}/${widget.selectedGroup}/");
    //print(ref.);
    groupMembers.clear();
    locations.clear();
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
                  name: groupData[key][AppConstant.nameColumnText].toString(),
                  mobileNumber:
                      groupData[key][AppConstant.mobileColumnText].toString(),
                  position:
                      groupData[key][AppConstant.positionColumnText].toString(),
                  address:
                      groupData[key][AppConstant.addressColumnText].toString(),

                  photoUrl: groupData[key][AppConstant.profileImageColumnText]
                      .toString()));
            });
          }
        }
        print('Group Map:$groupMap');
      } else {
        print("Group with ID '123' does not exist.");
      }
    });
    setState(() {
      filteredMemberList = groupMembers;
      if(selectedLocation.isNotEmpty){
        _groupMemberFuture = getGroupMemberList();
      }
    });
    groupMembers.sort(
      (a, b) => a.name.compareTo(b.name),
    );
    return groupMembers;
  }

  @override
  void initState() {
    if (loadData) {
      _groupMemberFuture = getGroupMemberList();
    }
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
          initSearchMemberUi(),
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

  Widget initSearchMemberUi() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      color: AppColor.white,
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (value) {
              print(value);
              setState(() {
                if (value.length > 2) {
                  showSuggestion = true;
                } else {
                  showSuggestion = false;
                }
              });
            },
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
          ),
          Visibility(
              visible: showSuggestion,
              child: FutureBuilder<List<GroupMemberModel>>(
                future: getSearchedGroupMemberList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('No result Found yet'),
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('No Data Found.....'),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ManPowerTile(
                          editFunction: () async {
                            loadData = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddManpowerScreen(
                                          groupName: widget.selectedGroup,
                                          editGroupMember:
                                              snapshot.data![index],
                                        )));
                            if (loadData) {
                              _groupMemberFuture = getGroupMemberList();
                            }
                          },
                          deleteFunction: ()async {
                            showDialog(
                                context: context,
                                builder: (context) => Center(
                                  child: CircularProgressIndicator(),
                                ));
                            if (snapshot.data![index].photoUrl.isNotEmpty) {
                              final desertRef = FirebaseStorage.instance.ref().child(
                                  "${GlobalVar.basePath}/${AppConstant.manPowerGroupPath}/${widget.selectedGroup}/${snapshot.data![index].key}/${AppConstant.userImageName}");

                              await desertRef.delete();
                            }
                            DatabaseReference ref = FirebaseDatabase.instance.ref(
                                "${GlobalVar.basePath}/${AppConstant.manPowerGroupPath}/${widget.selectedGroup}/${snapshot.data![index].key}");

                            await ref.remove();
                            setState(() {
                              snapshot.data!.removeAt(index);
                            });
                            Navigator.of(context, rootNavigator: true).pop();
                            _groupMemberFuture = getGroupMemberList();
                            getFilteredGroupMemberList();
                          },
                          imagePath: snapshot.data![index].photoUrl,
                          address: snapshot.data![index].address,
                          name: snapshot.data![index].name,
                          phone: snapshot.data![index].mobileNumber,
                        );
                      },
                    );
                  }
                },
              ))
        ],
      ),
    );
  }

  Widget initManpowerListUi() {
    return TitleIconButtonWithWhiteBackground(
        headline:
            'মোট জনশক্তি ${GlobalVar.englishNumberToBengali(total.toString())} জন',
        actionIcon: Icons.add,
        action: () async {
          loadData = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddManpowerScreen(
                        groupName: widget.selectedGroup,
                      )));
          if (loadData) {
            _groupMemberFuture = getGroupMemberList();
          }
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
                child: Text('Please add Group Member.'),
              );
            } else {
              //setState(() {
              //filteredBloodDonorList = snapshot.data!;
              //});
              total = snapshot.data!.length;
              return ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ManPowerTile(
                    imagePath: snapshot.data![index].photoUrl,
                    name: snapshot.data![index].name,
                    address:
                        snapshot.data![index].address,
                    phone: snapshot.data![index].mobileNumber,
                    editFunction: () async {
                      loadData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddManpowerScreen(
                                    groupName: widget.selectedGroup,
                                    editGroupMember: snapshot.data![index],
                                  )));
                      if (loadData) {
                        _groupMemberFuture = getGroupMemberList();
                      }
                    },
                    deleteFunction: () {
                      showDialog(context: context, builder: (context)=>AlertDialog(
                        content: Text('Are you want to delete the member?'),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(context,rootNavigator: true).pop();
                          }, child: Text('No')),
                          TextButton(onPressed: ()async{
                            showDialog(
                                context: context,
                                builder: (context) => Center(
                                  child: CircularProgressIndicator(),
                                ));
                            if (snapshot.data![index].photoUrl.isNotEmpty) {
                              final desertRef = FirebaseStorage.instance.ref().child(
                                  "${GlobalVar.basePath}/${AppConstant.manPowerGroupPath}/${widget.selectedGroup}/${snapshot.data![index].key}/${AppConstant.userImageName}");

                              await desertRef.delete();
                            }
                            DatabaseReference ref = FirebaseDatabase.instance.ref(
                                "${GlobalVar.basePath}/${AppConstant.manPowerGroupPath}/${widget.selectedGroup}/${snapshot.data![index].key}");

                            await ref.remove();
                            setState(() {
                              snapshot.data!.removeAt(index);
                            });
                            Navigator.of(context, rootNavigator: true).pop();
                            Navigator.of(context, rootNavigator: true).pop();
                          }, child: Text('Yes')),
                        ],
                      ));
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
        overflow: TextOverflow.fade,
        maxLines: 1,
        style: TextStyle(
          fontSize: 20,
          color: AppColor.sepiaBlack,
        ),
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
