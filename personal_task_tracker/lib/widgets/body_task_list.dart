import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:personal_task_tracker/widgets/task_card.dart';

class BodyTaskList extends StatefulWidget {
  const BodyTaskList({super.key});

  @override
  State<BodyTaskList> createState() => _BodyTaskListState();
}

class _BodyTaskListState extends State<BodyTaskList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: [

            // Add Task Block
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.all(Radius.circular(15)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 8,sigmaY: 8,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 175,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          //border: Border.all(color: Colors.black.withAlpha(75), width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                      
                            Center(
                              child: Text('Add Task',style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),),
                            ),

                            SizedBox(height: 5,),
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                child: FormField(
                                  builder: (FormFieldState<dynamic> state) {
                                    return TextFormField(
                                      decoration: InputDecoration(
                                        
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withAlpha(70),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                      
                            SizedBox(
                              height: 15,
                            ),
                      
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Color(0xFF360033)),
                                  ),
                                  onPressed: (){
                                
                                  }, 
                                  child: Text('Add',style: TextStyle(color: Colors.white,fontSize: 22),)
                                ),
                                SizedBox(width: 15,),
                              ],
                            )
                          ],
                        )
                      ),

                      SizedBox(height: 25,),

                      // List Task Block
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 350,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          //border: Border.all(color: Colors.black.withAlpha(75), width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Align(
                          alignment: AlignmentGeometry.topCenter,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 10,),

                                TaskCard(name:'Test task',status: 'Test',),
                                
                              ],
                            ),
                          ),
                        )
                      ),                
                    ],
                  ),
                ),
              ),
            )
            
          ],
        ),
      ),
    );
  }
}