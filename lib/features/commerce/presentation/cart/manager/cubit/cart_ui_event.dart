import 'package:flower_app/config/base/base_ui_event.dart';

/// One-shot events the Cart feature pushes to the presentation layer.
///
/// They carry the outcome of a cart mutation so a single listener can show the
/// right feedback (for example a snackbar) without the cubit ever touching the
/// UI or a `BuildContext`.
sealed class CartUiEvent extends BaseUiEvent {
  const CartUiEvent();
}

/// Emitted after a product has been added to the cart successfully.
class AddToCartSuccessUiEvent extends CartUiEvent {
  const AddToCartSuccessUiEvent();
}

/// Emitted when adding a product to the cart fails.
///
/// [message] is the failure reported by the data source; an empty string means
/// no specific reason was provided and the presentation layer should fall back
/// to a generic, localized message.
class AddToCartFailureUiEvent extends CartUiEvent {
  final String message;

  const AddToCartFailureUiEvent({this.message = ''});
}
