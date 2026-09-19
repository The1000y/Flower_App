//ignore: unused_import
// import 'package:intl/intl.dart' as intl;
// import 'app_localizations.dart';
//
// // ignore_for_file: type=lint
//
// /// The translations for English (`en`).
// class AppLocalizationsEn extends AppLocalizations {
//   AppLocalizationsEn([String locale = 'en']) : super(locale);
//
//   @override
//   String get userData => 'User';
//
//   @override
//   String get loginTitle => 'Login';
//
//   @override
//   String get emailLabel => 'Email';
//
//   @override
//   String get emailHint => 'Enter your email';
//
//   @override
//   String get emailError => 'This Email is not valid';
//
//   @override
//   String get passwordLabel => 'Password';
//
//   @override
//   String get passwordHint => 'Enter your password';
//
//   @override
//   String get passwordError => 'Invalid password';
//
//   @override
//   String get rememberMe => 'Remember me';
//
//   @override
//   String get forgetPassword => 'Forget password?';
//
//   @override
//   String get loginButton => 'Login';
//
//   @override
//   String get continueAsGuest => 'Continue as guest';
//
//   @override
//   String get dontHaveAccount => 'Don\'t have an account?';
//
//   @override
//   String get signUp => 'Sign up';
//
//   @override
//   String get firstNameLabel => 'First name';
//
//   @override
//   String get firstNameHint => 'Enter first name';
//
//   @override
//   String get lastNameLabel => 'Last name';
//
//   @override
//   String get lastNameHint => 'Enter last name';
//
//   @override
//   String get confirmPasswordLabel => 'Confirm password';
//
//   @override
//   String get confirmPasswordHint => 'Confirm password';
//
//   @override
//   String get phoneNumberLabel => 'Phone number';
//
//   @override
//   String get phoneNumberHint => 'Enter phone number';
//
//   @override
//   String get genderTitle => 'Gender';
//
//   @override
//   String get female => 'female';
//
//   @override
//   String get male => 'Male';
//
//   @override
//   String get termsPrefix => 'Creating an account, you agree to our ';
//
//   @override
//   String get termsLink => 'Terms&Conditions';
//
//   @override
//   String get alreadyHaveAccount => 'Already have an account?';
//
//   @override
//   String get passwordAppBarTitle => 'Password';
//
//   @override
//   String get forgetPasswordHeader => 'Forget password';
//
//   @override
//   String get forgetPasswordSubtitle =>
//       'Please enter your email associated to your account';
//
//   @override
//   String get confirmButton => 'Confirm';
//
//   @override
//   String get emailVerificationTitle => 'Email verification';
//
//   @override
//   String get emailVerificationSubtitle =>
//       'Please enter your code that send to your email address';
//
//   @override
//   String get invalidCodeError => 'Invalid code';
//
//   @override
//   String get didntReceiveCode => 'Didn\'t receive code? ';
//
//   @override
//   String get resendLink => 'Resend';
//
//   @override
//   String get resetPasswordTitle => 'Reset password';
//
//   @override
//   String get resetPasswordSubtitle =>
//       'Password must not be empty and must contain\n 6 characters with upper case letter and one\n number at least';
//
//   @override
//   String get newPasswordLabel => 'New password';
//
//   @override
//   String get floweryAppbarTitle => 'Flowery';
//
//   @override
//   String get searchHint => 'Search';
//
//   @override
//   String get deliverToPrefix => 'Deliver to ';
//
//   @override
//   String get categoriesLabel => 'Categories';
//
//   @override
//   String get bestsellerLabel => 'Best seller';
//
//   @override
//   String get ocassionLabel => 'Ocassion';
//
//   @override
//   String get viewAllLabel => 'View all';
//
//   @override
//   String get navHome => 'Home';
//
//   @override
//   String get navCart => 'Cart';
//
//   @override
//   String get navProfile => 'Profile';
//
//   @override
//   String get navcategories => 'Categories';
//
//   @override
//   String get currencyEGP => 'EGP';
//
//   @override
//   String get bloomSubtitle => 'Bloom with our exquisite best sellers';
//
//   @override
//   String get statusLabel => 'Status: ';
//
//   @override
//   String get addToCart => 'Add to cart';
//
//   @override
//   String get inStock => 'In stock';
//
//   @override
//   String get taxNotice => 'All prices include tax';
//
//   @override
//   String get description => 'Description';
//
//   @override
//   String get bouquetInclude => 'Bouquet include';
//
//   @override
//   String get checkoutTitle => 'Checkout';
//
//   @override
//   String get deliveryTime => 'Delivery time';
//
//   @override
//   String get instant => 'Instant, ';
//
//   @override
//   String get deliveryAddress => 'Delivery address';
//
//   @override
//   String get addressTypeHome => 'Home';
//
//   @override
//   String get addressTypeOffice => 'Office';
//
//   @override
//   String get addNew => '+ Add new';
//
//   @override
//   String get paymentMethod => 'Payment method';
//
//   @override
//   String get cashOnDelivery => 'Cash on delivery';
//
//   @override
//   String get creditCard => 'Credit card';
//
//   @override
//   String get itIsAGift => 'It is a gift';
//
//   @override
//   String get nameLabel => 'Name';
//
//   @override
//   String get enterNameHint => 'Enter the name';
//
//   @override
//   String get enterPhoneHintAlt => 'Enter the phone number';
//
//   @override
//   String get subTotal => 'Sub Total';
//
//   @override
//   String get deliveryFee => 'Delivery Fee';
//
//   @override
//   String get total => 'Total';
//
//   @override
//   String get placeOrder => 'Place order';
//
//   @override
//   String get savedAddressTitle => 'Saved address';
//
//   @override
//   String get addNewAddress => 'Add new address';
//
//   @override
//   String get addressTitle => 'Address';
//
//   @override
//   String get enterAddressHint => 'Enter the address';
//
//   @override
//   String get enterTheThePhoneHint => 'Enter the the phone number';
//
//   @override
//   String get recipientNameLabel => 'Recipient name';
//
//   @override
//   String get enterRecipientNameHint => 'Enter the recipient name';
//
//   @override
//   String get cityLabel => 'City';
//
//   @override
//   String get areaLabel => 'Area';
//
//   @override
//   String get saveAddress => 'Save address';
//
//   @override
//   String get filterButton => 'Filter';
//
//   @override
//   String get sortBy => 'Sort by';
//
//   @override
//   String get sortLowestPrice => 'Lowes Price';
//
//   @override
//   String get sortHighestPrice => 'Highest Price';
//
//   @override
//   String get sortNew => 'New';
//
//   @override
//   String get sortOld => 'Old';
//
//   @override
//   String get sortDiscount => 'Discount';
//
//   @override
//   String get myOrdersTitle => 'My orders';
//
//   @override
//   String get tabActive => 'Active';
//
//   @override
//   String get tabCompleted => 'Completed';
//
//   @override
//   String get orderNumberPrefix => 'Order number# ';
//
//   @override
//   String get trackOrder => 'Track order';
//
//   @override
//   String get deliveredOnPrefix => 'Delivered on ';
//
//   @override
//   String get reorder => 'Reorder';
//
//   @override
//   String get searchPlaceholder => 'Search For Any Product You Want';
//
//   @override
//   String get notificationTitle => 'Notification';
//
//   @override
//   String get notificationNewOffer => 'New offer';
//
//   @override
//   String get notificationRemember => 'Remember';
//
//   @override
//   String get language => 'Language';
//
//   @override
//   String get aboutUs => 'About us';
//
//   @override
//   String get termsAndConditionsAlt => 'Terms & conditions';
//
//   @override
//   String get logout => 'Logout';
//
//   @override
//   String get usernotfound => 'User not found';
//
//   @override
//   String get changeLanguageTitle => 'Change Language';
//
//   @override
//   String get languageArabic => 'Arabic';
//
//   @override
//   String get languageEnglish => 'English';
//
//   @override
//   String get editProfileTitle => 'Edit profile';
//
//   @override
//   String get actionChange => 'Change';
//
//   @override
//   String get actionUpdate => 'Update';
//
//   @override
//   String get currentPasswordLabel => 'Current password';
//
//   @override
//   String get currentPasswordHint => 'Current password';
//
//   @override
//   String get logoutDialogTitle => 'LOGOUT';
//
//   @override
//   String get confirmLogoutSubtitle => 'Confirm logout!!';
//
//   @override
//   String get actionCancel => 'Cancle';
//
//   @override
//   String get orderPlacedSuccess => 'Your order placed successfully!';
//
//   @override
//   String get estimatedArrival => 'Estimated arrival';
//
//   @override
//   String get deliveryHeroSubtitle => 'Is your delivery hero for today';
//
//   @override
//   String get statusReceived => 'Received your order';
//
//   @override
//   String get statusPreparing => 'Preparing your order';
//
//   @override
//   String get statusOutForDelivery => 'Out for delivery';
//
//   @override
//   String get statusDelivered => 'Delivered';
//
//   @override
//   String get showMap => 'Show map';
//
//   @override
//   String get orderDeliveredAction => 'Order Delivered';
//
//   @override
//   String get orderDetails => 'Order details';
//
//   @override
//   String get stepPayment => 'Payment';
//
//   @override
//   String get nextButton => 'Next';
//
//   @override
//   String get payWithCash => 'Pay with cash';
//
//   @override
//   String get itemsLabel => ' Items';
//
//   @override
//   String get enjoyYourOrderPrefix => 'Enjoy your order ';
//
//   @override
//   String get rateButton => 'Rate';
//
//   @override
//   String get loginFailed => 'Login failed';
//
//   @override
//   String get loginSuccess => 'Login successful';
//
//   @override
//   String get invalidCredentials => 'Invalid email or password';
//
//   @override
//   String get somethingWentWrong => 'Something went wrong';
//
//   @override
//   String get emailRequired => 'Email is required';
//
//   @override
//   String get emailInvalid => 'Enter a valid email';
//
//   @override
//   String get passwordRequired => 'Password is required';
//
//   @override
//   String get passwordMinLength => 'Password must be at least 8 characters';
//
//   @override
//   String get passwordStrongRules =>
//       'Password must contain uppercase, lowercase, number and special character';
//
//   @override
//   String get confirmPasswordRequired => 'Please confirm your password';
//
//   @override
//   String get confirmPasswordMismatch => 'Passwords do not match';
//
//   @override
//   String get usernameRequired => 'Username is required';
//
//   @override
//   String get usernameMinLength => 'Username must be at least 3 characters';
//
//   @override
//   String get firstNameRequired => 'First name is required';
//
//   @override
//   String get firstNameOnlyLetters => 'First name must contain only letters';
//
//   @override
//   String get lastNameRequired => 'Last name is required';
//
//   @override
//   String get lastNameOnlyLetters => 'Last name must contain only letters';
//
//   @override
//   String get phoneRequired => 'Phone number is required';
//
//   @override
//   String get phoneInvalid => 'Enter a valid Egyptian phone number';
//
//   @override
//   String get registerError => 'Failed register';
//
//   @override
//   String get registerSuccess => 'Register successful';
//
//   @override
//   String get occasionTitle => 'Occasion';
//
//   @override
//   String get versionProfile => 'v6.3.0 - 1.40.0';
// }