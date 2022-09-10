import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qbox_admin/models/level_up_series_model.dart';
import 'package:qbox_admin/screens/full_length_adding_screen.dart';
import 'package:qbox_admin/widgets/bottom_material_button.dart';
import 'package:qbox_admin/widgets/level_up_horizontal_card.dart';
import 'package:qbox_admin/widgets/pop_up_text_field.dart';

import '../../widgets/level_up_question_paper_preview.dart';

class FullLengthTestManagement extends StatefulWidget {
  const FullLengthTestManagement({Key? key}) : super(key: key);

  @override
  State<FullLengthTestManagement> createState() =>
      _FullLengthTestManagementState();
}

class _FullLengthTestManagementState extends State<FullLengthTestManagement> {
  int sl_no = 0;
  String? selectedValue = null;
  final _dropdownFormKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> get dropdownItems{
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text("20 minute"),value: "20"),
    DropdownMenuItem(child: Text("50 minutes"),value: "50"),
    DropdownMenuItem(child: Text("120 minutes"),value: "120"),
    DropdownMenuItem(child: Text("2 hours"),value: "2"),
  ];
  return menuItems;
}


  final GlobalKey<FormState> _fullLengthTestFormKey = GlobalKey<FormState>();
  final _testNameController = TextEditingController();
  final _courseController = TextEditingController();
  final _cidController = TextEditingController();
  final _categoryController = TextEditingController();
  final _paperSetController = TextEditingController();
  final _durationController = TextEditingController();
  final _examTimeController = TextEditingController();
  bool download = false;

  List<LevelUpTestModel> fullLengthModelList = [];
  setDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        _examTimeController.text = picked.toString().split(".000")[0];
      });
    } else {
      Fluttertoast.showToast(msg: "Date not selected is not selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding:
            EdgeInsets.all(MediaQuery.of(context).size.width * (1 / 153.6)),
        child: Column(
          children: [
            Text(
              'Tests',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width / 32,
              ),
            ),
            const Divider(
              color: Colors.amberAccent,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * (1 / 153.6),
                ),
                child: ListView(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * (1 / 153.6),
                  ),
                  children: [
                    ExpansionTile(
                      backgroundColor: Colors.white,
                      title: const Text('Upcoming'),
                      children: [
                        Divider(
                          color: Theme.of(context).primaryColor,
                        ),
                        SingleChildScrollView(
                          child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('fullLengthTest')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Something went wrong!');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.center,
                                  // runSpacing: 10,
                                  // spacing: 10,
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    DateTime endTime =
                                        DateTime.parse(data['examTime']);
                                    DateTime now = DateTime.now();
                                    if (DateTime(
                                                endTime.year,
                                                endTime.month,
                                                endTime.day,
                                                endTime.hour,
                                                endTime.minute,
                                                endTime.second)
                                            .difference(DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                now.hour,
                                                now.second))
                                            .inSeconds >=
                                        0) {
                                      LevelUpTestModel model =
                                          LevelUpTestModel.fromJson(data);
                                      fullLengthModelList.add(model);
                                      return LevelUpHorizontalCard(
                                        model: model,
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }).toList(),
                                );
                              }),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      backgroundColor: Colors.white,
                      title: const Text('completed'),
                      children: [
                        Divider(
                          color: Theme.of(context).primaryColor,
                        ),
                        SingleChildScrollView(
                          child: _dataList(),
                          // StreamBuilder<QuerySnapshot>(
                          //     stream: FirebaseFirestore.instance
                          //         .collection('fullLengthTest')
                          //         .snapshots(),
                          //     builder: (BuildContext context,
                          //         AsyncSnapshot<QuerySnapshot> snapshot) {
                          //       if (snapshot.hasError) {
                          //         return const Text('Something went wrong!');
                          //       }
                          //       if (snapshot.connectionState ==
                          //           ConnectionState.waiting) {
                          //         return const Center(
                          //             child: CircularProgressIndicator());
                          //       }
                          //       return Wrap(
                          //         crossAxisAlignment: WrapCrossAlignment.center,
                          //         alignment: WrapAlignment.center,
                          //         runSpacing: 10,
                          //         spacing: 10,
                          //         children: snapshot.data!.docs
                          //             .map((DocumentSnapshot document) {
                          //           Map<String, dynamic> data = document.data()!
                          //               as Map<String, dynamic>;
                          //           DateTime endTime =
                          //               DateTime.parse(data['examTime']);
                          //           DateTime now = DateTime.now();
                          //           if (DateTime(
                          //                       endTime.year,
                          //                       endTime.month,
                          //                       endTime.day,
                          //                       endTime.hour,
                          //                       endTime.minute,
                          //                       endTime.second)
                          //                   .difference(DateTime(
                          //                       now.year,
                          //                       now.month,
                          //                       now.day,
                          //                       now.hour,
                          //                       now.second))
                          //                   .inSeconds <
                          //               0) {
                          //             LevelUpTestModel model =
                          //                 LevelUpTestModel.fromJson(data);
                          //             fullLengthModelList.add(model);
                          //             return LevelUpHorizontalCard(
                          //               model: model,
                          //             );
                          //           } else {
                          //             return Container();
                          //           }
                          //         }).toList(),
                          //       );
                          //     }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: BottomMaterialButton(
                text: 'Add Test',
                popUpChild: Form(
                  key: _fullLengthTestFormKey,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Divider(
                        color: Colors.amber,
                      ),
                      PopUpTextField(
                        controller: _testNameController,
                        hint: '',
                        label: 'Test Name',
                        widthRatio: 2,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Field cannot be empty");
                          }
                          return null;
                        },
                      ),
                      PopUpTextField(
                        controller: _categoryController,
                        hint: 'web',
                        label: 'Category',
                        widthRatio: 2,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Field cannot be empty");
                          }
                          return null;
                        },
                      ),
                      PopUpTextField(
                        controller: _courseController,
                        hint: 'B.Tech',
                        label: 'Course',
                        widthRatio: 2,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Field cannot be empty");
                          }
                          return null;
                        },
                      ),
                      PopUpTextField(
                        controller: _cidController,
                        hint: 'Enter the Course ID',
                        label: 'ID',
                        widthRatio: 2,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Field cannot be empty");
                          }
                          return null;
                        },
                      ),
                      PopUpTextField(
                        controller: _paperSetController,
                        hint: '1',
                        label: 'Paper Set',
                        widthRatio: 2,
                        validator: (value) {
                          if (value!.isEmpty ) {
                            return ("Field cannot be empty");
                          }
                          if(double.tryParse(value)==null){
                            return 'Enter number';
                          }
                          return null;
                        },
                      ),
                      durationDropDown(),

                      Container(
                        // width: MediaQuery.of(context).size.width * (350 / 1563) * widthRatio,
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          onTap: setDate,
                          controller: _examTimeController,
                          decoration: InputDecoration(
                            hintText: '2022-09-05 19:30:00',
                            labelText: 'Exam Date',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            fillColor: Colors.grey[100],
                            filled: true,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Field cannot be empty");
                            }
                            return null;
                          },
                        ),
                      )
                      // InkWell(
                      //   onTap: setDate,
                      //   child: PopUpTextField(
                      //     controller: _examTimeController,
                      //     hint: '2022-07-08 19:30:00',
                      //     label: 'Exam Date',
                      //     widthRatio: 2,
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return ("Field cannot be empty");
                      //   }
                      //   return null;
                      // },
                      //   ),
                      // ),
                    ],
                  ),
                ),
                popUpactions: [
                  Material(
                    color: Colors.amberAccent,
                    elevation: 4,
                    type: MaterialType.button,
                    child: MaterialButton(
                      onPressed: () {
                        if (_fullLengthTestFormKey.currentState!.validate()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>FullLengthAddingScreen(
                               category: _categoryController.text.trim(),
                               course: _courseController.text.trim(),
                                chapter: "",
                                subject: "",
                               cid: _cidController.text.trim(),
                               testName: _testNameController.text.trim(),
                               duration:
                                   int.parse(selectedValue!.trim()),
                               paperSet:
                                   int.parse(_paperSetController.text.trim()),
                               examTime: _examTimeController.text.trim(),
                               collectionName: "fullLengthTest",
                              ),
                            ),
                          );
                        }
                      },
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 76.8),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 86,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // Material(
                  //   color: Colors.amberAccent,
                  //   elevation: 4,
                  //   type: MaterialType.button,
                  //   child: MaterialButton(
                  //     onPressed: setDate,
                  //     padding: EdgeInsets.all(
                  //         MediaQuery.of(context).size.width / 76.8),
                  //     child: Text(
                  //       'Exam Date',
                  //       style: TextStyle(
                  //         fontSize: MediaQuery.of(context).size.width / 86,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget durationDropDown() {
    return Form(
        key: _dropdownFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField(
                hint: Text('Duration'),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                ),
                validator: (value) => value == null ? "Duration" : null,
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: dropdownItems),
          ],
        ));
  }

  Widget _dataList() {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('fullLengthTest').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                    // width: MediaQuery.of(context).size.width,
                    width: 1200,
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.white),
                      child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Sl no.')),
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Course')),
                            DataColumn(label: Text('Cid')),
                            DataColumn(label: Text('Chapter')),
                            DataColumn(label: Text('Duration')),
                            DataColumn(label: Text('Exam Time')),
                            DataColumn(label: Text('Paper Set')),
                            DataColumn(label: Text('Test Name')),
                          ],
                          rows: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            DateTime endTime = DateTime.parse(data['examTime']);
                            DateTime now = DateTime.now();
                            LevelUpTestModel model =
                                LevelUpTestModel.fromJson(data);
                            sl_no = sl_no + 1;

                            return DataRow(
                                color: MaterialStateColor.resolveWith(
                                    (states) => Colors.black12),
                                cells: <DataCell>[
                                  DataCell(Text('${sl_no}')),
                                  DataCell(Text(model.category.toString())),
                                  DataCell(Text(model.course.toString())),
                                  DataCell(Text(model.cid.toString())),
                                  DataCell(Text(model.chapter.toString())),
                                  DataCell(Text(model.duration.toString())),
                                  DataCell(Text(model.examTime.toString())),
                                  DataCell(Text(model.paperSet.toString())),
                                  DataCell(Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(model.testName.toString()),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LevelUpQuestionPaperPreview(
                                                          questionPaper:
                                                              model)),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.arrow_right_alt,
                                            color: Colors.blue,
                                          ))
                                    ],
                                  )),
                                ]);
                          }).toList()),
                    )));
          }
          sl_no = 0;
          return Text('Loading.....');
        });
  }
}










