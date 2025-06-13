import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../box/counter_box.dart';
import '../box/setting.dart';
import '../box/wazifa.dart';
import '../model/box_model/setting.dart';
import '../model/box_model/tasbih.dart';
import '../model/box_model/wazifa.dart';

class CounterProvider extends ChangeNotifier {

  // *******************************************************
  // Variables ::

  bool timer_tasbih = true ;
  bool total_count_pr = true;
  bool limit_pr = true ;
  bool sound = false ;
  bool vibration = false ;
  double volume = 0.2 ;
  double velocity = 10.0;

  setTotalCount(val) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    total_count_pr = val ;
    notifyListeners();
    data.setBool('totalCount', total_count_pr);

  }

  setLimit_pr(val) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    limit_pr = val;
    notifyListeners();
    data.setBool('limitCount', limit_pr);
  }

  setVolum(val) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    volume = val;
    data.setDouble('Volume', volume);
    notifyListeners();


  }
  setVibr(val) async{
    vibration = val ;
    final pref = await SharedPreferences.getInstance();
    pref.setBool('vibration', val);
    notifyListeners();
  }
  setTimer(val) async{
    timer_tasbih = val ;
    final pref = await SharedPreferences.getInstance();
    pref.setBool('timer', val);
    notifyListeners();
  }
  setTextVelocity(val) async{
    velocity = val ;
    final pref = await SharedPreferences.getInstance();
    pref.setDouble('velocity', val);
    notifyListeners();
  }
  setSound(bool val) async{
    sound = val;
    final pref = await SharedPreferences.getInstance();
    pref.setBool('sound', val);
    notifyListeners();
  }
  String lang = 'en';
  loadLang() async{
    final SharedPreferences obj = await SharedPreferences.getInstance();
    var data = obj.getString('language');
    var sound_1 = obj.getBool('sound');
    var vibration_1 = obj.getBool('vibration');
    var volume_1 = obj.getDouble('Volume');
    var timer_tasb = obj.getBool('timer');
    var totalCount_1 = obj.getBool('totalCount');
    var limitCount_1 = obj.getBool('limitCount');
    var textVelocity = obj.getDouble('velocity');

    if(totalCount_1  != null){
      total_count_pr = totalCount_1;
    }
    if(textVelocity != null){
      velocity = textVelocity;
    }
    if(limitCount_1 != null){
      limit_pr = limitCount_1;
    }

    if(volume_1 != null){
      volume = volume_1;
    }
    if(sound_1 != null){
      sound = sound_1;
    }
    if(timer_tasb != null){
      timer_tasbih = timer_tasb;
    }
    if(vibration_1 != null){
      vibration = vibration_1;
    }
    if (data != null){
      lang = data ;

    }
    notifyListeners();
  }




  int index = 0;

  String tasbihText = 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ';
  late Timer timer;

  int setcount = 0;
  String setcountStr = '0';
  int count = 0;
  int sec = 0;
  int min = 0;
  String secStr = "00";
  String minStr = "00";
  bool isRunning = false;
  String myCount = "00";
  bool isActive = false;

  // int rangeCount = 0 ;
  int laps = 0;
  int limit = 100;


// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  var wazifaBox = BoxWazifa.getData();

  void makeFav(index, fav) {
    bool sav = !fav;
    var data = WazifaFav(fav: sav, index: index);
    wazifaBox.put(index, data);
    data.save();
  }

