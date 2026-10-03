import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;
import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  String get userData;
  String get loginTitle;
  String get emailLabel;
  String get emailHint;
  String get emailError;
  String get passwordLabel;
  String get passwordHint;
  String get passwordError;
  String get rememberMe;
  String get forgetPassword;
  String get loginButton;
  String get continueAsGuest;
  String get dontHaveAccount;
  String get signUp;
  String get firstNameLabel;
  String get firstNameHint;
  String get lastNameLabel;
  String get lastNameHint;
  String get confirmPasswordLabel;
  String get confirmPasswordHint;
  String get phoneNumberLabel;
  String get phoneNumberHint;
  String get genderTitle;
  String get female;
  String get male;
  String get termsPrefix;
  String get termsLink;
  String get alreadyHaveAccount;
  String get passwordAppBarTitle;
  String get forgetPasswordHeader;
  String get forgetPasswordSubtitle;
  String get confirmButton;
  String get emailVerificationTitle;
  String get emailVerificationSubtitle;
  String get invalidCodeError;
  String get didntReceiveCode;
  String get resendLink;
  String get resetPasswordTitle;
  String get resetPasswordSubtitle;
  String get newPasswordLabel;
  String get floweryAppbarTitle;
  String get searchHint;
  String get deliverToPrefix;
  String get categoriesLabel;
  String get bestsellerLabel;
  String get ocassionLabel;
  String get viewAllLabel;
  String get navHome;
  String get navCart;
  String get navProfile;
  String get navcategories;
  String get currencyEGP;
  String get bloomSubtitle;
  String get statusLabel;
  String get addToCart;
  String get inStock;
  String get taxNotice;
  String get description;
  String get bouquetInclude;
  String get checkoutTitle;
  String get deliveryTime;
  String get instant;
  String get deliveryAddress;
  String get addressTypeHome;
  String get addressTypeOffice;
  String get addNew;
  String get paymentMethod;
  String get cashOnDelivery;
  String get creditCard;
  String get itIsAGift;
  String get nameLabel;
  String get enterNameHint;
  String get enterPhoneHintAlt;
  String get subTotal;
  String get deliveryFee;
  String get total;
  String get placeOrder;
  String get savedAddressTitle;
  String get addNewAddress;
  String get addressTitle;
  String get enterAddressHint;
  String get enterTheThePhoneHint;
  String get recipientNameLabel;
  String get enterRecipientNameHint;
  String get cityLabel;
  String get areaLabel;
  String get saveAddress;
  String get filterButton;
  String get sortBy;
  String get sortLowestPrice;
  String get sortHighestPrice;
  String get sortNew;
  String get sortOld;
  String get sortDiscount;
  String get myOrdersTitle;
  String get tabActive;
  String get tabCompleted;
  String get orderNumberPrefix;
  String get trackOrder;
  String get deliveredOnPrefix;
  String get reorder;
  String get searchPlaceholder;
  String get notificationTitle;
  String get notificationNewOffer;
  String get notificationRemember;
  String get language;
  String get aboutUs;
  String get termsAndConditionsAlt;
  String get logout;
  String get userNotFound;
  String get changeLanguageTitle;
  String get languageArabic;
  String get languageEnglish;
  String get editProfileTitle;
  String get actionChange;
  String get actionUpdate;
  String get currentPasswordLabel;
  String get currentPasswordHint;
  String get logoutDialogTitle;
  String get confirmLogoutSubtitle;
  String get actionCancel;
  String get orderPlacedSuccess;
  String get estimatedArrival;
  String get deliveryHeroSubtitle;
  String get statusReceived;
  String get statusPreparing;
  String get statusOutForDelivery;
  String get statusDelivered;
  String get showMap;
  String get orderDeliveredAction;
  String get orderDetails;
  String get stepPayment;
  String get nextButton;
  String get payWithCash;
  String get itemsLabel;
  String get enjoyYourOrderPrefix;
  String get rateButton;
  String get loginFailed;
  String get loginSuccess;
  String get invalidCredentials;
  String get somethingWentWrong;
  String get emailRequired;
  String get emailInvalid;
  String get passwordRequired;
  String get passwordMinLength;
  String get passwordStrongRules;
  String get confirmPasswordRequired;
  String get confirmPasswordMismatch;
  String get usernameRequired;
  String get usernameMinLength;
  String get firstNameRequired;
  String get firstNameOnlyLetters;
  String get lastNameRequired;
  String get lastNameOnlyLetters;
  String get phoneRequired;
  String get phoneInvalid;
  String get registerError;
  String get registerSuccess;
  String get occasionTitle;
  String get versionProfile;
  String get noNotificationsYet;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(
      lookupAppLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}