//    Widget _dataList(){
//     return Theme(
//                       data: Theme.of(context)
//                           .copyWith(dividerColor: Colors.white),
//                       child: DataTable(

//                           //border: TableBorder.symmetric(inside: BorderSide(width: 1.5,style: BorderStyle.solid,color: Colors.red)),
//                           columns: const [
                          //   DataColumn(label: Text('Category')),
                          //   DataColumn(label: Text('Course')),
                          //   DataColumn(label: Text('Cid')),
                          //   DataColumn(label: Text('Chapter')),
                          //   DataColumn(label: Text('Duration')),
                          //  DataColumn(label: Text('Exam Time')),
                          //  DataColumn(label: Text('Paper Set')),
                          // DataColumn(label: Text('Test Name')),
//                           ],
//                           rows: [

//                            DataRow(
//                                     color: MaterialStateColor.resolveWith(
//                                         (states) => Colors.black12),
//                                     cells: <DataCell>[
//                                       DataCell(Text(widget.model.category.toString())),
//                                       DataCell(Text(widget.model.course.toString())),
//                                        DataCell(Text(widget.model.cid.toString())),
//                                         DataCell(Text(widget.model.chapter.toString())),
//                                          DataCell(Text(widget.model.duration.toString())),
//                                           DataCell(Text(widget.model.examTime.toString())),
//                                            DataCell(Text(widget.model.paperSet.toString())),
//                                             DataCell(Text(widget.model.testName.toString())),
                                     
//                                     ],
//                                   )
//                           ]
//                                   )
                                  
                          
//                     );
//   }
// }
