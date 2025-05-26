import 'package:flutter/material.dart';
import 'package:refill/colors.dart';
import 'package:refill/home_service/store_header.dart';
import 'package:refill/home_service/low_stock_button.dart';
import 'package:refill/home_service/weather/weather_box.dart';
import 'package:refill/home_service/holiday_calendar.dart';
import 'package:refill/home_service/stock_recommendation_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const mainBlue = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("홈"),
        backgroundColor: mainBlue,
        foregroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              StoreHeader(),
              SizedBox(height: 16),
              LowStockButton(),
              WeatherBox(),
              SizedBox(height: 24),
              HolidayCalendar(),
              SizedBox(height: 24),
              StockRecommendationBox(),
            ],
          ),
        ),
      ),
    );
  }
}
