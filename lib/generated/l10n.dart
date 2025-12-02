// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Your All-in one Activity Tracker!`
  String get allInOneTrack {
    return Intl.message(
      'Your All-in one Activity Tracker!',
      name: 'allInOneTrack',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enterYourName {
    return Intl.message(
      'Enter your name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Start Using Steps`
  String get startUsingSteps {
    return Intl.message(
      'Start Using Steps',
      name: 'startUsingSteps',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong!`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong!',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Exchanges`
  String get exchanges {
    return Intl.message(
      'Exchanges',
      name: 'exchanges',
      desc: '',
      args: [],
    );
  }

  /// `Rewards`
  String get rewards {
    return Intl.message(
      'Rewards',
      name: 'rewards',
      desc: '',
      args: [],
    );
  }

  /// `Board`
  String get leaderboard {
    return Intl.message(
      'Board',
      name: 'leaderboard',
      desc: '',
      args: [],
    );
  }

  /// `No Data Available!`
  String get emptyState {
    return Intl.message(
      'No Data Available!',
      name: 'emptyState',
      desc: '',
      args: [],
    );
  }

  /// `Available Rewards`
  String get availableRewards {
    return Intl.message(
      'Available Rewards',
      name: 'availableRewards',
      desc: '',
      args: [],
    );
  }

  /// `More coming soon!`
  String get moreComingSoon {
    return Intl.message(
      'More coming soon!',
      name: 'moreComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Pedometer`
  String get pedometer {
    return Intl.message(
      'Pedometer',
      name: 'pedometer',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations! You gained more health points`
  String get gainMorePoints {
    return Intl.message(
      'Congratulations! You gained more health points',
      name: 'gainMorePoints',
      desc: '',
      args: [],
    );
  }

  /// `Total Steps Today`
  String get totalStepsToday {
    return Intl.message(
      'Total Steps Today',
      name: 'totalStepsToday',
      desc: '',
      args: [],
    );
  }

  /// `Step Goal:`
  String get stepGoal {
    return Intl.message(
      'Step Goal:',
      name: 'stepGoal',
      desc: '',
      args: [],
    );
  }

  /// `Health Points`
  String get healthPoints {
    return Intl.message(
      'Health Points',
      name: 'healthPoints',
      desc: '',
      args: [],
    );
  }

  /// `Total Steps`
  String get totalSteps {
    return Intl.message(
      'Total Steps',
      name: 'totalSteps',
      desc: '',
      args: [],
    );
  }

  /// `Pts`
  String get points {
    return Intl.message(
      'Pts',
      name: 'points',
      desc: '',
      args: [],
    );
  }

  /// `QR Code`
  String get qrCode {
    return Intl.message(
      'QR Code',
      name: 'qrCode',
      desc: '',
      args: [],
    );
  }

  /// `Scan the QR Code and the points will be taken`
  String get scanQrCode {
    return Intl.message(
      'Scan the QR Code and the points will be taken',
      name: 'scanQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Dummy Done`
  String get dummyDone {
    return Intl.message(
      'Dummy Done',
      name: 'dummyDone',
      desc: '',
      args: [],
    );
  }

  /// `Notice`
  String get notice {
    return Intl.message(
      'Notice',
      name: 'notice',
      desc: '',
      args: [],
    );
  }

  /// `Your points are less than the item's points, walk more and try again!`
  String get pointsLessThanItem {
    return Intl.message(
      'Your points are less than the item\'s points, walk more and try again!',
      name: 'pointsLessThanItem',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Earn`
  String get earn {
    return Intl.message(
      'Earn',
      name: 'earn',
      desc: '',
      args: [],
    );
  }

  String get welcomeToTracker {
    return Intl.message('Welcome to Tracker',
        name: 'welcomeToTracker', desc: '', args: []);
  }

  String get letsCreateProfile {
    return Intl.message('Let\'s create your profile',
        name: 'letsCreateProfile', desc: '', args: []);
  }

  String get yourIdentity {
    return Intl.message('Your Identity',
        name: 'yourIdentity', desc: '', args: []);
  }

  String get howToCallYou {
    return Intl.message('How should we call you?',
        name: 'howToCallYou', desc: '', args: []);
  }

  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  String get enterFirstName {
    return Intl.message('Enter your first name',
        name: 'enterFirstName', desc: '', args: []);
  }

  String get enterLastName {
    return Intl.message('Enter your last name',
        name: 'enterLastName', desc: '', args: []);
  }

  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  String get physicalInfo {
    return Intl.message('Physical Information',
        name: 'physicalInfo', desc: '', args: []);
  }

  String get helpPersonalize {
    return Intl.message('Help us personalize your experience',
        name: 'helpPersonalize', desc: '', args: []);
  }

  String get weight {
    return Intl.message('Weight (kg)', name: 'weight', desc: '', args: []);
  }

  String get height {
    return Intl.message('Height (cm)', name: 'height', desc: '', args: []);
  }

  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  String get weightExample {
    return Intl.message('Ex: 70', name: 'weightExample', desc: '', args: []);
  }

  String get heightExample {
    return Intl.message('Ex: 175', name: 'heightExample', desc: '', args: []);
  }

  String get ageExample {
    return Intl.message('Ex: 25', name: 'ageExample', desc: '', args: []);
  }

  String get summary {
    return Intl.message('Summary', name: 'summary', desc: '', args: []);
  }

  String get verifyInfo {
    return Intl.message('Verify your information',
        name: 'verifyInfo', desc: '', args: []);
  }

  String get identity {
    return Intl.message('Identity', name: 'identity', desc: '', args: []);
  }

  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  String get physicalInformation {
    return Intl.message('Physical Information',
        name: 'physicalInformation', desc: '', args: []);
  }

  String get years {
    return Intl.message('years', name: 'years', desc: '', args: []);
  }

  String get canModifyLater {
    return Intl.message(
        'You can modify this information anytime in your profile.',
        name: 'canModifyLater',
        desc: '',
        args: []);
  }

  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  String get requiredField {
    return Intl.message('This field is required',
        name: 'requiredField', desc: '', args: []);
  }

  String get myProfile {
    return Intl.message('My Profile', name: 'myProfile', desc: '', args: []);
  }

  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  String get personalInfo {
    return Intl.message('Personal Information',
        name: 'personalInfo', desc: '', args: []);
  }

  String get profileUpdated {
    return Intl.message('✅ Profile updated successfully!',
        name: 'profileUpdated', desc: '', args: []);
  }

  String get memberSince {
    return Intl.message('Member since',
        name: 'memberSince', desc: '', args: []);
  }

  String get bodyMassIndex {
    return Intl.message('Body Mass Index',
        name: 'bodyMassIndex', desc: '', args: []);
  }

  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  String get currentSpeed {
    return Intl.message('Current Speed',
        name: 'currentSpeed', desc: '', args: []);
  }

  String get average {
    return Intl.message('Average', name: 'average', desc: '', args: []);
  }

  String get stepsToday {
    return Intl.message('Steps Today', name: 'stepsToday', desc: '', args: []);
  }

  String get goal {
    return Intl.message('Goal', name: 'goal', desc: '', args: []);
  }

  String get steps {
    return Intl.message('steps', name: 'steps', desc: '', args: []);
  }

  String get distance {
    return Intl.message('Distance', name: 'distance', desc: '', args: []);
  }

  String get calories {
    return Intl.message('Calories', name: 'calories', desc: '', args: []);
  }

  String get activeTime {
    return Intl.message('Active Time', name: 'activeTime', desc: '', args: []);
  }

  String get battery {
    return Intl.message('Battery', name: 'battery', desc: '', args: []);
  }

  String get weekActivity {
    return Intl.message('Weekly Activity',
        name: 'weekActivity', desc: '', args: []);
  }

  String get viewFullHistory {
    return Intl.message('View Full History',
        name: 'viewFullHistory', desc: '', args: []);
  }

  String get imcAndCalories {
    return Intl.message('BMI & Calories',
        name: 'imcAndCalories', desc: '', args: []);
  }

  String get imcCalculation {
    return Intl.message('📊 BMI Calculation',
        name: 'imcCalculation', desc: '', args: []);
  }

  String get yourBmi {
    return Intl.message('Your BMI', name: 'yourBmi', desc: '', args: []);
  }

  String get calculateMyBmi {
    return Intl.message('Calculate my BMI',
        name: 'calculateMyBmi', desc: '', args: []);
  }

  String get caloriesCalculation {
    return Intl.message('🔥 Calories Burned Calculation',
        name: 'caloriesCalculation', desc: '', args: []);
  }

  String get activityType {
    return Intl.message('Activity Type',
        name: 'activityType', desc: '', args: []);
  }

  String get duration {
    return Intl.message('Duration (min)', name: 'duration', desc: '', args: []);
  }

  String get calculateCalories {
    return Intl.message('Calculate Calories',
        name: 'calculateCalories', desc: '', args: []);
  }

  String get caloriesBurned {
    return Intl.message('Calories Burned',
        name: 'caloriesBurned', desc: '', args: []);
  }

  String get imcReferenceTable {
    return Intl.message('📋 BMI Reference Table',
        name: 'imcReferenceTable', desc: '', args: []);
  }

  String get severeThinness {
    return Intl.message('Severe Thinness',
        name: 'severeThinness', desc: '', args: []);
  }

  String get moderateThinness {
    return Intl.message('Moderate Thinness',
        name: 'moderateThinness', desc: '', args: []);
  }

  String get mildThinness {
    return Intl.message('Mild Thinness',
        name: 'mildThinness', desc: '', args: []);
  }

  String get normalWeight {
    return Intl.message('Normal Weight',
        name: 'normalWeight', desc: '', args: []);
  }

  String get overweight {
    return Intl.message('Overweight', name: 'overweight', desc: '', args: []);
  }

  String get obesityClass1 {
    return Intl.message('Obesity Class I',
        name: 'obesityClass1', desc: '', args: []);
  }

  String get obesityClass2 {
    return Intl.message('Obesity Class II',
        name: 'obesityClass2', desc: '', args: []);
  }

  String get obesityClass3 {
    return Intl.message('Obesity Class III',
        name: 'obesityClass3', desc: '', args: []);
  }

  String get history {
    return Intl.message('History', name: 'history', desc: '', args: []);
  }

  String get noDataAvailable {
    return Intl.message('No data available',
        name: 'noDataAvailable', desc: '', args: []);
  }

  String get connectIot {
    return Intl.message(
        'Connect your IoT device\nto start tracking your activities',
        name: 'connectIot',
        desc: '',
        args: []);
  }

  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  String get monday {
    return Intl.message('Monday', name: 'monday', desc: '', args: []);
  }

  String get tuesday {
    return Intl.message('Tuesday', name: 'tuesday', desc: '', args: []);
  }

  String get wednesday {
    return Intl.message('Wednesday', name: 'wednesday', desc: '', args: []);
  }

  String get thursday {
    return Intl.message('Thursday', name: 'thursday', desc: '', args: []);
  }

  String get friday {
    return Intl.message('Friday', name: 'friday', desc: '', args: []);
  }

  String get saturday {
    return Intl.message('Saturday', name: 'saturday', desc: '', args: []);
  }

  String get sunday {
    return Intl.message('Sunday', name: 'sunday', desc: '', args: []);
  }

  String get min {
    return Intl.message('min', name: 'min', desc: '', args: []);
  }

  String get kcal {
    return Intl.message('kcal', name: 'kcal', desc: '', args: []);
  }

  String get km {
    return Intl.message('km', name: 'km', desc: '', args: []);
  }

  String get cal {
    return Intl.message('cal', name: 'cal', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