//  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  // *******************************************************

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // loadings  &&   state
  int keyPre = 0;

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  // _________________________________________
  // State of Setting Saver..

  void saveStat(currentkey) {
    var box = BoxCounterSetting.getData();
    if (box.isEmpty) {
      var data = CounterState(previous: currentkey);
      box.add(data);
      data.save();

    }
    else {
      var data = CounterState(previous: currentkey);
      box.put(0, data);
      data.save();
      // print('state update successfully');
    }
  }

  void loadStat() {
    var box = BoxCounterSetting
        .getData()
        .values
        .toList();
    var box2 = BoxTasbih.getData();
    dynamic cu;
    if (box.isNotEmpty) {
      cu = box[0].previous;
      if (box2.isEmpty) {
        saveData(0);
      }
      // print(box2.toString());
      var _count = box2.get(cu);
      // print('curr load ' + cu.toString());
      if (_count != null) {
        count = _count.count;
        // rangeCount = _count.count;
        setCountUp(count, true);
        keyPre = cu;
        min = _count.minute;
        sec = _count.second;
        tasbihText = _count.tasbihText;
        laps = _count.laps;
        // print('my laos ' + _count.laps.toString());
        limit = _count.limit;
      }
      updateByTime();
      // print('store : ' + keyPre.toString());
    }
    else {
      saveStat(0);
    }
  }

  // _________________

  // Selectable History

  void selectHistory(index) {
    var box = BoxTasbih.getData();
    var key = box.keyAt(index);
    // print('history select key is => ' + box.keyAt(index).toString());
    var data = box.get(key);
    if (data != null) {
      min = data.minute;
      sec = data.second;
      count = data.count;
      tasbihText = data.tasbihText;
      limit = data.limit;
      // rangeCount = count;
      keyPre = key;
    }
    saveData(key);
  }

  // _______________________

  // +++++++++++++++++
  bool changeCounter = false;


  // _________________________________________
  // $$$$$$$$$$$$$$$$$$$$$$$$$
  // Data Edit && Create

  void incrementData(key) {
    var reco = BoxTasbih.getData();
    if (reco.isNotEmpty) {
      // print('keyPre ' + key.toString());
      // print('count us u wr ' + count.toString());
      // print('count : ' + count.toString() + "laps " + limit.toString() +
      //     "setcount " + setcount.toString());
      var data = TasbihX(minute: min,
          second: sec,
          count: count,
          limit: limit,
          laps: laps,
          tasbihText: tasbihText,
          isRunning: false);
      reco.put(key, data);
      data.save();
      setCount();
      notifyListeners();
    }
  }

  void saveData(key) {
    // print(' SaveData Key ' + key.toString());
    var rec = BoxTasbih.getData();
    if (rec.isEmpty) {
      var data = TasbihX(minute: min,
          second: sec,
          count: count,
          limit: limit,
          laps: laps,
          tasbihText: tasbihText,
          isRunning: false);
      rec.add(data);
      data.save();
      // print('Save Inside ' + key.toString());
    }
    else {
      // print('SaveData Function outSide' + key.toString());
      // print('in save data min + sec ' + min.toString() + ' ' + sec.toString());
      saveStat(key);
      incrementData(key);
    }
  }

  void updateByTime() {
    var record = BoxTasbih.getData();
    // print('key pre in upda' + keyPre.toString());
    var dataUp = TasbihX(minute: min,
        second: sec,
        count: count,
        limit: limit,
        laps: laps,
        tasbihText: tasbihText,
        isRunning: isRunning);
    // if (record != null) {
    // Here is may error
    if (record.isNotEmpty) {
      record.put(keyPre, dataUp);
    }
    if (min < 10) {
      minStr = '0' + min.toString();
      // notifyListeners();
    }
    bool load = true;
    increamentSec(load);
  }

  void setTasbih(status, dataArray) {
    if (status == true) {
      count = 0;
      min = 0;
      sec = 0;
      tasbihText = dataArray.name;
      limit = dataArray.count;
      laps = 0;
      // print('tasbih in text ' + tasbihText.toString());
      // print('tasbih is not set' + dataArray.count.toString());
    }
  }

  void addNewTasbih(status, dataArray) {
    var box = BoxTasbih.getData();
    setTasbih(status, dataArray);
    var data = TasbihX(minute: min,
        second: sec,
        count: count,
        limit: limit,
        laps: laps,
        tasbihText: tasbihText,
        isRunning: isRunning);
    box.add(data);
    data.save();
    // print('key is : save new ' + data.count.toString());
    // print('key is : save new data  ' + dataArray.count.toString());
    saveData(data.key);
  }

  // ______________________________________

  void resetAllData() {
    min = 0;
    sec = 0;
    count = 0;
    laps = 0;
    saveData(keyPre);
  }

  void changeCount(key) {
    keyPre = key;
    var rec = BoxCounterSetting.getData();
    var data = CounterState(previous: keyPre);
    // print(" key value :" + keyPre.toString());
    rec.put(0, data);
    notifyListeners();
  }


  void deleteHistory(index) {
    var box = BoxTasbih.getData();
    var key = box.keyAt(index);
    box.delete(key);
  }


  void setCountUp(count, load) {
    myCount = count.toString();
    if (myCount.length == 1) {
      myCount = '0$count';
    }
    else {
      myCount = count.toString();
    }
    if (load == false) {
      notifyListeners();
    }
  }


  // ***************************************

  // Counter Timer

  //////////////////////////////////////////////////////////

  var re = BoxTasbih.getData();

  void startTimer() {
    isRunning = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // increamentSec(true);
      saveStat(keyPre);
      updateByTime();
      notifyListeners();
    });
  }

  void increamentSec(load) {
    // print('rec is sec : ' + re.getAt(1)!.second.toString() + re.getAt(1)!.minute.toString());
    if (sec < 59) {
      sec ++;
      secStr = sec.toString();
      if (secStr.length == 1) {
        secStr = "0$sec";
      }
    }
    else {
      sec = 0;
      secStr = sec.toString();
      incrementMin(true);
    }

    // print('sec in incre' + sec.toString());
    // if(load == false){
    //   notifyListeners();
    // }
    // load = true;
  }

  void incrementMin(load) {
    if (min < 59) {
      sec = 0;
      min ++;
      minStr = min.toString();
      if (minStr.length == 1) {
        minStr = "0$min";
      }
    }
    // print('min in increa' + min.toString());
    if (load == false) {
      notifyListeners();
    }
    load = false;
  }


  // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  //  Timer Logic
  void pause() {
    if (!isActive) {
      isActive = true;
      isRunning = false;
      notifyListeners();
      timer.cancel();
    }
    else {
      isRunning = true;
      isActive = false;
      notifyListeners();
    }
  }

  void resetAll() {
    sec = 0;
    min = 0;
    secStr = "00";
    minStr = '00';
    count = 0;
    myCount = '0$count';
    limit = 0;
    setcount = 0;
    setcountStr = '00';
    isRunning = false;
    notifyListeners();
    timer.cancel();
    saveData(keyPre);
  }

  void setCount() {
    if (count < limit) {
      // print('count incoutn un metii' + count.toString());
      // print('count in laps un metii' + limit.toString());
      // print('count in set methi ' + count.toString());
      count++;
      // rangeCount++;
      myCount = count.toString();
      if (myCount.length == 1) {
        myCount = '0$count';
      }
    }
    else {
      laps++;
      count = 0;
      myCount = "00";
      // rangeCount = 0;
      setcount ++;
      setcountStr = setcount.toString();
      // print('else count ' + count.toString());
    }
    notifyListeners();
  }

  void timeReset() {
    secStr = '00';
    minStr = '00';
    sec = min = 0;
    isRunning = false;
    notifyListeners();
    timer.cancel();
  }

  void reversePause() {
    if (isRunning) {
      timer.cancel();
    }
    else if (isActive) {
      isActive = false;
      notifyListeners();
      startTimer();
    }
  }

  void setPlay() {
    if (isRunning) {
      isActive = false;
      notifyListeners();
    }
  }
  void stop(){
    if(isRunning){
      timer.cancel();
      isRunning = false;
    }

  }


  // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


  // ****************************************
  @override
  void dispose() {
    timer.cancel(); // Ensure timer is canceled when provider is disposed
    super.dispose();
  }


}