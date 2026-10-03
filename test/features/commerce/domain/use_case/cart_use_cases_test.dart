import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/cart/cart_entity.dart';
import 'package:flower_app/features/commerce/domain/models/cart/add_cart_item_params.dart';
import 'package:flower_app/features/commerce/domain/models/cart/update_cart_item_params.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:flower_app/features/commerce/domain/use_case/add_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_cart_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/remove_cart_item_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/update_cart_item_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommerceRepo extends Mock implements CommerceRepo {}

void main() {
  late MockCommerceRepo repository;
  final cart = CartEntity(
    items: const [],
    subtotal: 0,
    total: 0,
    hasChanges: false,
  );

  setUpAll(() {
    registerFallbackValue(const AddCartItemParams(productId: 0, quantity: 0));
    registerFallbackValue(const UpdateCartItemParams(quantity: 0));
  });

  setUp(() => repository = MockCommerceRepo());

  test('GetCartUseCase returns the repository result', () async {
    final response = SuccessResponce<CartEntity>(cart);
    when(() => repository.getCart()).thenAnswer((_) async => response);

    final result = await GetCartUseCase(commerceRepo: repository).call();

    expect(result, same(response));
    verify(() => repository.getCart()).called(1);
  });

  test('GetCartUseCase returns repository errors', () async {
    final response = ErrorResponce<CartEntity>(Exception('failed'));
    when(() => repository.getCart()).thenAnswer((_) async => response);

    final result = await GetCartUseCase(commerceRepo: repository).call();

    expect(result, same(response));
  });

  test('AddCartItemUseCase forwards item parameters and result', () async {
    const params = AddCartItemParams(productId: 5, quantity: 2);
    final response = SuccessResponce<CartEntity>(cart);
    when(() => repository.addToCart(params)).thenAnswer((_) async => response);

    final result = await AddCartItemUseCase(
      commerceRepo: repository,
    ).call(params);

    expect(result, same(response));
    verify(() => repository.addToCart(params)).called(1);
  });

  test('AddCartItemUseCase returns repository errors', () async {
    const params = AddCartItemParams(productId: 5, quantity: 2);
    final response = ErrorResponce<CartEntity>(Exception('failed'));
    when(() => repository.addToCart(params)).thenAnswer((_) async => response);

    final result = await AddCartItemUseCase(
      commerceRepo: repository,
    ).call(params);

    expect(result, same(response));
  });

  test('UpdateCartItemUseCase forwards id, parameters, and result', () async {
    const params = UpdateCartItemParams(quantity: 4);
    final response = SuccessResponce<CartEntity>(cart);
    when(
      () => repository.updateCartItemQuantity('item-1', params),
    ).thenAnswer((_) async => response);

    final result = await UpdateCartItemUseCase(
      commerceRepo: repository,
    ).call('item-1', params);

    expect(result, same(response));
    verify(() => repository.updateCartItemQuantity('item-1', params)).called(1);
  });

  test('UpdateCartItemUseCase returns repository errors', () async {
    const params = UpdateCartItemParams(quantity: 4);
    final response = ErrorResponce<CartEntity>(Exception('failed'));
    when(
      () => repository.updateCartItemQuantity('item-1', params),
    ).thenAnswer((_) async => response);

    final result = await UpdateCartItemUseCase(
      commerceRepo: repository,
    ).call('item-1', params);

    expect(result, same(response));
  });

  test('RemoveCartItemUseCase forwards id and result', () async {
    final response = SuccessResponce<CartEntity>(cart);
    when(
      () => repository.removeCartItem('item-1'),
    ).thenAnswer((_) async => response);

    final result = await RemoveCartItemUseCase(
      commerceRepo: repository,
    ).call('item-1');

    expect(result, same(response));
    verify(() => repository.removeCartItem('item-1')).called(1);
  });

  test('RemoveCartItemUseCase returns repository errors', () async {
    final response = ErrorResponce<CartEntity>(Exception('failed'));
    when(
      () => repository.removeCartItem('item-1'),
    ).thenAnswer((_) async => response);

    final result = await RemoveCartItemUseCase(
      commerceRepo: repository,
    ).call('item-1');

    expect(result, same(response));
  });
}
