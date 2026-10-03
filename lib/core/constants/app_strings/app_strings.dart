abstract class AppStrings {
  static const String userData = 'User';

  // Auth
  static const String loginTitle = 'Login';
  static const String emailLabel = 'Email';
  static const String emailHint = 'Enter your email';
  static const String emailError = 'This Email is not valid';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String passwordError = 'Invalid password';
  static const String rememberMe = 'Remember me';
  static const String forgetPassword = 'Forget password?';
  static const String loginButton = 'Login';
  static const String continueAsGuest = 'Continue as guest';
  static const String dontHaveAccount = "Don't have an account?";
  static const String signUp = 'Sign up';
  static const String firstNameLabel = 'First name';
  static const String firstNameHint = 'Enter first name';
  static const String lastNameLabel = 'Last name';
  static const String lastNameHint = 'Enter last name';
  static const String confirmPasswordLabel = 'Confirm password';
  static const String confirmPasswordHint = 'Confirm password';
  static const String phoneNumberLabel = 'Phone number';
  static const String phoneNumberHint = 'Enter phone number';
  static const String genderTitle = 'Gender';
  static const String female = 'female';
  static const String male = 'Male';
  static const String termsPrefix =
      'Creating an account, you agree to our ';
  static const String termsLink = 'Terms&Conditions';
  static const String alreadyHaveAccount = 'Already have an account?';

  static const String passwordAppBarTitle = 'Password';
  static const String forgetPasswordHeader = 'Forget password';
  static const String forgetPasswordSubtitle =
      'Please enter your email associated to your account';
  static const String confirmButton = 'Confirm';

  static const String emailVerificationTitle = 'Email verification';
  static const String emailVerificationSubtitle =
      'Please enter your code that send to your email address';
  static const String invalidCodeError = 'Invalid code';
  static const String didntReceiveCode = "Didn't receive code? ";
  static const String resendLink = 'Resend';

  static const String resetPasswordTitle = 'Reset password';
  static const String resetPasswordSubtitle =
      'Password must not be empty and must contain\n'
      ' 6 characters with upper case letter and one\n'
      ' number at least';
  static const String newPasswordLabel = 'New password';

  // Auth validation
  static const String loginFailed = 'Login failed';
  static const String loginSuccess = 'Login successful';
  static const String invalidCredentials = 'Invalid email or password';
  static const String somethingWentWrong = 'Something went wrong';
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Enter a valid email';
  static const String passwordRequired = 'Password is required';
  static const String passwordMinLength =
      'Password must be at least 8 characters';
  static const String passwordStrongRules =
      'Password must contain uppercase, lowercase, number and special character';
  static const String confirmPasswordRequired =
      'Please confirm your password';
  static const String confirmPasswordMismatch =
      'Passwords do not match';
  static const String usernameRequired = 'Username is required';
  static const String usernameMinLength =
      'Username must be at least 3 characters';
  static const String firstNameRequired = 'First name is required';
  static const String firstNameOnlyLetters =
      'First name must contain only letters';
  static const String lastNameRequired = 'Last name is required';
  static const String lastNameOnlyLetters =
      'Last name must contain only letters';
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid =
      'Enter a valid Egyptian phone number';

  static const String registerError = 'Failed register';
  static const String registerSuccess = 'Register successful';

  // Auth storage keys
  static const String refreshToken = 'refresh_token';
  static const String accessToken = 'access_token';
  static const String rememberedEmail = 'remembered_email';

  // Home
  static const String floweryAppbarTitle = 'Flowery';
  static const String searchHint = 'Search';
  static const String deliverToPrefix = 'Deliver to ';
  static const String categoriesLabel = 'Categories';
  static const String bestsellerLabel = 'Best seller';
  static const String ocassionLabel = 'Ocassion';
  static const String occasionTitle = 'Occasion';
  static const String viewAllLabel = 'View all';

  static const String navHome = 'Home';
  static const String navCart = 'Cart';
  static const String navProfile = 'Profile';
  static const String navcategories = 'Categories';

  static const String currencyEGP = 'EGP';
  static const String bloomSubtitle =
      'Bloom with our exquisite best sellers';

  // Product
  static const String statusLabel = 'Status: ';
  static const String addToCart = 'Add to cart';
  static const String productAddedToCart = 'Product added to cart';
  static const String inStock = 'In stock';
  static const String taxNotice = 'All prices include tax';
  static const String description = 'Description';
  static const String bouquetInclude = 'Bouquet include';

  // Search / Filter
  static const String searchPlaceholder =
      'Search For Any Product You Want';
  static const String filterButton = 'Filter';
  static const String sortBy = 'Sort by';
  static const String sortLowestPrice = 'Lowes Price';
  static const String sortHighestPrice = 'Highest Price';
  static const String sortNew = 'New';
  static const String sortOld = 'Old';
  static const String sortDiscount = 'Discount';
  static const String noResult = 'No Result found';

  // Checkout
  static const String checkoutTitle = 'Checkout';
  static const String checkout = 'Checkout';
  static const String deliveryTime = 'Delivery time';
  static const String instant = 'Instant, ';
  static const String deliveryAddress = 'Delivery address';

  static const String addressTypeHome = 'Home';
  static const String addressTypeOffice = 'Office';
  static const String addNew = '+ Add new';

  static const String paymentMethod = 'Payment method';
  static const String cashOnDelivery = 'Cash on delivery';
  static const String creditCard = 'Credit card';
  static const String itIsAGift = 'It is a gift';

  static const String nameLabel = 'Name';
  static const String enterNameHint = 'Enter the name';
  static const String enterPhoneHintAlt = 'Enter the phone number';

  static const String subTotal = 'Sub Total';
  static const String subtotal = 'Sub total:';
  static const String deliveryFee = 'Delivery Fee';
  static const String total = 'Total';
  static const String placeOrder = 'Place order';
  static const String yourCartIsEmpty = 'Your cart is empty';

  // Address
  static const String savedAddressTitle = 'Saved address';
  static const String addNewAddress = 'Add new address';
  static const String addressTitle = 'Address';
  static const String enterAddressHint = 'Enter the address';
  static const String enterTheThePhoneHint =
      'Enter the the phone number';

  static const String recipientNameLabel = 'Recipient name';
  static const String enterRecipientNameHint =
      'Enter the recipient name';

  static const String cityLabel = 'City';
  static const String areaLabel = 'Area';
  static const String saveAddress = 'Save address';

  static const String savedAddressEmpty =
      'No saved addresses yet';
  static const String titleAddress = 'Title';
  static const String labelAddress = 'Enter Title Address';
  static const String loadingAddress = 'Loading...';
  static const String labelTitle = 'Title';
  static const String labelTitleHint = 'Title of the address';

  static const String addressError =
      'Could not get address details';
  static const String addressRequired = 'Address is Required';
  static const String labelRequired = 'Label is Required';
  static const String recipientNameRequired = 'Name is Required';
  static const String cityRequired = 'City is Required';
  static const String phoneNumberRequired = 'Phone is Required';

  static const String addYourAddress = 'Add Your Address';
  static const String addressAddedSuccess =
      'Address added successfully';
  static const String addressUpdatedSuccess = 'Address updated';

  static const String addressAddFailedServer =
      'Something went wrong. Please try again later.';
  static const String addressAddFailedNotServiceable =
      'This address is not available for delivery. '
      'Please choose another location.';
  static const String addressAddFailedInvalid =
      'The address information is invalid. '
      'Please check your details.';

  static const String retry = 'Retry';

  static const String lat = 'lat';
  static const String lng = 'lng';
  static const String addressId = 'addressId';

  // Orders
  static const String myOrdersTitle = 'My orders';
  static const String tabActive = 'Active';
  static const String tabCompleted = 'Completed';
  static const String orderNumberPrefix = 'Order number# ';
  static const String trackOrder = 'Track order';
  static const String deliveredOnPrefix = 'Delivered on ';
  static const String reorder = 'Reorder';

  static const String estimatedArrival = 'Estimated arrival';
  static const String deliveryHeroSubtitle =
      'Is your delivery hero for today';

  static const String statusReceived = 'Received your order';
  static const String statusPreparing = 'Preparing your order';
  static const String statusOutForDelivery = 'Out for delivery';
  static const String statusDelivered = 'Delivered';

  static const String showMap = 'Show map';
  static const String orderDeliveredAction = 'Order Delivered';
  static const String orderDetails = 'Order details';
  static const String stepPayment = 'Payment';
  static const String nextButton = 'Next';
  static const String payWithCash = 'Pay with cash';

  static const String itemsLabel = ' Items';
  static const String enjoyYourOrderPrefix = 'Enjoy your order ';
  static const String rateButton = 'Rate';
  static const String orderPlacedSuccess =
      'Your order placed successfully!';

  // Profile
  static const String profileUpdated = 'Profile updated';
  static const String genderFemaleLabel = 'Female';
  static const String genderMaleLabel = 'Male';
  static const String genderFemaleApi = 'Female';
  static const String genderMaleApi = 'Male';
  static const String passwordMask = '••••••';

  static const String editProfileTitle = 'Edit profile';
  static const String actionChange = 'Change';
  static const String actionUpdate = 'Update';
  static const String currentPasswordLabel = 'Current password';
  static const String currentPasswordHint = 'Current password';
  static const String passwordUpdatedSuccessfully =
      'Password updated successfully';

  // Notifications
  static const String notificationTitle = 'Notification';
  static const String notificationNewOffer = 'New offer';
  static const String notificationRemember = 'Remember';

  // Language
  static const String language = 'Language';
  static const String changeLanguageTitle = 'Change Language';
  static const String languageArabic = 'Arabic';
  static const String languageEnglish = 'English';

  // General
  static const String aboutUs = 'About us';
  static const String termsAndConditionsAlt =
      'Terms & conditions';

  // Logout
  static const String logout = 'Logout';
  static const String logoutDialogTitle = 'LOGOUT';
  static const String confirmLogoutSubtitle = 'Confirm logout!!';
  static const String actionCancel = 'Cancle';

  // General Errors
  static const String userNotFound = 'User not found';
  static const String unexpectedError =
      'Something went wrong. Please try again.';

  // App Version
  static const String versionProfile = 'v6.3.0 - 1.40.0';
}