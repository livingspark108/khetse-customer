import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// Add New Address
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get tle_add_new_address;

  /// Select Phone Number
  ///
  /// In en, this message translates to:
  /// **'Select Phone Number'**
  String get txt_select_phonenumber;

  /// Address(House, Building, Area etc)
  ///
  /// In en, this message translates to:
  /// **'Address(House, Building, Area etc)'**
  String get hnt_address;

  /// Nearest Landmark
  ///
  /// In en, this message translates to:
  /// **'Nearest Landmark'**
  String get hnt_near_landmark;

  /// Please try again after sometime.
  ///
  /// In en, this message translates to:
  /// **'Please try again after sometime.'**
  String get txt_please_try_again_after_sometime;

  /// Pincode
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get hnt_pincode;

  /// State
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get hnt_state;

  /// Save Address as
  ///
  /// In en, this message translates to:
  /// **'Save Address as'**
  String get lbl_save_address;

  /// Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get txt_home;

  /// Office
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get txt_office;

  /// Others
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get txt_others;

  /// Save Address
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get btn_save_address;

  /// Payment Method
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get lbl_payment_method;

  /// Transaction Successfull
  ///
  /// In en, this message translates to:
  /// **'Transaction Successfull'**
  String get lbl_transaction_successful;

  /// Enter your card number
  ///
  /// In en, this message translates to:
  /// **'Enter your card number'**
  String get txt_enter_your_card_number;

  /// Card Details
  ///
  /// In en, this message translates to:
  /// **'Card Details'**
  String get lbl_card_Details;

  /// Card Type
  ///
  /// In en, this message translates to:
  /// **'Card Type'**
  String get lbl_card_type;

  /// card has expired
  ///
  /// In en, this message translates to:
  /// **'card has expired'**
  String get txt_card_has_expired;

  /// Card Number
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get lbl_card_number;

  /// Enter expiry date
  ///
  /// In en, this message translates to:
  /// **'Enter expiry date'**
  String get txt_enter_expiry_date;

  /// Pay
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get lbl_pay;

  /// Card Holder Name
  ///
  /// In en, this message translates to:
  /// **'Card Holder Name'**
  String get txt_card_holder_name;

  /// Please try again
  ///
  /// In en, this message translates to:
  /// **'Please try again'**
  String get txt_please_try_again;

  /// cvv is invalid
  ///
  /// In en, this message translates to:
  /// **'cvv is invalid'**
  String get txt_cvv_is_invalid;

  /// Enter valid card number
  ///
  /// In en, this message translates to:
  /// **'Enter valid card number'**
  String get txt_enter_valid_card_number;

  /// Transaction Failed.
  ///
  /// In en, this message translates to:
  /// **'Transaction Failed.'**
  String get lbl_transaction_failed;

  /// Try Again
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get lbl_try_again;

  /// Enter your expiry date
  ///
  /// In en, this message translates to:
  /// **'Enter your expiry date'**
  String get txt_enter_your_expiry_date;

  /// Enter your card name
  ///
  /// In en, this message translates to:
  /// **'Enter your card name'**
  String get txt_enter_your_card_name;

  /// Pay On Delivery
  ///
  /// In en, this message translates to:
  /// **'Pay On Delivery'**
  String get txt_pay_on_delivery;

  /// Cash
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get lbl_cash;

  /// Pay with cash.
  ///
  /// In en, this message translates to:
  /// **'Pay with cash.'**
  String get lbl_pay_cash;

  /// Change Password
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get lbl_reset_password;

  /// Trending Products
  ///
  /// In en, this message translates to:
  /// **'Trending Products'**
  String get lbl_trending_products;

  /// Reward points are successfully added in your wallet. Enjoy Shopping.
  ///
  /// In en, this message translates to:
  /// **'Reward points are successfully added in your wallet. Enjoy Shopping.'**
  String get txt_reward_to_wallet;

  /// Something went wrong
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get txt_something_went_wrong;

  /// RazorPay
  ///
  /// In en, this message translates to:
  /// **'RazorPay'**
  String get lbl_rezorpay;

  /// SMS
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get lbl_sms;

  /// In App
  ///
  /// In en, this message translates to:
  /// **'In App'**
  String get lbl_inapp;

  /// Stripe
  ///
  /// In en, this message translates to:
  /// **'Stripe'**
  String get lbl_stripe;

  /// Paystack
  ///
  /// In en, this message translates to:
  /// **'Paystack'**
  String get lbl_paystack;

  /// Card Number
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get hnt_card_number;

  /// Name on the Card
  ///
  /// In en, this message translates to:
  /// **'Name on the Card'**
  String get hnt_name_card;

  /// Valid Thru (MM/YY)
  ///
  /// In en, this message translates to:
  /// **'Valid Thru (MM/YY)'**
  String get hnt_valid_through;

  /// CVV
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get hnt_cvv;

  /// Cash on Delivery
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get lbl_COD;

  /// PhonePe / Google Pay / UPI
  ///
  /// In en, this message translates to:
  /// **'PhonePe / Google Pay / UPI'**
  String get lbl_upi_option;

  /// PayTM / Wallets
  ///
  /// In en, this message translates to:
  /// **'PayTM / Wallets'**
  String get lbl_wallet_option;

  /// Net Banking
  ///
  /// In en, this message translates to:
  /// **'Net Banking'**
  String get lbl_netbanking;

  /// My Address
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get tle_my_address;

  /// All Categories
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get tle_all_category;

  /// From
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get txt_from;

  /// Cart
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get txt_cart;

  /// Address
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get txt_address;

  /// Time
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get txt_time;

  /// Tax (inclusive)
  ///
  /// In en, this message translates to:
  /// **'Tax (inclusive)'**
  String get txt_tax;

  /// Instant Delivery Available
  ///
  /// In en, this message translates to:
  /// **'Instant Delivery Available'**
  String get btn_instant_delivery;

  /// Payment
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get txt_payment;

  /// Shopping Cart
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get txt_shopping_cart;

  /// Proceed to Checkout
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get btn_proceed_to_checkout;

  /// Make Payment
  ///
  /// In en, this message translates to:
  /// **'Make Payment'**
  String get btn_make_payment;

  /// Please select city
  ///
  /// In en, this message translates to:
  /// **'Please select city'**
  String get txt_select_city;

  /// User Profile
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get txt_user_profile;

  /// Select city
  ///
  /// In en, this message translates to:
  /// **'Select city'**
  String get hnt_select_city;

  /// Search cities here...
  ///
  /// In en, this message translates to:
  /// **'Search cities here...'**
  String get hnt_search_city;

  /// No city found.
  ///
  /// In en, this message translates to:
  /// **'No city found.'**
  String get txt_no_city;

  /// Please enter amount
  ///
  /// In en, this message translates to:
  /// **'Please enter amount'**
  String get txt_enter_amount;

  /// No society found.
  ///
  /// In en, this message translates to:
  /// **'No society found.'**
  String get txt_no_society;

  /// Select society
  ///
  /// In en, this message translates to:
  /// **'Select society'**
  String get hnt_select_society;

  /// Make Product Request
  ///
  /// In en, this message translates to:
  /// **'Make Product Request'**
  String get lbl_make_product_request;

  /// Upload Image
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get lbl_upload_image;

  /// Choose from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get txt_upload_image_desc;

  /// Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get btn_close;

  /// Confirm Location
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get btn_confirm_location;

  /// Select Address
  ///
  /// In en, this message translates to:
  /// **'Select Address'**
  String get lbl_select_address;

  /// Profile updated succesfully
  ///
  /// In en, this message translates to:
  /// **'Profile updated succesfully'**
  String get txt_profile_updated_successfully;

  /// Please enable location permission to use this App
  ///
  /// In en, this message translates to:
  /// **'Please enable location permission to use this App'**
  String get txt_please_enablet_location_permission_to_use_app;

  /// Please select society
  ///
  /// In en, this message translates to:
  /// **'Please select society'**
  String get txt_select_society;

  /// Search society here...
  ///
  /// In en, this message translates to:
  /// **'Search society here...'**
  String get htn_search_society;

  /// Off
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get txt_off;

  /// Ratings
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get txt_ratings;

  /// Please give rating
  ///
  /// In en, this message translates to:
  /// **'Please give rating'**
  String get txt_please_give_ratings;

  /// Please enter description.
  ///
  /// In en, this message translates to:
  /// **'Please enter description.'**
  String get txt_enter_description;

  /// Price Details
  ///
  /// In en, this message translates to:
  /// **'Price Details'**
  String get lbl_price_details;

  /// Go to Cart
  ///
  /// In en, this message translates to:
  /// **'Go to Cart'**
  String get btn_go_to_cart;

  /// Cancel Reason
  ///
  /// In en, this message translates to:
  /// **'Cancel Reason'**
  String get lbl_cancel_reason;

  /// Shipping to
  ///
  /// In en, this message translates to:
  /// **'Shipping to'**
  String get lbl_shipping_to;

  /// Cancellation Reason
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get lbl_cancellation_reason;

  /// Total MRP
  ///
  /// In en, this message translates to:
  /// **'Total MRP'**
  String get txt_total_price;

  /// Paid by Wallet
  ///
  /// In en, this message translates to:
  /// **'Paid by Wallet'**
  String get lbl_paid_by_wallet;

  /// Discount on MRP
  ///
  /// In en, this message translates to:
  /// **'Discount on MRP'**
  String get txt_discount_price;

  /// Apply discount code
  ///
  /// In en, this message translates to:
  /// **'Apply discount code'**
  String get txt_apply_coupon_code;

  /// Coupon Discount
  ///
  /// In en, this message translates to:
  /// **'Coupon Discount'**
  String get txt_coupon_discount;

  /// Apply Coupon
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get txt_apply_coupon;

  /// Apply
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get btn_apply;

  /// No Store !
  ///
  /// In en, this message translates to:
  /// **'No Store !'**
  String get lbl_no_store;

  /// No stores available at your location.
  ///
  /// In en, this message translates to:
  /// **'No stores available at your location.'**
  String get lbl_no_store_at_loc_msg;

  /// Continue with default location
  ///
  /// In en, this message translates to:
  /// **'Continue with default location'**
  String get btn_continue_with_default_location;

  /// Search Another Location
  ///
  /// In en, this message translates to:
  /// **'Search Another Location'**
  String get btn_search_another_location;

  /// Search Location
  ///
  /// In en, this message translates to:
  /// **'Search Location'**
  String get hnt_search_location;

  /// Delivery Charges
  ///
  /// In en, this message translates to:
  /// **'Delivery Charges'**
  String get txt_delivery_charges;

  /// Total Amount
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get lbl_total_amount;

  /// Add new Address
  ///
  /// In en, this message translates to:
  /// **'Add new Address'**
  String get btn_add_new_address;

  /// Select Date
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get lbl_select_date;

  /// Date
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get lbl_date;

  /// Select Time Slot
  ///
  /// In en, this message translates to:
  /// **'Select Time Slot'**
  String get lbl_select_time_slot;

  /// Request instant Delivery (Members only)
  ///
  /// In en, this message translates to:
  /// **'Request instant Delivery (Members only)'**
  String get btn_req_instant_delivery;

  /// Offers
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get lbl_offer;

  /// show offers
  ///
  /// In en, this message translates to:
  /// **'show offers'**
  String get txt_show_offers;

  /// Forgot Password
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get lbl_forgot_password;

  /// Skip
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get btn_skip_now;

  /// Date of Delivery
  ///
  /// In en, this message translates to:
  /// **'Date of Delivery'**
  String get txt_date_of_delivery;

  /// Languages
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get tle_languages;

  /// Select Language
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get lbl_select_language;

  /// Contact Us
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get tle_contact_us;

  /// Let us know your valuable feedback
  ///
  /// In en, this message translates to:
  /// **'Let us know your valuable feedback'**
  String get lbl_contact_desc;

  /// Full Name
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get lbl_name;

  /// Phone Number
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get lbl_phone_number;

  /// Email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get lbl_email;

  /// Password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get lbl_password;

  /// Confirm Password
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get lbl_confirm_password;

  /// Exit app
  ///
  /// In en, this message translates to:
  /// **'Exit app'**
  String get lbl_exit_app;

  /// Exit
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get btn_exit;

  /// Please enter 6 digit OTP
  ///
  /// In en, this message translates to:
  /// **'Please enter 6 digit OTP'**
  String get txt_6_digit_msg;

  /// About Us
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get tle_about_us;

  /// Terms Of Service
  ///
  /// In en, this message translates to:
  /// **'Terms Of Service'**
  String get tle_term_of_service;

  /// Cancel Order
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get tle_cancel_order;

  /// Nothing is yet to see here
  ///
  /// In en, this message translates to:
  /// **'Nothing is yet to see here'**
  String get txt_nothing_to_show;

  /// Edit Address
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get tle_edit_address;

  /// Are you sure you want to logout from the app?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout from the app?'**
  String get txt_logout_app_msg;

  /// Are you sure you want to exit from the app?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit from the app?'**
  String get txt_exit_app_msg;

  /// Are you sure you want to cancel this order?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order?'**
  String get txt_cancel_order_message;

  /// Add All Items To Cart
  ///
  /// In en, this message translates to:
  /// **'Add All Items To Cart'**
  String get txt_add_all_to_cart;

  /// Yes
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get btn_yes;

  /// No
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get btn_no;

  /// Confirm
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get lbl_confirm;

  /// Referral Code
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get lbl_referal_code;

  /// City
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get lbl_city;

  /// Society
  ///
  /// In en, this message translates to:
  /// **'Society'**
  String get lbl_society;

  /// Your Query
  ///
  /// In en, this message translates to:
  /// **'Your Query'**
  String get lbl_your_feedback;

  /// Enter your message
  ///
  /// In en, this message translates to:
  /// **'Enter your message'**
  String get hnt_enter_msg;

  /// Submit
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get btn_submit;

  /// Delivery Location
  ///
  /// In en, this message translates to:
  /// **'Delivery Location'**
  String get tle_delivery_location;

  /// Search new location
  ///
  /// In en, this message translates to:
  /// **'Search new location'**
  String get hnt_search_new_location;

  /// Use Current Location
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get lbl_use_current_location;

  /// Use Saved Locations
  ///
  /// In en, this message translates to:
  /// **'Use Saved Locations'**
  String get lbl_use_saved_location;

  /// Saved
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get lbl_saved;

  /// Recent Searched Locations
  ///
  /// In en, this message translates to:
  /// **'Recent Searched Locations'**
  String get lbl_recent_searched_location;

  /// Filter Options
  ///
  /// In en, this message translates to:
  /// **'Filter Options'**
  String get tle_filter_option;

  /// Sort By Name
  ///
  /// In en, this message translates to:
  /// **'Sort By Name'**
  String get lbl_sort_by_name;

  /// A to Z
  ///
  /// In en, this message translates to:
  /// **'A to Z'**
  String get txt_A_Z;

  /// Z to A
  ///
  /// In en, this message translates to:
  /// **'Z to A'**
  String get txt_Z_A;

  /// Sort By Rating
  ///
  /// In en, this message translates to:
  /// **'Sort By Rating'**
  String get lbl_sort_by_rating;

  /// 1 - 2 Stars
  ///
  /// In en, this message translates to:
  /// **'1 - 2 Stars'**
  String get txt_1_2_stars;

  /// 2 - 3 Stars
  ///
  /// In en, this message translates to:
  /// **'2 - 3 Stars'**
  String get txt_2_3_stars;

  /// 3 - 4 Stars
  ///
  /// In en, this message translates to:
  /// **'3 - 4 Stars'**
  String get txt_3_4_stars;

  /// 4 - 5 Stars
  ///
  /// In en, this message translates to:
  /// **'4 - 5 Stars'**
  String get txt_4_5_stars;

  /// Sort By Price
  ///
  /// In en, this message translates to:
  /// **'Sort By Price'**
  String get lbl_sort_by_price;

  /// Low to high
  ///
  /// In en, this message translates to:
  /// **'Low to high'**
  String get txt_low_to_high;

  /// High to low
  ///
  /// In en, this message translates to:
  /// **'High to low'**
  String get txt_high_to_low;

  /// Sort By Discounts
  ///
  /// In en, this message translates to:
  /// **'Sort By Discounts'**
  String get lbl_sort_by_discount;

  /// Sort By
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get lbl_sort_by;

  /// Latest
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get lbl_latest;

  /// Old
  ///
  /// In en, this message translates to:
  /// **'Old'**
  String get lbl_old;

  /// 10 - 25%
  ///
  /// In en, this message translates to:
  /// **'10 - 25%'**
  String get lbl_10_25_percent;

  /// 25 - 50%
  ///
  /// In en, this message translates to:
  /// **'25 - 50%'**
  String get lbl_25_50_percent;

  /// 50 - 70%
  ///
  /// In en, this message translates to:
  /// **'50 - 70%'**
  String get lbl_50_75_percent;

  /// 70% above
  ///
  /// In en, this message translates to:
  /// **'70% above'**
  String get lbl_above_70_percent;

  /// Sort By Availability
  ///
  /// In en, this message translates to:
  /// **'Sort By Availability'**
  String get lbl_sort_by_availability;

  /// In Stock
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get txt_in_stock;

  /// Out of Stock
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get txt_out_of_stock;

  /// Apply Filter
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get btn_apply_filter;

  /// Deliver to
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get txt_deliver;

  /// View all
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get btn_view_all;

  /// Top Selling
  ///
  /// In en, this message translates to:
  /// **'Top Selling'**
  String get lbl_top_selling;

  /// Rewards
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get lbl_reward;

  /// Spotlight
  ///
  /// In en, this message translates to:
  /// **'Spotlight'**
  String get lbl_in_spotlight;

  /// Recent Selling
  ///
  /// In en, this message translates to:
  /// **'Recent Selling'**
  String get lbl_recent_selling;

  /// What's New
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get lbl_whats_new;

  /// Top Deals
  ///
  /// In en, this message translates to:
  /// **'Top Deals'**
  String get lbl_deal_products;

  /// Bundle Offers
  ///
  /// In en, this message translates to:
  /// **'Bundle Offers'**
  String get lbl_bundle_offers;

  /// Popular
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get lbl_popular;

  /// Platimun Pro
  ///
  /// In en, this message translates to:
  /// **'Platimun Pro'**
  String get lbl_platinum_pro;

  /// Get Started
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get btn_get_started;

  /// Sign Up
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get btn_signup;

  /// Login or Sign up
  ///
  /// In en, this message translates to:
  /// **'Login or Sign up'**
  String get tle_login_signup;

  /// Already have an account ?
  ///
  /// In en, this message translates to:
  /// **'Already have an account ?'**
  String get lbl_already_have_account;

  /// Please provide your number
  ///
  /// In en, this message translates to:
  /// **'Please provide your number'**
  String get txt_provide_number_desc;

  /// Delivery Details
  ///
  /// In en, this message translates to:
  /// **'Delivery Details'**
  String get txt_delivery_details;

  /// 6 digit OTP will be sent for verification
  ///
  /// In en, this message translates to:
  /// **'6 digit OTP will be sent for verification'**
  String get txt_otp_verification_desc;

  /// Please select delivery address.
  ///
  /// In en, this message translates to:
  /// **'Please select delivery address.'**
  String get txt_select_deluvery_address;

  /// Upload product image
  ///
  /// In en, this message translates to:
  /// **'Upload product image'**
  String get txt_upload_product_image;

  /// Please select date.
  ///
  /// In en, this message translates to:
  /// **'Please select date.'**
  String get txt_select_date;

  /// Please select time slot.
  ///
  /// In en, this message translates to:
  /// **'Please select time slot.'**
  String get txt_select_time_slot;

  /// Send OTP
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get btn_send_otp;

  /// Login
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get btn_login;

  /// Or Login/Sign up using
  ///
  /// In en, this message translates to:
  /// **'Or Login/Sign up using'**
  String get txt_login_signup_using;

  /// Membership
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get tle_membership;

  /// Your have an ongoing membership you cannot buy another till its expiry.
  ///
  /// In en, this message translates to:
  /// **'Your have an ongoing membership you cannot buy another till its expiry.'**
  String get tle_membership_expiry;

  /// Buy Subscription
  ///
  /// In en, this message translates to:
  /// **'Buy Subscription'**
  String get tle_subscription;

  /// Membership bought successfully.
  ///
  /// In en, this message translates to:
  /// **'Membership bought successfully.'**
  String get tle_membership_bought_sucessfully;

  /// Login With
  ///
  /// In en, this message translates to:
  /// **'Login With'**
  String get tle_login_with;

  /// Delete Address
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get tle_delete_address;

  /// Choose your plan
  ///
  /// In en, this message translates to:
  /// **'Choose your plan'**
  String get lbl_choose_plan;

  /// We value our customers, became a prime member to avail the most
  ///
  /// In en, this message translates to:
  /// **'We value our customers, became a prime member to avail the most'**
  String get txt_membership_desc;

  /// Email & Password
  ///
  /// In en, this message translates to:
  /// **'Email & Password'**
  String get txt_email_password;

  /// Notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get tle_notification;

  /// Order Summary
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get tle_order_summary;

  /// Status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get txt_status;

  /// Delivered
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get txt_delivered;

  /// Add Ratings
  ///
  /// In en, this message translates to:
  /// **'Add Ratings'**
  String get btn_add_rating;

  /// Map
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get lbl_map;

  /// Re - Order
  ///
  /// In en, this message translates to:
  /// **'Re - Order'**
  String get btn_re_order;

  /// Order History
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get tle_order_history;

  /// All Orders
  ///
  /// In en, this message translates to:
  /// **'All Orders'**
  String get lbl_all_orders;

  /// Past Orders
  ///
  /// In en, this message translates to:
  /// **'Past Orders'**
  String get lbl_past_orders;

  /// My orders
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get tle_my_order;

  /// Congrats !
  ///
  /// In en, this message translates to:
  /// **'Congrats !'**
  String get tle_congrates;

  /// Your order has been placed successfully. Stay tuned, our delivery partner will get back to you shortly.
  ///
  /// In en, this message translates to:
  /// **'Your order has been placed successfully. Stay tuned, our delivery partner will get back to you shortly.'**
  String get txt_order_success_description;

  /// Go Home
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get btn_go_home;

  /// Track Your Order
  ///
  /// In en, this message translates to:
  /// **'Track Your Order'**
  String get btn_track_order;

  /// Browse More
  ///
  /// In en, this message translates to:
  /// **'Browse More'**
  String get btn_browse_more;

  /// Verify Number
  ///
  /// In en, this message translates to:
  /// **'Verify Number'**
  String get tle_verify_number;

  /// Verify OTP
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get tle_verify_otp;

  /// OTP has been sent to your given phone number
  ///
  /// In en, this message translates to:
  /// **'OTP has been sent to your given phone number'**
  String get tle_verify_otp_sent_desc;

  /// 6 digit OTP is send in your Number
  ///
  /// In en, this message translates to:
  /// **'6 digit OTP is send in your Number'**
  String get txt_otp_sent_desc;

  /// Please enter OTP to verify your Number
  ///
  /// In en, this message translates to:
  /// **'Please enter OTP to verify your Number'**
  String get txt_otp_verify_desc;

  /// Enter OTP Manually
  ///
  /// In en, this message translates to:
  /// **'Enter OTP Manually'**
  String get txt_enter_otp;

  /// Submit & Login
  ///
  /// In en, this message translates to:
  /// **'Submit & Login'**
  String get btn_submit_login;

  /// Didn't receive the OTP yet?
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the OTP yet?'**
  String get txt_didnt_receive_otp;

  /// Resend OTP
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get btn_resend_otp;

  /// Product Details
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get tle_product_details;

  /// Similar Products
  ///
  /// In en, this message translates to:
  /// **'Similar Products'**
  String get lbl_similar_products;

  /// Edit Profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get tle_edit_profile;

  /// Update Profile Picture
  ///
  /// In en, this message translates to:
  /// **'Update Profile Picture'**
  String get btn_update_profile_picture;

  /// Add Profile Picture
  ///
  /// In en, this message translates to:
  /// **'Add Profile Picture'**
  String get btn_add_profile_picture;

  /// Edit Name
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get lbl_edit_name;

  /// Save & Update
  ///
  /// In en, this message translates to:
  /// **'Save & Update'**
  String get btn_save_update;

  /// My Orders
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get btn_my_orders;

  /// My Wallet
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get btn_my_wallet;

  /// WishList
  ///
  /// In en, this message translates to:
  /// **'WishList'**
  String get btn_wishlist;

  /// Notification
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get btn_notification;

  /// Membership
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get btn_membership;

  /// Reward
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get btn_reward;

  /// Refer & Earn
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get btn_refer_earn;

  /// Mode
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get btn_mode;

  /// About App
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get btn_about_app;

  /// App Settings
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get btn_app_setting;

  /// Logout
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get btn_logout;

  /// Rate Orders
  ///
  /// In en, this message translates to:
  /// **'Rate Orders'**
  String get btn_rate_order;

  /// Order ID
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get lbl_order_id;

  /// Orders
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get lbl_order;

  /// Number of  Items
  ///
  /// In en, this message translates to:
  /// **'Number of  Items'**
  String get lbl_number_of_items;

  /// Delivered on
  ///
  /// In en, this message translates to:
  /// **'Delivered on'**
  String get lbl_delivered_on;

  /// Rate Overall Experience
  ///
  /// In en, this message translates to:
  /// **'Rate Overall Experience'**
  String get lbl_rate_overall_exp;

  /// your comment
  ///
  /// In en, this message translates to:
  /// **'your comment'**
  String get hnt_comment;

  /// Submit Rating
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get btn_submit_rating;

  /// Invite & Earn
  ///
  /// In en, this message translates to:
  /// **'Invite & Earn'**
  String get tle_invite_earn;

  /// Refer and Earn Wallet Amount Upto from 1 to 15
  ///
  /// In en, this message translates to:
  /// **'Refer and Earn Wallet Amount Upto from 1 to 15'**
  String get txt_refer_msg;

  /// Share your code below and ask them to enter it during registration. Earn when your friends signup on our app.
  ///
  /// In en, this message translates to:
  /// **'Share your code below and ask them to enter it during registration. Earn when your friends signup on our app.'**
  String get txt_share_msg;

  /// Tap to copy
  ///
  /// In en, this message translates to:
  /// **'Tap to copy'**
  String get txt_tap_to_copy;

  /// Invite Friends
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get btn_invite_friends;

  /// Reward Points
  ///
  /// In en, this message translates to:
  /// **'Reward Points'**
  String get tle_reward_points;

  /// Your reward points
  ///
  /// In en, this message translates to:
  /// **'Your reward points'**
  String get lbl_reward_points;

  /// Redeem Points
  ///
  /// In en, this message translates to:
  /// **'Redeem Points'**
  String get btn_redeem_points;

  /// Search for products
  ///
  /// In en, this message translates to:
  /// **'Search for products'**
  String get hnt_search_for_products;

  /// Recent Searches
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get lbl_recent_search;

  /// Load More
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get btn_load_more;

  /// Search by Top Selling
  ///
  /// In en, this message translates to:
  /// **'Search by Top Selling'**
  String get tle_search_by_top_selling;

  /// Platinum Pro
  ///
  /// In en, this message translates to:
  /// **'Platinum Pro'**
  String get tle_platinum_pro;

  /// Subscription Plan
  ///
  /// In en, this message translates to:
  /// **'Subscription Plan'**
  String get lbl_subscription_plan;

  /// Subscribe this plan
  ///
  /// In en, this message translates to:
  /// **'Subscribe this plan'**
  String get btn_subscribe_this_plan;

  /// Explore Other Plans
  ///
  /// In en, this message translates to:
  /// **'Explore Other Plans'**
  String get btn_explore_other_plan;

  /// Track Order
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get tle_track_order;

  /// Estimated Time of Arrival
  ///
  /// In en, this message translates to:
  /// **'Estimated Time of Arrival'**
  String get txt_estimate_time;

  /// Order Placed on
  ///
  /// In en, this message translates to:
  /// **'Order Placed on'**
  String get lbl_order_place_on;

  /// Ordered Deliver to you
  ///
  /// In en, this message translates to:
  /// **'Ordered Deliver to you'**
  String get lbl_order_deliver;

  /// Order Cancelled
  ///
  /// In en, this message translates to:
  /// **'Order Cancelled'**
  String get lbl_order_cancel;

  /// Reorder Items
  ///
  /// In en, this message translates to:
  /// **'Reorder Items'**
  String get btn_reorder_items;

  /// Completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get txt_completed;

  /// Out of Delivery
  ///
  /// In en, this message translates to:
  /// **'Out of Delivery'**
  String get lbl_out_of_delivery;

  /// Order Confirmed
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed'**
  String get lbl_order_confirmed;

  /// Order Added to cart & Placed
  ///
  /// In en, this message translates to:
  /// **'Order Added to cart & Placed'**
  String get lbl_order_added_to_cart;

  /// Available balance
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get lbl_available_balance;

  /// Recharge History
  ///
  /// In en, this message translates to:
  /// **'Recharge History'**
  String get lbl_recharge_history;

  /// Wallet
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get lbl_wallet;

  /// Wallet Recharge
  ///
  /// In en, this message translates to:
  /// **'Wallet Recharge'**
  String get lbl_wallet_recharge;

  /// Spent Analysis
  ///
  /// In en, this message translates to:
  /// **'Spent Analysis'**
  String get lbl_spent_analysis;

  /// Wallet recharged successfully. Enjoy your journey.
  ///
  /// In en, this message translates to:
  /// **'Wallet recharged successfully. Enjoy your journey.'**
  String get txt_wallet_recharge_successfully;

  /// Spent
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get lbl_spent;

  /// Razorpay
  ///
  /// In en, this message translates to:
  /// **'Razorpay'**
  String get lbl_razoypay;

  /// Enter Amount
  ///
  /// In en, this message translates to:
  /// **'Enter Amount'**
  String get hnt_enter_amount;

  /// Other Methods
  ///
  /// In en, this message translates to:
  /// **'Other Methods'**
  String get lbl_other_methods;

  /// Add all item to cart
  ///
  /// In en, this message translates to:
  /// **'Add all item to cart'**
  String get btn_add_all_to_cart;

  /// Would you like to request for callback from us?
  ///
  /// In en, this message translates to:
  /// **'Would you like to request for callback from us?'**
  String get lbl_callback_desc;

  /// Ok
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get btn_ok;

  /// Are you sure you want to delete this address?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this address?'**
  String get lbl_delete_address_desc;

  /// Coupons
  ///
  /// In en, this message translates to:
  /// **'Coupons'**
  String get lbl_coupons;

  /// No Coupons Found.
  ///
  /// In en, this message translates to:
  /// **'No Coupons Found.'**
  String get txt_no_coupon_msg;

  /// Select Store
  ///
  /// In en, this message translates to:
  /// **'Select Store'**
  String get lbl_select_store;

  /// Callback Request
  ///
  /// In en, this message translates to:
  /// **'Callback Request'**
  String get btn_callback_request;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get lbl_actions;

  /// Take picture
  ///
  /// In en, this message translates to:
  /// **'Take picture'**
  String get lbl_take_picture;

  /// Delete All Notification
  ///
  /// In en, this message translates to:
  /// **'Delete All Notification'**
  String get lbl_delete_notification;

  /// Are you sure you want to delete all notification?
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all notification?'**
  String get txt_delete_notification_desc;

  /// Choose from library
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get lbl_choose_from_library;

  /// Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get lbl_cancel;

  /// Please enter your name
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get txt_please_enter_your_name;

  /// Please enter your email id
  ///
  /// In en, this message translates to:
  /// **'Please enter your email id'**
  String get txt_please_enter_your_email;

  /// Please enter your valid email id
  ///
  /// In en, this message translates to:
  /// **'Please enter your valid email id'**
  String get txt_please_enter_your_valid_email;

  /// Please enter your valid mobile number
  ///
  /// In en, this message translates to:
  /// **'Please enter your valid mobile number'**
  String get txt_please_enter_valid_mobile_number;

  /// Please enter your password
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get txt_please_enter_your_password;

  /// Password should be of minimum of 8 characters
  ///
  /// In en, this message translates to:
  /// **'Password should be of minimum of 8 characters'**
  String get txt_password_should_be_of_minimum_8_character;

  /// expiry month is invalid
  ///
  /// In en, this message translates to:
  /// **'expiry month is invalid'**
  String get txt_expiry_month_is_invalid;

  /// CVV
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get lbl_cvv;

  /// Enter CVV
  ///
  /// In en, this message translates to:
  /// **'Enter CVV'**
  String get lbl_enter_cvv;

  /// expiry year is invalid
  ///
  /// In en, this message translates to:
  /// **'expiry year is invalid'**
  String get txt_expiry_year_is_invalid;

  /// Please re-enter your password
  ///
  /// In en, this message translates to:
  /// **'Please re-enter your password'**
  String get txt_please_reEnter_your_password;

  /// Entered password do not match
  ///
  /// In en, this message translates to:
  /// **'Entered password do not match'**
  String get txt_password_do_not_match;

  /// Enter card number
  ///
  /// In en, this message translates to:
  /// **'Enter card number'**
  String get txt_enter_card_number;

  /// Please select state
  ///
  /// In en, this message translates to:
  /// **'Please select state'**
  String get txt_select_state;

  /// Please enter pincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter pincode.'**
  String get txt_enter_pincode;

  /// Please enter nearest landmark.
  ///
  /// In en, this message translates to:
  /// **'Please enter nearest landmark.'**
  String get txt_enter_landmark;

  /// Please enter house no, building, area etc.
  ///
  /// In en, this message translates to:
  /// **'Please enter house no, building, area etc.'**
  String get txt_enter_houseNo;

  /// No Address Found.
  ///
  /// In en, this message translates to:
  /// **'No Address Found.'**
  String get txt_no_address;

  /// Live Chat
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get txt_live_chat;

  /// Login/SignUp
  ///
  /// In en, this message translates to:
  /// **'Login/SignUp'**
  String get txt_Login_SignUp;

  /// Items
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get lbl_items;

  /// Let's Shop
  ///
  /// In en, this message translates to:
  /// **'Let\'s Shop'**
  String get lbl_let_shop;

  /// Re-enter password
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get txt_reEnter_password;

  /// Say Hi
  ///
  /// In en, this message translates to:
  /// **'Say Hi'**
  String get txt_sayHI;

  /// new message from
  ///
  /// In en, this message translates to:
  /// **'new message from'**
  String get txt_new_msg;

  /// Today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get txt_today;

  /// Yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get txt_yesterday;

  /// Customer Support
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get txt_cust_support;

  /// Ask any questions.
  ///
  /// In en, this message translates to:
  /// **'Ask any questions.'**
  String get txt_ask_any_questions;

  /// Type something here...
  ///
  /// In en, this message translates to:
  /// **'Type something here...'**
  String get txt_type_here;

  /// Preferred delivery time
  ///
  /// In en, this message translates to:
  /// **'Preferred delivery time'**
  String get txt_preferred_time;

  /// Total items in cart
  ///
  /// In en, this message translates to:
  /// **'Total items in cart'**
  String get txt_items_in_cart;

  /// Swipe to place order
  ///
  /// In en, this message translates to:
  /// **'Swipe to place order'**
  String get txt_swipe_to_order;

  /// Feedback sent successfully
  ///
  /// In en, this message translates to:
  /// **'Feedback sent successfully'**
  String get txt_feedback_sent;

  /// No description provided for @txt_enter_feedback.
  ///
  /// In en, this message translates to:
  /// **'Please enter your valuable feedback.'**
  String get txt_enter_feedback;

  /// Callback request sent successfully.
  ///
  /// In en, this message translates to:
  /// **'Callback request sent successfully.'**
  String get txt_callback_request_sent;

  /// My Coupons
  ///
  /// In en, this message translates to:
  /// **'My Coupons'**
  String get lbl_my_coupons;

  /// Code copied
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get lbl_code_copied;

  /// Categories
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get tle_category;

  /// Bundle Offers
  ///
  /// In en, this message translates to:
  /// **'Bundle Offers'**
  String get tle_bundle_offers;

  /// Products
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get tle_products;

  /// Popular Products
  ///
  /// In en, this message translates to:
  /// **'Popular Products'**
  String get tle_popular_products;

  /// Search products
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get hnt_search_product;

  /// Reset
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get tle_reset;

  /// Please enter your mobile number
  ///
  /// In en, this message translates to:
  /// **'Please enter your mobile number'**
  String get txt_please_enter_mobile_number;

  /// Send
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get btn_send;

  /// No Location Selected
  ///
  /// In en, this message translates to:
  /// **'No Location Selected'**
  String get txt_no_location_selected;

  /// Select Delivery Location.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Location.'**
  String get txt_select_location;

  /// Add To Cart
  ///
  /// In en, this message translates to:
  /// **'Add To Cart'**
  String get btn_add_cart;

  /// Can't find your desired items in the shop?
  ///
  /// In en, this message translates to:
  /// **'Can\'t find your desired items in the shop?'**
  String get tle_cant_find_product;

  /// Choose image of your shopping list from gallery
  ///
  /// In en, this message translates to:
  /// **'Choose image of your shopping list from gallery'**
  String get txt_choose_image_from_gallery;

  /// Please enter
  ///
  /// In en, this message translates to:
  /// **'Please enter'**
  String get txt_please_enter;

  /// digit phone number
  ///
  /// In en, this message translates to:
  /// **'digit phone number'**
  String get txt_digit;

  /// Delivery Boy
  ///
  /// In en, this message translates to:
  /// **'Delivery Boy'**
  String get txt_delivery_boy;

  /// No Contact Available
  ///
  /// In en, this message translates to:
  /// **'No Contact Available'**
  String get txt_no_contact;

  /// Or connect with
  ///
  /// In en, this message translates to:
  /// **'Or connect with'**
  String get txt_connect;

  /// Send OTP to Whatsapp
  ///
  /// In en, this message translates to:
  /// **'Send OTP to Whatsapp'**
  String get txt_get_otp;

  /// 0XXXXXXXXX
  ///
  /// In en, this message translates to:
  /// **'0XXXXXXXXX'**
  String get txt_0XXXXXXXXX;

  /// Login / Registration
  ///
  /// In en, this message translates to:
  /// **'Login / Registration'**
  String get txt_login_reg;

  /// for
  ///
  /// In en, this message translates to:
  /// **'for'**
  String get txt_for;

  /// Enter email and password
  ///
  /// In en, this message translates to:
  /// **'Enter email and password'**
  String get txt_email_pass;

  /// Enter mobile number
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get txt_enter_mobile;

  /// Show more
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get txt_show_more;

  /// Show less
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get txt_show_less;

  /// items in cart
  ///
  /// In en, this message translates to:
  /// **'items in cart'**
  String get txt_items_cart;

  /// No description provided for @btn_redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get btn_redeem;

  /// Uses
  ///
  /// In en, this message translates to:
  /// **'Uses'**
  String get btn_uses;

  /// Get your
  ///
  /// In en, this message translates to:
  /// **'Get your'**
  String get txt_get_your;

  /// groceries
  ///
  /// In en, this message translates to:
  /// **'groceries'**
  String get txt_groceries;

  /// delivered quickly
  ///
  /// In en, this message translates to:
  /// **'delivered quickly'**
  String get txt_delivered_quickly;

  /// Search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get txt_search;

  /// Order
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get tle_order;

  /// Profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get txt_profile;

  /// ProSelect a reason to cancel orderfile
  ///
  /// In en, this message translates to:
  /// **'Select a reason to cancel order'**
  String get txt_select_cancel_reason;

  /// Pay through cash
  ///
  /// In en, this message translates to:
  /// **'Pay through cash'**
  String get txt_pay_through_cash;

  /// Product Ratings
  ///
  /// In en, this message translates to:
  /// **'Product Ratings'**
  String get tle_product_rating;

  /// Write Review
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get btn_write_review;

  /// Edit Review
  ///
  /// In en, this message translates to:
  /// **'Edit Review'**
  String get btn_edit_review;

  /// Subscribed
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get subscribed;

  /// How was the vegetables & fruits quality?
  ///
  /// In en, this message translates to:
  /// **'How was the vegetables & fruits quality?'**
  String get rateVegetablesQuality;

  /// How was your delivery experience?
  ///
  /// In en, this message translates to:
  /// **'How was your delivery experience?'**
  String get rateDeliveryExperience;

  /// How was the packaging quality?
  ///
  /// In en, this message translates to:
  /// **'How was the packaging quality?'**
  String get ratePackagingQuality;

  /// How was hygiene?
  ///
  /// In en, this message translates to:
  /// **'How was hygiene?'**
  String get rateHygieneLevel;

  /// Submit
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
