

// @Injectable(as: CommerceLocalDataSource)
// class LocalDataSourceImpl implements CommerceLocalDataSource {
//   @override
//   Future<BaseResponce<List<CategoriesResponseDto>>> getCategories() async {
//     final categories = CategoriesResponseDto(
//       data: [
//         CategoryDto(
//           id: 1,
//           name: 'All',
//           iconUrl: 'https://cdn.flowery-app.com/categories/all.png',
//         ),
//         CategoryDto(
//           id: 2,
//           name: 'Hand Bouquet',
//           iconUrl: 'https://cdn.flowery-app.com/categories/hand-bouquet.png',
//         ),
//         CategoryDto(
//           id: 3,
//           name: 'Vases',
//           iconUrl: 'https://cdn.flowery-app.com/categories/vases.png',
//         ),
//         CategoryDto(
//           id: 4,
//           name: 'Boxes',
//           iconUrl: 'https://cdn.flowery-app.com/categories/boxes.png',
//         ),
//         CategoryDto(
//           id: 5,
//           name: 'Jewelry',
//           iconUrl: 'https://cdn.flowery-app.com/categories/jewelry.png',
//         ),
//         CategoryDto(
//           id: 6,
//           name: 'Gift',
//           iconUrl: 'https://cdn.flowery-app.com/categories/gift.png',
//         ),
//         CategoryDto(
//           id: 7,
//           name: 'Card',
//           iconUrl: 'https://cdn.flowery-app.com/categories/card.png',
//         ),
//       ],
//       isSuccess: true,
//       message: '',
//       errorCode: 'None',
//     );
//
//     return SuccessResponce<List<CategoriesResponseDto>>([
//       categories,
//     ]);
//   }
//
//   @override
//   Future<BaseResponce<ProductsResponseDto>> getProducts() async {
//     final products = [
//       ProductDto(
//         id: 1,
//         imageUrl:
//             'https://loremflickr.com/600/600/rose,bouquet?lock=101',
//         name: 'Red Roses Bouquet',
//         price: 600,
//         originalPrice: 800,
//         discountPercentage: 25,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 2,
//         imageUrl:
//             'https://loremflickr.com/600/600/pink,rose,bouquet?lock=102',
//         name: 'Pink Roses Bouquet',
//         price: 550,
//         originalPrice: 700,
//         discountPercentage: 21,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 3,
//         imageUrl:
//             'https://loremflickr.com/600/600/white,rose,bouquet?lock=103',
//         name: 'White Roses Bouquet',
//         price: 500,
//         originalPrice: 650,
//         discountPercentage: 23,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 4,
//         imageUrl:
//             'https://loremflickr.com/600/600/tulip,bouquet?lock=104',
//         name: 'Pink Tulips Bouquet',
//         price: 650,
//         originalPrice: 800,
//         discountPercentage: 19,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 5,
//         imageUrl:
//             'https://loremflickr.com/600/600/sunflower,bouquet?lock=105',
//         name: 'Sunflower Bouquet',
//         price: 700,
//         originalPrice: 900,
//         discountPercentage: 22,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 6,
//         imageUrl:
//             'https://loremflickr.com/600/600/flower,bouquet?lock=106',
//         name: 'Spring Flower Bouquet',
//         price: 750,
//         originalPrice: 950,
//         discountPercentage: 21,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//
//       // VASES
//       ProductDto(
//         id: 7,
//         imageUrl:
//             'https://loremflickr.com/600/600/glass,vase?lock=201',
//         name: 'Classic Glass Vase',
//         price: 450,
//         originalPrice: 550,
//         discountPercentage: 18,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 8,
//         imageUrl:
//             'https://loremflickr.com/600/600/ceramic,vase?lock=202',
//         name: 'White Ceramic Vase',
//         price: 600,
//         originalPrice: 750,
//         discountPercentage: 20,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 9,
//         imageUrl:
//             'https://loremflickr.com/600/600/flower,vase?lock=203',
//         name: 'Elegant Flower Vase',
//         price: 700,
//         originalPrice: 850,
//         discountPercentage: 18,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 10,
//         imageUrl:
//             'https://loremflickr.com/600/600/blue,vase?lock=204',
//         name: 'Blue Ceramic Vase',
//         price: 550,
//         originalPrice: 700,
//         discountPercentage: 21,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 11,
//         imageUrl:
//             'https://loremflickr.com/600/600/flower,pot?lock=205',
//         name: 'Modern Flower Pot',
//         price: 500,
//         originalPrice: 650,
//         discountPercentage: 23,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 12,
//         imageUrl:
//             'https://loremflickr.com/600/600/decorative,vase?lock=206',
//         name: 'Decorative Vase',
//         price: 800,
//         originalPrice: 1000,
//         discountPercentage: 20,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//
//       // BOXES
//       ProductDto(
//         id: 13,
//         imageUrl:
//             'https://loremflickr.com/600/600/flower,gift,box?lock=301',
//         name: 'Luxury Flower Box',
//         price: 900,
//         originalPrice: 1100,
//         discountPercentage: 18,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 14,
//         imageUrl:
//             'https://loremflickr.com/600/600/rose,gift,box?lock=302',
//         name: 'Red Rose Box',
//         price: 1000,
//         originalPrice: 1250,
//         discountPercentage: 20,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 15,
//         imageUrl:
//             'https://loremflickr.com/600/600/pink,flower,box?lock=303',
//         name: 'Pink Flower Box',
//         price: 850,
//         originalPrice: 1000,
//         discountPercentage: 15,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 16,
//         imageUrl:
//             'https://loremflickr.com/600/600/flowers,giftbox?lock=304',
//         name: 'Birthday Flower Box',
//         price: 950,
//         originalPrice: 1200,
//         discountPercentage: 21,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 17,
//         imageUrl:
//             'https://loremflickr.com/600/600/red,roses,box?lock=305',
//         name: 'Romantic Rose Box',
//         price: 1200,
//         originalPrice: 1450,
//         discountPercentage: 17,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 18,
//         imageUrl:
//             'https://loremflickr.com/600/600/flower,box?lock=306',
//         name: 'Elegant Flower Box',
//         price: 1100,
//         originalPrice: 1300,
//         discountPercentage: 15,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//
//       // JEWELRY
//       ProductDto(
//         id: 19,
//         imageUrl:
//             'https://loremflickr.com/600/600/floral,jewelry?lock=401',
//         name: 'Flower Necklace',
//         price: 1500,
//         originalPrice: 1800,
//         discountPercentage: 17,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 20,
//         imageUrl:
//             'https://loremflickr.com/600/600/flower,necklace?lock=402',
//         name: 'Floral Necklace',
//         price: 1800,
//         originalPrice: 2200,
//         discountPercentage: 18,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 21,
//         imageUrl:
//             'https://loremflickr.com/600/600/flower,ring?lock=403',
//         name: 'Flower Ring',
//         price: 1200,
//         originalPrice: 1500,
//         discountPercentage: 20,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 22,
//         imageUrl:
//             'https://loremflickr.com/600/600/floral,bracelet?lock=404',
//         name: 'Floral Bracelet',
//         price: 1350,
//         originalPrice: 1600,
//         discountPercentage: 16,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 23,
//         imageUrl:
//             'https://loremflickr.com/600/600/flower,earrings?lock=405',
//         name: 'Flower Earrings',
//         price: 950,
//         originalPrice: 1200,
//         discountPercentage: 21,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 24,
//         imageUrl:
//             'https://loremflickr.com/600/600/floral,jewellery?lock=406',
//         name: 'Elegant Jewelry Set',
//         price: 2200,
//         originalPrice: 2700,
//         discountPercentage: 19,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//
//       // GIFT
//       ProductDto(
//         id: 25,
//         imageUrl:
//             'https://loremflickr.com/600/600/gift,flowers?lock=501',
//         name: 'Flower Gift Set',
//         price: 850,
//         originalPrice: 1050,
//         discountPercentage: 19,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 26,
//         imageUrl:
//             'https://loremflickr.com/600/600/gift,box,flowers?lock=502',
//         name: 'Luxury Gift Set',
//         price: 1200,
//         originalPrice: 1500,
//         discountPercentage: 20,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 27,
//         imageUrl:
//             'https://loremflickr.com/600/600/gift,rose?lock=503',
//         name: 'Rose Gift Set',
//         price: 950,
//         originalPrice: 1200,
//         discountPercentage: 21,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 28,
//         imageUrl:
//             'https://loremflickr.com/600/600/birthday,gift,flowers?lock=504',
//         name: 'Birthday Gift',
//         price: 1100,
//         originalPrice: 1350,
//         discountPercentage: 18,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 29,
//         imageUrl:
//             'https://loremflickr.com/600/600/romantic,gift,flowers?lock=505',
//         name: 'Romantic Gift',
//         price: 1300,
//         originalPrice: 1600,
//         discountPercentage: 19,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 30,
//         imageUrl:
//             'https://loremflickr.com/600/600/premium,gift,flowers?lock=506',
//         name: 'Premium Flower Gift',
//         price: 1500,
//         originalPrice: 1800,
//         discountPercentage: 17,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//
//       // CARD
//       ProductDto(
//         id: 31,
//         imageUrl:
//             'https://loremflickr.com/600/600/greeting,card?lock=601',
//         name: 'Happy Birthday Card',
//         price: 100,
//         originalPrice: 150,
//         discountPercentage: 33,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 32,
//         imageUrl:
//             'https://loremflickr.com/600/600/love,card?lock=602',
//         name: 'Love Greeting Card',
//         price: 120,
//         originalPrice: 180,
//         discountPercentage: 33,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 33,
//         imageUrl:
//             'https://loremflickr.com/600/600/thank,you,card?lock=603',
//         name: 'Thank You Card',
//         price: 90,
//         originalPrice: 130,
//         discountPercentage: 31,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 34,
//         imageUrl:
//             'https://loremflickr.com/600/600/floral,card?lock=604',
//         name: 'Floral Greeting Card',
//         price: 110,
//         originalPrice: 160,
//         discountPercentage: 31,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 35,
//         imageUrl:
//             'https://loremflickr.com/600/600/wedding,card?lock=605',
//         name: 'Wedding Card',
//         price: 150,
//         originalPrice: 200,
//         discountPercentage: 25,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//       ProductDto(
//         id: 36,
//         imageUrl:
//             'https://loremflickr.com/600/600/flower,card?lock=606',
//         name: 'Flower Message Card',
//         price: 130,
//         originalPrice: 180,
//         discountPercentage: 28,
//         currency: 'EGP',
//         status: 'InStock',
//       ),
//     ];
//
//     final response = ProductsResponseDto(
//       data: ProductListDataDto(
//         items: products,
//         pagination: PaginationDto(
//           page: 1,
//           pageSize: products.length,
//           totalCount: products.length,
//           totalPages: 1,
//           hasNextPage: false,
//           hasPreviousPage: false,
//         ),
//       ),
//       isSuccess: true,
//       message: '',
//       errorCode: 'None',
//     );
//
//     return SuccessResponce<ProductsResponseDto>(response);
//   }
// }

