import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// Success notification title after sending message
  ///
  /// In en, this message translates to:
  /// **'Thank you for your message!'**
  String get messageSuccessTitle;

  /// Error message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailValidationError;

  /// Thank you message for user feedback
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get feedbackThanks;

  /// Title for contact us section
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// Label for email input field
  ///
  /// In en, this message translates to:
  /// **'Your contact email'**
  String get contactEmailLabel;

  /// Hint text for email input field
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get contactEmailHint;

  /// Label for message input field
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get contactMessageLabel;

  /// Hint text for message input field
  ///
  /// In en, this message translates to:
  /// **'Describe your issue or suggestion...'**
  String get contactMessageHint;

  /// Error message for too short message
  ///
  /// In en, this message translates to:
  /// **'Message must be at least 10 characters'**
  String get contactMessageError;

  /// Text for send button
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendButton;

  /// Title for the settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @textHints.
  ///
  /// In en, this message translates to:
  /// **'hints'**
  String get textHints;

  /// No description provided for @textLevels.
  ///
  /// In en, this message translates to:
  /// **'level'**
  String get textLevels;

  /// Элемент: boots
  ///
  /// In en, this message translates to:
  /// **'Boots'**
  String get boots;

  /// Элемент: carriage
  ///
  /// In en, this message translates to:
  /// **'Carriage'**
  String get carriage;

  /// Элемент: cart
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// Элемент: cloth
  ///
  /// In en, this message translates to:
  /// **'Cloth'**
  String get cloth;

  /// Элемент: forest
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forest;

  /// Element: Grandmother
  ///
  /// In en, this message translates to:
  /// **'Grandmother'**
  String get grandmother;

  /// Элемент: lightning
  ///
  /// In en, this message translates to:
  /// **'Lightning'**
  String get lightning;

  /// Элемент: mead
  ///
  /// In en, this message translates to:
  /// **'Mead'**
  String get mead;

  /// Элемент: rain
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get rain;

  /// Элемент: sandstorm
  ///
  /// In en, this message translates to:
  /// **'Sandstorm'**
  String get sandstorm;

  /// Элемент: satellite
  ///
  /// In en, this message translates to:
  /// **'Satellite'**
  String get satellite;

  /// Элемент: scentist
  ///
  /// In en, this message translates to:
  /// **'Scentist'**
  String get scentist;

  /// Элемент: smartphone
  ///
  /// In en, this message translates to:
  /// **'Smartphone'**
  String get smartphone;

  /// Элемент: spaceship
  ///
  /// In en, this message translates to:
  /// **'Spaceship'**
  String get spaceship;

  /// Элемент: steam
  ///
  /// In en, this message translates to:
  /// **'Steam'**
  String get steam;

  /// Элемент: storm
  ///
  /// In en, this message translates to:
  /// **'Storm'**
  String get storm;

  /// Элемент: wireless
  ///
  /// In en, this message translates to:
  /// **'Wireless'**
  String get wireless;

  /// Элемент: computer
  ///
  /// In en, this message translates to:
  /// **'Computer'**
  String get computer;

  /// Элемент: glass
  ///
  /// In en, this message translates to:
  /// **'Glass'**
  String get glass;

  /// Элемент: home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Элемент: hourglass
  ///
  /// In en, this message translates to:
  /// **'Hourglass'**
  String get hourglass;

  /// Элемент: jazz
  ///
  /// In en, this message translates to:
  /// **'Jazz'**
  String get jazz;

  /// Элемент: planet
  ///
  /// In en, this message translates to:
  /// **'Planet'**
  String get planet;

  /// Элемент: quantum
  ///
  /// In en, this message translates to:
  /// **'Quantum'**
  String get quantum;

  /// Элемент: voodoo
  ///
  /// In en, this message translates to:
  /// **'Voodoo'**
  String get voodoo;

  /// Элемент: whiskey
  ///
  /// In en, this message translates to:
  /// **'Whiskey'**
  String get whiskey;

  /// Элемент: bier
  ///
  /// In en, this message translates to:
  /// **'Bier'**
  String get bier;

  /// Элемент: bird
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get bird;

  /// Элемент: centaur
  ///
  /// In en, this message translates to:
  /// **'Centaur'**
  String get centaur;

  /// Элемент: coffee
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get coffee;

  /// Элемент: cold
  ///
  /// In en, this message translates to:
  /// **'Cold'**
  String get cold;

  /// Элемент: energy
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// Элемент: garden
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get garden;

  /// Элемент: ghost
  ///
  /// In en, this message translates to:
  /// **'Ghost'**
  String get ghost;

  /// Элемент: hero
  ///
  /// In en, this message translates to:
  /// **'Hero'**
  String get hero;

  /// Элемент: honey
  ///
  /// In en, this message translates to:
  /// **'Honey'**
  String get honey;

  /// Элемент: meat
  ///
  /// In en, this message translates to:
  /// **'Meat'**
  String get meat;

  /// Элемент: microscope
  ///
  /// In en, this message translates to:
  /// **'Microscope'**
  String get microscope;

  /// Элемент: obsidian
  ///
  /// In en, this message translates to:
  /// **'Obsidian'**
  String get obsidian;

  /// Элемент: poltergeist
  ///
  /// In en, this message translates to:
  /// **'Poltergeist'**
  String get poltergeist;

  /// Элемент: horse
  ///
  /// In en, this message translates to:
  /// **'Horse'**
  String get horse;

  /// Элемент: lava
  ///
  /// In en, this message translates to:
  /// **'Lava'**
  String get lava;

  /// Элемент: titanic
  ///
  /// In en, this message translates to:
  /// **'Titanic'**
  String get titanic;

  /// Label for language selection option
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @writeToUs.
  ///
  /// In en, this message translates to:
  /// **'Write to us'**
  String get writeToUs;

  /// No description provided for @finds.
  ///
  /// In en, this message translates to:
  /// **'Finds'**
  String get finds;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get startGame;

  /// Label for sound toggle option
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// Button text for sending a test notification
  ///
  /// In en, this message translates to:
  /// **'Test notification'**
  String get testNotification;

  /// Message shown after test notification is sent
  ///
  /// In en, this message translates to:
  /// **'Test notification sent!'**
  String get testNotificationSent;

  /// Button text to return to main menu
  ///
  /// In en, this message translates to:
  /// **'To menu'**
  String get backToMenu;

  /// Label for task in current level
  ///
  /// In en, this message translates to:
  /// **'level assignment'**
  String get level_task;

  /// Title shown when user levels up
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get new_level_element_title;

  /// Message indicating level advancement
  ///
  /// In en, this message translates to:
  /// **'You have advanced to the next level:'**
  String get new_level_element_text;

  /// Button text to proceed after leveling up
  ///
  /// In en, this message translates to:
  /// **'Next Level'**
  String get new_level_element_button_text;

  /// Title for all combinations screen
  ///
  /// In en, this message translates to:
  /// **'All Combinations'**
  String get merge_all_title;

  /// Subtitle for list of discovered combinations
  ///
  /// In en, this message translates to:
  /// **'Combinations you\'ve unlocked:'**
  String get merge_all_title_you;

  /// Subtitle for full list of available combinations
  ///
  /// In en, this message translates to:
  /// **'All possible combinations:'**
  String get merge_all_title_all;

  /// Column or label for element
  ///
  /// In en, this message translates to:
  /// **'element'**
  String get merge_element;

  /// Column or label for result
  ///
  /// In en, this message translates to:
  /// **'result'**
  String get merge_result;

  /// Displays the number of hints remaining . Indicates how many hints are remainin
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Hint left} other{Hints left}}: {count}'**
  String hints_left(int count);

  /// Currency in which you can buy a hint
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get hints_cost;

  /// Message displayed when user has no hints left
  ///
  /// In en, this message translates to:
  /// **'You\'ve run out of hints'**
  String get run_out_of_hints;

  /// Label for hint
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get hints_hints;

  /// Button to dismiss a hint
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get hints_good;

  /// Title for combinations section
  ///
  /// In en, this message translates to:
  /// **'All Combinations'**
  String get combinationsTitle;

  /// Text before list of unlocked combinations
  ///
  /// In en, this message translates to:
  /// **'Your discovered combinations:'**
  String get discoveredCombinations;

  /// Text before full list of combinations
  ///
  /// In en, this message translates to:
  /// **'All possible combinations:'**
  String get allCombinations;

  /// Option to continue without using a hint
  ///
  /// In en, this message translates to:
  /// **'Continue without hints'**
  String get continueWithoutHints;

  /// Label for level task
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get task_level;

  /// Notification about new item discovery
  ///
  /// In en, this message translates to:
  /// **'New item'**
  String get new_item;

  /// Time until next free hint becomes available
  ///
  /// In en, this message translates to:
  /// **'Until the next free tip'**
  String get hint_until_next_free;

  /// Suggestion to purchase a hint
  ///
  /// In en, this message translates to:
  /// **'or buy a hint'**
  String get or_buy_a_hint;

  /// Title for statistics screen
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// Element: Time
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Element: Water
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// Element: Cloud
  ///
  /// In en, this message translates to:
  /// **'Cloud'**
  String get cloud;

  /// Element: DNA
  ///
  /// In en, this message translates to:
  /// **'DNA'**
  String get dna;

  /// Element: Man
  ///
  /// In en, this message translates to:
  /// **'Man'**
  String get man;

  /// Element: Morning
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// Element: Mushroom
  ///
  /// In en, this message translates to:
  /// **'Mushroom'**
  String get mushroom;

  /// Element: Sky
  ///
  /// In en, this message translates to:
  /// **'Sky'**
  String get sky;

  /// Element: Sugar
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get sugar;

  /// Element: Wind
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get wind;

  /// Element: Explosion
  ///
  /// In en, this message translates to:
  /// **'Explosion'**
  String get explosion;

  /// Element: Radiation
  ///
  /// In en, this message translates to:
  /// **'Radiation'**
  String get radiation;

  /// Element: Grape
  ///
  /// In en, this message translates to:
  /// **'Grape'**
  String get grape;

  /// Element: Holiday
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get holiday;

  /// Element: Knight
  ///
  /// In en, this message translates to:
  /// **'Knight'**
  String get knight;

  /// Element: Plane
  ///
  /// In en, this message translates to:
  /// **'Plane'**
  String get plane;

  /// Element: Phone
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Element: Car
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// Element: Barista
  ///
  /// In en, this message translates to:
  /// **'Barista'**
  String get barista;

  /// Element: Old phone
  ///
  /// In en, this message translates to:
  /// **'Old phone'**
  String get phone_old;

  /// Element: Wooden object
  ///
  /// In en, this message translates to:
  /// **'Wooden object'**
  String get wooden;

  /// Element: Plankton
  ///
  /// In en, this message translates to:
  /// **'Plankton'**
  String get plankton;

  /// Element: Spider
  ///
  /// In en, this message translates to:
  /// **'Spider'**
  String get spider;

  /// Element: Glacier
  ///
  /// In en, this message translates to:
  /// **'Glacier'**
  String get glacier;

  /// Element: Bacteria
  ///
  /// In en, this message translates to:
  /// **'Bacteria'**
  String get bacteria;

  /// Element: Fish
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get fish;

  /// Element: Tool
  ///
  /// In en, this message translates to:
  /// **'Tool'**
  String get tool;

  /// Element: Bicycle
  ///
  /// In en, this message translates to:
  /// **'Bicycle'**
  String get bicycle;

  /// Element: Wheel
  ///
  /// In en, this message translates to:
  /// **'Wheel'**
  String get wheel;

  /// Element: Crowd of people
  ///
  /// In en, this message translates to:
  /// **'Crowd of people'**
  String get crowd_of_people;

  /// Element: Alcohol
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get alcohol;

  /// Element: Stone
  ///
  /// In en, this message translates to:
  /// **'Stone'**
  String get stone;

  /// Element: Lizard
  ///
  /// In en, this message translates to:
  /// **'Lizard'**
  String get lizard;

  /// Element: Tree
  ///
  /// In en, this message translates to:
  /// **'Tree'**
  String get tree;

  /// Element: Swamp
  ///
  /// In en, this message translates to:
  /// **'Swamp'**
  String get swamp;

  /// Element: Flour
  ///
  /// In en, this message translates to:
  /// **'Flour'**
  String get flour;

  /// Element: Bread
  ///
  /// In en, this message translates to:
  /// **'Bread'**
  String get bread;

  /// Element: Banana
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get banana;

  /// Element: Factory
  ///
  /// In en, this message translates to:
  /// **'Factory'**
  String get factory;

  /// Element: Volcano
  ///
  /// In en, this message translates to:
  /// **'Volcano'**
  String get volcano;

  /// Element: City
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// Element: Hungover Saturday morning
  ///
  /// In en, this message translates to:
  /// **'Hungover morning'**
  String get hungover_saturday_morning;

  /// Element: Cake
  ///
  /// In en, this message translates to:
  /// **'Cake'**
  String get cake;

  /// Element: Sailing ship
  ///
  /// In en, this message translates to:
  /// **'Sailing ship'**
  String get sailing_ship;

  /// Element: Sand mountain or dune
  ///
  /// In en, this message translates to:
  /// **'Sand mountain/dune'**
  String get sand_mountain;

  /// Element: Stone mountain
  ///
  /// In en, this message translates to:
  /// **'Stone mountain'**
  String get stone_mountain;

  /// Element: Metropolis
  ///
  /// In en, this message translates to:
  /// **'Metropolis'**
  String get metropolis;

  /// Element: Village
  ///
  /// In en, this message translates to:
  /// **'Village'**
  String get village;

  /// Element: Snowman
  ///
  /// In en, this message translates to:
  /// **'Snowman'**
  String get snowman;

  /// Element: Love
  ///
  /// In en, this message translates to:
  /// **'Love'**
  String get love;

  /// Element: Sea
  ///
  /// In en, this message translates to:
  /// **'Sea'**
  String get sea;

  /// Element: Bacterium
  ///
  /// In en, this message translates to:
  /// **'Bacterium'**
  String get bacterium;

  /// Element: Monkey
  ///
  /// In en, this message translates to:
  /// **'Monkey'**
  String get monkey;

  /// Element: Money
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get money;

  /// Element: Santa Claus
  ///
  /// In en, this message translates to:
  /// **'Santa Claus'**
  String get santa_claus;

  /// Element: New Year tree
  ///
  /// In en, this message translates to:
  /// **'New Year tree'**
  String get new_year_tree;

  /// Element: Penguin
  ///
  /// In en, this message translates to:
  /// **'Penguin'**
  String get penguin;

  /// Element: Witch
  ///
  /// In en, this message translates to:
  /// **'Witch'**
  String get witch;

  /// Element: Big crowd of people
  ///
  /// In en, this message translates to:
  /// **'Crowd of people'**
  String get big_crowd_of_people;

  /// Element: Noisy Friday party
  ///
  /// In en, this message translates to:
  /// **'Friday party'**
  String get noisy_friday_party;

  /// Element: Dragon
  ///
  /// In en, this message translates to:
  /// **'Dragon'**
  String get dragon;

  /// Element: Book
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// Element: Cow
  ///
  /// In en, this message translates to:
  /// **'Cow'**
  String get cow;

  /// Element: Cocktail
  ///
  /// In en, this message translates to:
  /// **'Cocktail'**
  String get cocktail;

  /// Element: Cupid
  ///
  /// In en, this message translates to:
  /// **'Cupid'**
  String get cupid;

  /// Character from Game of Thrones
  ///
  /// In en, this message translates to:
  /// **'Arya Stark'**
  String get arya_stark_from_game_of_thrones;

  /// Character from Game of Thrones
  ///
  /// In en, this message translates to:
  /// **'Jon Snow'**
  String get jon_snow_from_game_of_thrones;

  /// Element: Frog
  ///
  /// In en, this message translates to:
  /// **'Frog'**
  String get frog;

  /// Element: King of the hill
  ///
  /// In en, this message translates to:
  /// **'King of the hill'**
  String get king_of_the_hill;

  /// Element: Monument
  ///
  /// In en, this message translates to:
  /// **'Monument'**
  String get monument;

  /// Element: Sommelier
  ///
  /// In en, this message translates to:
  /// **'Sommelier'**
  String get sommelier;

  /// Element: Snow
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get snow;

  /// Element: Electricity
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get electricity;

  /// Element: Iron
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get iron;

  /// Element: Acid
  ///
  /// In en, this message translates to:
  /// **'Acid'**
  String get acid;

  /// Element: Milk
  ///
  /// In en, this message translates to:
  /// **'Milk'**
  String get milk;

  /// Element: Rocket
  ///
  /// In en, this message translates to:
  /// **'Rocket'**
  String get rocket;

  /// Element: Intelligence
  ///
  /// In en, this message translates to:
  /// **'Intelligence'**
  String get intelligence;

  /// Element: Wood
  ///
  /// In en, this message translates to:
  /// **'Wood'**
  String get wood;

  /// Element: Wine
  ///
  /// In en, this message translates to:
  /// **'Wine'**
  String get wine;

  /// Element: Sun
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// Element: Spark
  ///
  /// In en, this message translates to:
  /// **'Spark'**
  String get spark;

  /// Element: Robot
  ///
  /// In en, this message translates to:
  /// **'Robot'**
  String get robot;

  /// Element: Rainbow
  ///
  /// In en, this message translates to:
  /// **'Rainbow'**
  String get rainbow;

  /// Element: Metal
  ///
  /// In en, this message translates to:
  /// **'Metal'**
  String get metal;

  /// Element: Mammal
  ///
  /// In en, this message translates to:
  /// **'Mammal'**
  String get mammal;

  /// Element: Light
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// Element: Life
  ///
  /// In en, this message translates to:
  /// **'Life'**
  String get life;

  /// Element: Fire
  ///
  /// In en, this message translates to:
  /// **'Fire'**
  String get fire;

  /// Element: Earth
  ///
  /// In en, this message translates to:
  /// **'Earth'**
  String get earth;

  /// Element: Dough
  ///
  /// In en, this message translates to:
  /// **'Dough'**
  String get dough;

  /// Element: Dolphin
  ///
  /// In en, this message translates to:
  /// **'Dolphin'**
  String get dolphin;

  /// Element: Cat
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get cat;

  /// Element: Dog
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get dog;

  /// Element: Artificial intelligence
  ///
  /// In en, this message translates to:
  /// **'Artificial intelligence'**
  String get artificial_intelligence;

  /// Element: Train
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get train;

  /// Element: Mountain
  ///
  /// In en, this message translates to:
  /// **'Mountain'**
  String get mountain;

  /// Element: Family
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// Element: Lion
  ///
  /// In en, this message translates to:
  /// **'Lion'**
  String get leon;

  /// Element: Ballerina cappuccino
  ///
  /// In en, this message translates to:
  /// **'Ballerina cappuccino'**
  String get ballerina_cappuccino;

  /// Element: Bombardier crocodile
  ///
  /// In en, this message translates to:
  /// **'Bombardier crocodile'**
  String get bombardiro_crocodilo;

  /// Element: Lirili larila
  ///
  /// In en, this message translates to:
  /// **'Lirili larila'**
  String get lirili_larila;

  /// Element: Tralalero tralala
  ///
  /// In en, this message translates to:
  /// **'Tralalero tralala'**
  String get tralalero_tralala;

  /// Element: Shark and Nike
  ///
  /// In en, this message translates to:
  /// **'Shark and Nike'**
  String get shark_and_nike;

  /// Element: Hogwarts School
  ///
  /// In en, this message translates to:
  /// **'Hogwarts School'**
  String get hogwarts_school;

  /// Element: March 8
  ///
  /// In en, this message translates to:
  /// **'March 8'**
  String get march_8;

  /// Element: New Year's star
  ///
  /// In en, this message translates to:
  /// **'New Year\'s star'**
  String get new_years_star;

  /// Element: Thor man
  ///
  /// In en, this message translates to:
  /// **'Thor man'**
  String get thor_man;

  /// Element: Ancient bird
  ///
  /// In en, this message translates to:
  /// **'Ancient bird'**
  String get ancient_bird;

  /// Element: Ancient marine mammal
  ///
  /// In en, this message translates to:
  /// **'Ancient mammal'**
  String get ancient_marine_mammal;

  /// Element: Ancient sea fish
  ///
  /// In en, this message translates to:
  /// **'Ancient sea fish'**
  String get ancient_sea_fish;

  /// Element: Ancient man with stone
  ///
  /// In en, this message translates to:
  /// **'Ancient man'**
  String get ancient_stone_age_man_with_stone;

  /// Element: Archangel with wings and sword
  ///
  /// In en, this message translates to:
  /// **'Archangel'**
  String get archangel_with_wings_and_a_sword;

  /// Element: Bear on bicycle in circus
  ///
  /// In en, this message translates to:
  /// **'Bear on bicycle'**
  String get bear_on_bicycle_in_circus;

  /// Element: Bee
  ///
  /// In en, this message translates to:
  /// **'Bee'**
  String get bee;

  /// Element: Bone dragon
  ///
  /// In en, this message translates to:
  /// **'Bone dragon'**
  String get bone_dragon;

  /// Element: Burger
  ///
  /// In en, this message translates to:
  /// **'Burger'**
  String get burger;

  /// Element: Candle
  ///
  /// In en, this message translates to:
  /// **'Candle'**
  String get candle;

  /// Element: Church
  ///
  /// In en, this message translates to:
  /// **'Church'**
  String get church;

  /// Element: Cipollino
  ///
  /// In en, this message translates to:
  /// **'Cipollino'**
  String get cipollino;

  /// Element: Circus
  ///
  /// In en, this message translates to:
  /// **'Circus'**
  String get circus;

  /// Element: Circus clown
  ///
  /// In en, this message translates to:
  /// **'Circus clown'**
  String get circus_clown;

  /// Element: Corsair pirate at sea
  ///
  /// In en, this message translates to:
  /// **'Corsair pirate sea'**
  String get corsair_pirate_sea;

  /// Character from Game of Thrones
  ///
  /// In en, this message translates to:
  /// **'Daenerys Targaryen'**
  String get daenerys_targaryen;

  /// Element: Fire elemental
  ///
  /// In en, this message translates to:
  /// **'Fire elemental'**
  String get fire_elemental;

  /// Element: Firefighter
  ///
  /// In en, this message translates to:
  /// **'Firefighter'**
  String get firefighter;

  /// Element: Fireworks
  ///
  /// In en, this message translates to:
  /// **'Fireworks'**
  String get fireworks;

  /// Element: Fruits
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// Character from The Lord of the Rings
  ///
  /// In en, this message translates to:
  /// **'Gandalf'**
  String get gandalf_from_the_lord_of_the_rings;

  /// Element: Girl in love
  ///
  /// In en, this message translates to:
  /// **'Girl in love'**
  String get girl_in_love;

  /// Element: Guy in love
  ///
  /// In en, this message translates to:
  /// **'Guy in love'**
  String get guy_in_love;

  /// Character from The Lord of the Rings
  ///
  /// In en, this message translates to:
  /// **'Hobbit'**
  String get hobbit_from_lord_of_the_rings;

  /// Element: Holiday people
  ///
  /// In en, this message translates to:
  /// **'Holiday people'**
  String get holiday_people;

  /// Element: Honeycombs
  ///
  /// In en, this message translates to:
  /// **'Honeycombs'**
  String get honeycombs;

  /// Element: House in the village
  ///
  /// In en, this message translates to:
  /// **'House in the village'**
  String get house_in_the_village;

  /// Element: Institute / Education
  ///
  /// In en, this message translates to:
  /// **'Institute education'**
  String get institute_education;

  /// Element: Lamb
  ///
  /// In en, this message translates to:
  /// **'Lamb'**
  String get lamb;

  /// Element: Magic broom
  ///
  /// In en, this message translates to:
  /// **'Magic broom'**
  String get magic_broom;

  /// Element: Magician or illusionist
  ///
  /// In en, this message translates to:
  /// **'Magician illusionist'**
  String get magician_illusionist;

  /// Element: Male scientist
  ///
  /// In en, this message translates to:
  /// **'Male scientist'**
  String get male_scientist;

  /// Element: Masks from the theater
  ///
  /// In en, this message translates to:
  /// **'Masks from the theater'**
  String get masks_from_the_theater;

  /// Element: Mermaid
  ///
  /// In en, this message translates to:
  /// **'Mermaid'**
  String get mermaid;

  /// Element: Microbes
  ///
  /// In en, this message translates to:
  /// **'Microbes'**
  String get microbes;

  /// Element: Modern sea deck of ship
  ///
  /// In en, this message translates to:
  /// **'Modern deck of ship'**
  String get modern_sea_deck_of_ship;

  /// Element: Modern tool
  ///
  /// In en, this message translates to:
  /// **'Modern tool'**
  String get modern_tool;

  /// Element: Multicolored balloons
  ///
  /// In en, this message translates to:
  /// **'Multicolored balloons'**
  String get multicolored_balloons;

  /// Element: Old sea deck of ship
  ///
  /// In en, this message translates to:
  /// **'Old sea deck'**
  String get old_sea_deck_of_ship;

  /// Element: People
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get people;

  /// Element: Pirate ship
  ///
  /// In en, this message translates to:
  /// **'Pirate ship'**
  String get pirate_ship;

  /// Element: Folded plank stack
  ///
  /// In en, this message translates to:
  /// **'Plank stack folded'**
  String get plank_stack_folded;

  /// Element: Prometheus who gave fire to humans
  ///
  /// In en, this message translates to:
  /// **'Prometheus'**
  String get prometheus_who_gave_fire;

  /// Element: Rooster
  ///
  /// In en, this message translates to:
  /// **'Rooster'**
  String get rooster;

  /// Element: Rope
  ///
  /// In en, this message translates to:
  /// **'Rope'**
  String get rope;

  /// Element: Sea sailing ship
  ///
  /// In en, this message translates to:
  /// **'Sea sailing ship'**
  String get sea_sailing_ship;

  /// Element: Spider-Man
  ///
  /// In en, this message translates to:
  /// **'Spider-Man'**
  String get spider_man;

  /// Element: Spider web
  ///
  /// In en, this message translates to:
  /// **'Spider web'**
  String get spider_web;

  /// Element: Stone elemental
  ///
  /// In en, this message translates to:
  /// **'Stone elemental'**
  String get stone_elemental;

  /// Element: Strong man
  ///
  /// In en, this message translates to:
  /// **'Strong man'**
  String get strong_man;

  /// Element: Student guy
  ///
  /// In en, this message translates to:
  /// **'Student guy'**
  String get student_guy;

  /// Element: Students
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// Element: Sword
  ///
  /// In en, this message translates to:
  /// **'Sword'**
  String get sword;

  /// Element: The plane is flying
  ///
  /// In en, this message translates to:
  /// **'The plane'**
  String get the_plane_is_flying;

  /// Element: The Witcher from the game
  ///
  /// In en, this message translates to:
  /// **'The Witcher'**
  String get the_witcher_man_from_the_game;

  /// Element: Theater of masks play
  ///
  /// In en, this message translates to:
  /// **'Theater of masks'**
  String get theater_of_masks_play;

  /// Element: Thor's hammer
  ///
  /// In en, this message translates to:
  /// **'Thor\'s hammer'**
  String get thor_s_hammer;

  /// Element: Time machine
  ///
  /// In en, this message translates to:
  /// **'Time machine'**
  String get time_machine;

  /// Element: Traveler
  ///
  /// In en, this message translates to:
  /// **'Traveler'**
  String get traveler;

  /// Element: Two students
  ///
  /// In en, this message translates to:
  /// **'Two students'**
  String get two_students;

  /// Element: Underground metro
  ///
  /// In en, this message translates to:
  /// **'Underground metro'**
  String get underground_metro;

  /// Element: Whale
  ///
  /// In en, this message translates to:
  /// **'Whale'**
  String get whale;

  /// Element: Young girl
  ///
  /// In en, this message translates to:
  /// **'Young girl'**
  String get young_girl;

  /// Element: Young guy
  ///
  /// In en, this message translates to:
  /// **'Young guy'**
  String get young_guy;

  /// Element: Frost
  ///
  /// In en, this message translates to:
  /// **'Frost'**
  String get frost;

  /// Element: Phoenix
  ///
  /// In en, this message translates to:
  /// **'Phoenix'**
  String get phoenix;

  /// Element: Sand
  ///
  /// In en, this message translates to:
  /// **'Sand'**
  String get sand;

  /// Element: Thunderstorm with lightning
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get thunderstorm_with_lightning;

  /// Element: Tornado
  ///
  /// In en, this message translates to:
  /// **'Tornado'**
  String get tornado;

  /// Element: Unicorn
  ///
  /// In en, this message translates to:
  /// **'Unicorn'**
  String get unicorn;

  /// Element: Vampire
  ///
  /// In en, this message translates to:
  /// **'Vampire'**
  String get vampire;

  /// Element: Zombie
  ///
  /// In en, this message translates to:
  /// **'Zombie'**
  String get zombie;

  /// Element: Geyser
  ///
  /// In en, this message translates to:
  /// **'Geyser'**
  String get geyser;

  /// Element: Antibiotic
  ///
  /// In en, this message translates to:
  /// **'Antibiotic'**
  String get antibiotic;

  /// Element: Electric battery
  ///
  /// In en, this message translates to:
  /// **'Electric battery'**
  String get electric_battery;

  /// Element: Molotov cocktail
  ///
  /// In en, this message translates to:
  /// **'Molotov cocktail'**
  String get molotov_cocktail;

  /// Element: Puss in Boots
  ///
  /// In en, this message translates to:
  /// **'Puss in Boots'**
  String get puss_in_boots;

  /// Element: Schrödinger's cat
  ///
  /// In en, this message translates to:
  /// **'Schrödinger\'s cat'**
  String get schrodingers_cat;

  /// Element: Beehive
  ///
  /// In en, this message translates to:
  /// **'Beehive'**
  String get beehive;

  /// Element: Bitcoin
  ///
  /// In en, this message translates to:
  /// **'Bitcoin'**
  String get bitcoin;

  /// Element: Cheese
  ///
  /// In en, this message translates to:
  /// **'Cheese'**
  String get cheese;

  /// Element: Chocolate
  ///
  /// In en, this message translates to:
  /// **'Chocolate'**
  String get chocolate;

  /// Element: Pandemic
  ///
  /// In en, this message translates to:
  /// **'Pandemic'**
  String get pandemic;

  /// Element: Shrek
  ///
  /// In en, this message translates to:
  /// **'Shrek'**
  String get shrek;

  /// Title of the game
  ///
  /// In en, this message translates to:
  /// **'Darwin Evolution'**
  String get gameTitle;

  /// Title for hint banner
  ///
  /// In en, this message translates to:
  /// **'Hint'**
  String get hintTitle;

  /// Instruction to create the sun
  ///
  /// In en, this message translates to:
  /// **'Create the sun'**
  String get create_sun;

  /// Ancient extinct amphibian
  ///
  /// In en, this message translates to:
  /// **'Ichthyostegidae'**
  String get ichthyostegidae;

  /// Element: Crossopterygian fish
  ///
  /// In en, this message translates to:
  /// **'Crossopterygian fish'**
  String get crossopterygian_fish;

  /// Element: Flower
  ///
  /// In en, this message translates to:
  /// **'Flower'**
  String get flower;

  /// Element: Reptile
  ///
  /// In en, this message translates to:
  /// **'Reptile'**
  String get reptile;

  /// Element: Death Star from Star Wars
  ///
  /// In en, this message translates to:
  /// **'Death star'**
  String get death_star;

  /// Element: Jedi from Star Wars
  ///
  /// In en, this message translates to:
  /// **'Jedi'**
  String get jedi_from_stars_wars;

  /// Element: Yoda from Star Wars
  ///
  /// In en, this message translates to:
  /// **'Yoda'**
  String get yoda_is_a_wise_jedi;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
