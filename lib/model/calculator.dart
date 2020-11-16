import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PVCalculatorBrain {
  double maxExpectedLoad = 0,
      hours = 0,
      panel = 0,
      hoursOfSunPerDay = 0,
      loadDailyWattHours = 0,
      loadMonthlyWattHours = 0,
      solarDailyWattHours = 0,
      solarMonthlyWattHours = 0,
      batteryValue = 0,
      requiredBatterySize = 0,
      //Installation parameters
      voc = 0,
      isc = 0,
      rating = 0,
      quantity = 0,
      connectionType = 0,
      power = 0,
      maxVoltage = 0,
      maxCurrent = 0,
      minVoltage = 0,
      minCurrent = 0,
      cableLength = 0,
      crossSection = 0,
      cableType = 0,
      pvLosses = 0,
      pvPercent = 0,
      voltageRating = 0,
      fuseCurrent = 0,

      //off grid parameters
      wattHoursPerDay = 0,
      daysOfBackUp = 0,
      lowestBattTemp = 0,
      battBankVoltage = 0;
  int cap, perString;
  Widget status;
  var percent;

  offGridCalculator(double whpd, double dop, double lbt, double bbv) {
    wattHoursPerDay = whpd;
    daysOfBackUp = dop;
    lowestBattTemp = lbt;
    battBankVoltage = bbv;

    wattHoursPerDay = wattHoursPerDay * 2 * 1.15;
    wattHoursPerDay = wattHoursPerDay * daysOfBackUp;
    wattHoursPerDay = wattHoursPerDay * lowestBattTemp;
     cap = (wattHoursPerDay/ battBankVoltage).ceil();
    perString=(cap/3).ceil();
  }

  installationCalculator(
      double vol, double isC, double rat, double quan, double conn) {
    voc = vol;
    isc = isC;
    rating = rat;
    quantity = quan;
    connectionType = conn;

    power = rating * (connectionType == 1 ? quantity : 1);
    maxVoltage = 1.2 * voc * (connectionType == 1 ? 1 : quantity);
    maxCurrent = 1.25 * isc * (connectionType == 1 ? quantity : 1);
    minVoltage = maxVoltage + 6;
    minCurrent = maxCurrent + 2;
    fuseCurrent = 1.4 * maxCurrent;
    voltageRating = maxVoltage;
  }

  cableCrossSection(double len, double mpsq, int cable) {
    print('cable = $cable');
    crossSection = len;
    cableLength = mpsq;
    //cableType=cable;
    pvLosses = (2 * cableLength * maxCurrent * maxCurrent) /
        ((cable == 1 ? 56 : 38) * crossSection);
    pvPercent = (pvLosses * 100 / power);
  }

  pvSetupCalculator(
      double maxExpected, double hoursOfSun, double pan, double hour) {
    maxExpectedLoad = maxExpected;
    hoursOfSunPerDay = hoursOfSun;
    panel = pan;
    hours = hour;
    solarDailyWattHours = hoursOfSunPerDay * panel;
    solarMonthlyWattHours = solarDailyWattHours * 30;
    loadDailyWattHours = maxExpectedLoad * hours;
    loadMonthlyWattHours = loadDailyWattHours * 30;
    percent = solarMonthlyWattHours / loadMonthlyWattHours;
    percent = percent * 100;

    print('percent = $percent');
    if (percent < 100) {
      status = AutoSizeText(
          'Your solar power system will power ${percent.toStringAsFixed(2)}% of your appliances.',
          style: TextStyle(
              color: Colors.redAccent,
              fontSize: 18.0,
              fontWeight: FontWeight.w400),
          maxLines: 3,
          minFontSize: 15.0,
          overflow: TextOverflow.fade);
    } else if (percent == 100) {
      status = AutoSizeText(
          'Your solar system will just power your appliances.',
          style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 18.0,
              fontWeight: FontWeight.w400),
          maxLines: 3,
          minFontSize: 15.0,
          overflow: TextOverflow.fade);
    } else {
      status = AutoSizeText(
          'Congratulations, your solar power system is producing "${percent-100}"% more than your appliances use.  You can sell the excess energy back to your power supplier.',
          style: TextStyle(
              color: Colors.green, fontSize: 18.0, fontWeight: FontWeight.w400),
          maxLines: 5,
          minFontSize: 12.0,
          overflow: TextOverflow.fade);
    }
  }

  calculateBatterySizing(int battery) {
    batteryValue = (loadDailyWattHours / battery) * 1.35;
    print(batteryValue);
  }
}
