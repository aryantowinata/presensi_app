import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'riwayatabsen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/presensi.dart';
import 'utils/mix.dart';

class Dashboard extends StatefulWidget{
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String nik="", token = "", name ="", dept ="", imgUrl="";
  late Future<Presensi> futurePresensi;

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? nik = prefs.getString('nik') ?? "";
    String? token = prefs.getString('jwt')?? "";
    String? name = prefs.getString('name')?? "";
    String? dept = prefs.getString('dept')?? "";
    String? imgUrl = prefs.getString('imgProfil')?? "Not Found";

    setState(() {
      this.token = token;
      this.nik = nik;
      this.name = name;
      this.dept = dept;
      this.imgUrl = imgUrl;
    });
  }

  Future<Presensi> fetchPresensi(String nik, String tanggal) async {
    String url = 'https://presensi.spilme.id/presence?nik=$nik&tanggal=$tanggal';
    final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token'
        }
    );

    if (response.statusCode == 200) {
      return Presensi.fromJson(jsonDecode(response.body));
    } else {
      //jika data tidak tersedia, buat data default
      return Presensi(
        id: 0,
        nik: this.nik,
        tanggal: getTodayDate(),
        jamMasuk: "--:--",
        jamKeluar: '--:--',
        lokasiMasuk: '-',
        lokasiKeluar: '-',
        status: '-',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                          imgUrl,
                          height: 64.h,
                          fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error); // Display error icon if image fails to load
                        },
                      )
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        Text(
                            dept,
                            style: TextStyle(fontSize: 15.sp)),
                      ],
                    ),
                  ),
                  Icon(Icons.notifications_outlined, size: 40.w),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Kehadiran Hari Ini",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RiwayatAbsen()),
                        );
                      },
                      child: Text(
                        "Rekap Absen",
                        style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                      ))
                ],
              ),
              SizedBox(height: 15.h),
              FutureBuilder<Presensi>(
                  future: fetchPresensi(nik, getTodayDate()),
                  builder: (context,snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    } else if(snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if(snapshot.hasData){
                      final data = snapshot.data;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child:
                            Container(
                              width: 170.w,
                              height: 140.h,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10.r), // Mengatur sudut bulat
                                border: Border.all(
                                    color: Colors.grey, width: 1), // Mengatur garis tepi
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.arrow_circle_right_outlined,
                                        size: 35.w),
                                    title: Text(
                                      'Masuk',
                                      style: TextStyle(fontSize: 18.sp),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 15.w),
                                      Text(
                                          data?.jamMasuk ?? '--:--',
                                          style: TextStyle(
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 15.w),
                                      Text(
                                        getPresenceEntryStatus(data?.jamMasuk??'-'),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(child: Container(
                            width: 170.w,
                            height: 140.h,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(10.r), // Mengatur sudut bulat
                              border: Border.all(
                                  color: Colors.grey, width: 1), // Mengatur garis tepi
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ListTile(
                                  leading: Icon(Icons.arrow_circle_right_outlined,
                                      size: 35.w),
                                  title: Text(
                                    'Keluar',
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 15.w),
                                    Text(
                                        data?.jamKeluar??'--:--',
                                        style: TextStyle(
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  children: [SizedBox(width: 15.w),
                                    Text(
                                      getPresenceExitStatus(data?.jamKeluar??'-'),
                                  )],
                                )
                              ],
                            ),
                          )
                          )

                        ],
                      );
                    }else {
                      return const Center(child: Text("No Data Available"));
                    }
                  }
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child:SizedBox(
                      width: 350.w,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: Size(350.w, 50.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * 0.9,
                                child: Padding(
                                    padding: EdgeInsets.all(20.w),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'Presensi Masuk',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25.sp),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            const Icon(
                                              Icons.calendar_month_outlined,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Tanggal Masuk",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18.sp,
                                                    ),
                                                  ),
                                                  Text("Senin, 23 Agustus 2023",
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            const Icon(
                                              Icons.schedule_outlined,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "Jam Masuk",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18.sp,
                                                    ),
                                                  ),
                                                  Text("07:03:23",
                                                      style: TextStyle(
                                                          fontSize: 15.sp,
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text("Foto selfie di area kampus",
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(child: Container(
                                              width: MediaQuery.of(context).size.width * 0.5,
                                              height: MediaQuery.of(context).size.height *0.48,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    8.r), // Mengatur sudut bulat
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width:
                                                    2), // Mengatur garis tepi
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.camera_alt,
                                                    size: 50.w,
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Text("Ambil Gambar",
                                                      style: TextStyle(
                                                          fontSize: 18.sp))
                                                ],
                                              ),
                                            ),)

                                          ],
                                        ),
                                        SizedBox(height: 10.h,),
                                        Row(
                                          children: <Widget>[
                                            Expanded(child:ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                minimumSize: Size(350.w, 50.h),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w,
                                                    vertical: 10.h),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                              ),
                                              onPressed: () {},
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Hadir",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 15.sp),
                                                  )
                                                ],
                                              ),
                                            ), )

                                          ],
                                        )
                                      ],
                                    )),
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.circle_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Tekan untuk Presensi Keluar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp),
                            )
                          ],
                        ),
                      ),
                    ),

                  ),

                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child:Container(
                    width: 170.w,
                    height: 190.h,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10.r), // Mengatur sudut bulat
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black,
                            Colors.grey,
                            Colors.grey,
                            Colors.grey,
                            Colors.black,
                          ],
                        ) // Mengatur garis tepi
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Izin Absen",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Isi form untuk meminta izin absen",
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 130.w,
                                child: Column(
                                  children: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 10.h),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8.r)),
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Ajukan Izin",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ), ),
                  const SizedBox(width: 10,),
                  Expanded(child:
                  Container(
                    width: 170.w,
                    height: 190.h,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10.r), // Mengatur sudut bulat
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.purple,
                            Colors.purpleAccent,
                            Colors.purpleAccent,
                            Colors.purpleAccent,
                            Colors.purple,
                          ],
                        ) // Mengatur garis tepi
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                "Ajukan Cuti",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Isi form untuk mengajukan cuti",
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 130.w,
                                child: Column(
                                  children: <Widget>[
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 10.h),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8.r)),
                                      ),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Ajukan Cuti",
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
