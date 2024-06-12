import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class RiwayatAbsen extends StatelessWidget {
  const RiwayatAbsen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_outlined, size: 40.sp),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Riwayat Absensi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child:Container(
                        width: 170.w,
                        height: 90.h,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10.r), // Mengatur sudut bulat
                          border: Border.all(color: Colors.blue, width: 1),
                          color: Colors.lightBlueAccent.withOpacity(0.2),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(13.w),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Jumlah Izin",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "0",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child:Container(
                        width: 170.w,
                        height: 90.h,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10.r), // Mengatur sudut bulat
                          border: Border.all(color: Colors.green, width: 1),
                          color: Colors.lightGreenAccent.withOpacity(0.2),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(13.w),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Jumlah Hadir",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "0",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Container(
                      width: 170.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10.r), // Mengatur sudut bulat
                        border: Border.all(color: Colors.purple, width: 1),
                        color: Colors.purpleAccent.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(13.w),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Jumlah Sakit",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "1",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(child: Container(
                      width: 170.w,
                      height: 90.h,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10.r), // Mengatur sudut bulat
                        border: Border.all(color: Colors.red, width: 1),
                        color: Colors.redAccent.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(13.w),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "Jumlah Alpa",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),)
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: DateTime.utc(2024),
                        lastDay: DateTime.utc(9999, 12, 31),
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle:
                              TextStyle(fontWeight: FontWeight.bold),
                        ),
                        calendarStyle: const CalendarStyle(
                          defaultTextStyle: TextStyle(
                              color:
                                  Colors.black), // Mengatur warna teks default
                          todayTextStyle: TextStyle(
                              color: Colors
                                  .deepPurpleAccent), // Mengatur warna teks hari ini
                          selectedTextStyle: TextStyle(
                              color: Colors
                                  .black), // Mengatur warna teks yang dipilih
                          weekendTextStyle: TextStyle(color: Colors.red),
                          outsideTextStyle: TextStyle(
                              color: Colors
                                  .black), // Mengatur gaya teks untuk tanggal di luar bulan yang sedang ditampilkan
                        ),
                        weekendDays: const [
                          DateTime.sunday
                        ], // Mengatur hari Minggu sebagai akhir pekan
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Aktivitas",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.sp),
                    ),
                    Text(
                      "Lihat Semua",
                      style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
