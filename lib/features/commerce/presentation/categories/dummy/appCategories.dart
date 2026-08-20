class ProductModel {
  final int id;
  final String image;
  final String name;
  final double price;
  final double? oldPrice;
  final int? discount;
  final String category;

  const ProductModel({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    this.oldPrice,
    this.discount,
    required this.category,
  });
}



class AppCategories {
  static const String all = 'All';
  static const String handBouquet = 'Hand Bouquet';
  static const String vases = 'Vases';
  static const String boxes = 'Boxes';
  static const String jewelry = 'Jewelry';
  static const String gift = 'Gift';
  static const String card = 'Card';
}

final List<ProductModel> products = [
  // ============================================================
  // HAND BOUQUET - 6 Products
  // ============================================================

  ProductModel(
    id: 1,
    image: 'https://loremflickr.com/600/600/rose,bouquet?lock=101',
    name: 'Red Roses Bouquet',
    price: 600,
    oldPrice: 800,
    discount: 25,
    category: AppCategories.handBouquet,
  ),

  ProductModel(
    id: 2,
    image: 'https://loremflickr.com/600/600/pink,rose,bouquet?lock=102',
    name: 'Pink Roses Bouquet',
    price: 550,
    oldPrice: 700,
    discount: 21,
    category: AppCategories.handBouquet,
  ),

  ProductModel(
    id: 3,
    image: 'https://loremflickr.com/600/600/white,rose,bouquet?lock=103',
    name: 'White Roses Bouquet',
    price: 500,
    oldPrice: 650,
    discount: 23,
    category: AppCategories.handBouquet,
  ),

  ProductModel(
    id: 4,
    image: 'https://loremflickr.com/600/600/tulip,bouquet?lock=104',
    name: 'Pink Tulips Bouquet',
    price: 650,
    oldPrice: 800,
    discount: 19,
    category: AppCategories.handBouquet,
  ),

  ProductModel(
    id: 5,
    image: 'https://loremflickr.com/600/600/sunflower,bouquet?lock=105',
    name: 'Sunflower Bouquet',
    price: 700,
    oldPrice: 900,
    discount: 22,
    category: AppCategories.handBouquet,
  ),

  ProductModel(
    id: 6,
    image: 'https://loremflickr.com/600/600/flower,bouquet?lock=106',
    name: 'Spring Flower Bouquet',
    price: 750,
    oldPrice: 950,
    discount: 21,
    category: AppCategories.handBouquet,
  ),

  // ============================================================
  // VASES - 6 Products
  // ============================================================

  ProductModel(
    id: 7,
    image: 'https://loremflickr.com/600/600/glass,vase?lock=201',
    name: 'Classic Glass Vase',
    price: 450,
    oldPrice: 550,
    discount: 18,
    category: AppCategories.vases,
  ),

  ProductModel(
    id: 8,
    image: 'https://loremflickr.com/600/600/ceramic,vase?lock=202',
    name: 'White Ceramic Vase',
    price: 600,
    oldPrice: 750,
    discount: 20,
    category: AppCategories.vases,
  ),

  ProductModel(
    id: 9,
    image: 'https://loremflickr.com/600/600/flower,vase?lock=203',
    name: 'Elegant Flower Vase',
    price: 700,
    oldPrice: 850,
    discount: 18,
    category: AppCategories.vases,
  ),

  ProductModel(
    id: 10,
    image: 'https://loremflickr.com/600/600/blue,vase?lock=204',
    name: 'Blue Ceramic Vase',
    price: 550,
    oldPrice: 700,
    discount: 21,
    category: AppCategories.vases,
  ),

  ProductModel(
    id: 11,
    image: 'https://loremflickr.com/600/600/flower,pot?lock=205',
    name: 'Modern Flower Pot',
    price: 500,
    oldPrice: 650,
    discount: 23,
    category: AppCategories.vases,
  ),

  ProductModel(
    id: 12,
    image: 'https://loremflickr.com/600/600/decorative,vase?lock=206',
    name: 'Decorative Vase',
    price: 800,
    oldPrice: 1000,
    discount: 20,
    category: AppCategories.vases,
  ),

  // ============================================================
  // BOXES - 6 Products
  // ============================================================

  ProductModel(
    id: 13,
    image: 'https://loremflickr.com/600/600/flower,gift,box?lock=301',
    name: 'Luxury Flower Box',
    price: 900,
    oldPrice: 1100,
    discount: 18,
    category: AppCategories.boxes,
  ),

  ProductModel(
    id: 14,
    image: 'https://loremflickr.com/600/600/rose,gift,box?lock=302',
    name: 'Red Rose Box',
    price: 1000,
    oldPrice: 1250,
    discount: 20,
    category: AppCategories.boxes,
  ),

  ProductModel(
    id: 15,
    image: 'https://loremflickr.com/600/600/pink,flower,box?lock=303',
    name: 'Pink Flower Box',
    price: 850,
    oldPrice: 1000,
    discount: 15,
    category: AppCategories.boxes,
  ),

  ProductModel(
    id: 16,
    image: 'https://loremflickr.com/600/600/flowers,giftbox?lock=304',
    name: 'Birthday Flower Box',
    price: 950,
    oldPrice: 1200,
    discount: 21,
    category: AppCategories.boxes,
  ),

  ProductModel(
    id: 17,
    image: 'https://loremflickr.com/600/600/red,roses,box?lock=305',
    name: 'Romantic Rose Box',
    price: 1200,
    oldPrice: 1450,
    discount: 17,
    category: AppCategories.boxes,
  ),

  ProductModel(
    id: 18,
    image: 'https://loremflickr.com/600/600/flower,box?lock=306',
    name: 'Elegant Flower Box',
    price: 1100,
    oldPrice: 1300,
    discount: 15,
    category: AppCategories.boxes,
  ),

  // ============================================================
  // JEWELRY - 6 Products
  // ============================================================

  ProductModel(
    id: 19,
    image: 'https://loremflickr.com/600/600/floral,jewelry?lock=401',
    name: 'Flower Necklace',
    price: 1500,
    oldPrice: 1800,
    discount: 17,
    category: AppCategories.jewelry,
  ),

  ProductModel(
    id: 20,
    image: 'https://loremflickr.com/600/600/flower,necklace?lock=402',
    name: 'Floral Necklace',
    price: 1800,
    oldPrice: 2200,
    discount: 18,
    category: AppCategories.jewelry,
  ),

  ProductModel(
    id: 21,
    image: 'https://loremflickr.com/600/600/flower,ring?lock=403',
    name: 'Flower Ring',
    price: 1200,
    oldPrice: 1500,
    discount: 20,
    category: AppCategories.jewelry,
  ),

  ProductModel(
    id: 22,
    image: 'https://loremflickr.com/600/600/floral,bracelet?lock=404',
    name: 'Floral Bracelet',
    price: 1350,
    oldPrice: 1600,
    discount: 16,
    category: AppCategories.jewelry,
  ),

  ProductModel(
    id: 23,
    image: 'https://loremflickr.com/600/600/flower,earrings?lock=405',
    name: 'Flower Earrings',
    price: 950,
    oldPrice: 1200,
    discount: 21,
    category: AppCategories.jewelry,
  ),

  ProductModel(
    id: 24,
    image: 'https://loremflickr.com/600/600/floral,jewellery?lock=406',
    name: 'Elegant Jewelry Set',
    price: 2200,
    oldPrice: 2700,
    discount: 19,
    category: AppCategories.jewelry,
  ),

  // ============================================================
  // GIFT - 6 Products
  // ============================================================

  ProductModel(
    id: 25,
    image: 'https://loremflickr.com/600/600/gift,flowers?lock=501',
    name: 'Flower Gift Set',
    price: 850,
    oldPrice: 1050,
    discount: 19,
    category: AppCategories.gift,
  ),

  ProductModel(
    id: 26,
    image: 'https://loremflickr.com/600/600/gift,box,flowers?lock=502',
    name: 'Luxury Gift Set',
    price: 1200,
    oldPrice: 1500,
    discount: 20,
    category: AppCategories.gift,
  ),

  ProductModel(
    id: 27,
    image: 'https://loremflickr.com/600/600/gift,rose?lock=503',
    name: 'Rose Gift Set',
    price: 950,
    oldPrice: 1200,
    discount: 21,
    category: AppCategories.gift,
  ),

  ProductModel(
    id: 28,
    image: 'https://loremflickr.com/600/600/birthday,gift,flowers?lock=504',
    name: 'Birthday Gift',
    price: 1100,
    oldPrice: 1350,
    discount: 18,
    category: AppCategories.gift,
  ),

  ProductModel(
    id: 29,
    image: 'https://loremflickr.com/600/600/romantic,gift,flowers?lock=505',
    name: 'Romantic Gift',
    price: 1300,
    oldPrice: 1600,
    discount: 19,
    category: AppCategories.gift,
  ),

  ProductModel(
    id: 30,
    image: 'https://loremflickr.com/600/600/premium,gift,flowers?lock=506',
    name: 'Premium Flower Gift',
    price: 1500,
    oldPrice: 1800,
    discount: 17,
    category: AppCategories.gift,
  ),

  // ============================================================
  // CARD - 6 Products
  // ============================================================

  ProductModel(
    id: 31,
    image: 'https://loremflickr.com/600/600/greeting,card?lock=601',
    name: 'Happy Birthday Card',
    price: 100,
    oldPrice: 150,
    discount: 33,
    category: AppCategories.card,
  ),

  ProductModel(
    id: 32,
    image: 'https://loremflickr.com/600/600/love,card?lock=602',
    name: 'Love Greeting Card',
    price: 120,
    oldPrice: 180,
    discount: 33,
    category: AppCategories.card,
  ),

  ProductModel(
    id: 33,
    image: 'https://loremflickr.com/600/600/thank,you,card?lock=603',
    name: 'Thank You Card',
    price: 90,
    oldPrice: 130,
    discount: 31,
    category: AppCategories.card,
  ),

  ProductModel(
    id: 34,
    image: 'https://loremflickr.com/600/600/floral,card?lock=604',
    name: 'Floral Greeting Card',
    price: 110,
    oldPrice: 160,
    discount: 31,
    category: AppCategories.card,
  ),

  ProductModel(
    id: 35,
    image: 'https://loremflickr.com/600/600/wedding,card?lock=605',
    name: 'Wedding Card',
    price: 150,
    oldPrice: 200,
    discount: 25,
    category: AppCategories.card,
  ),

  ProductModel(
    id: 36,
    image: 'https://loremflickr.com/600/600/flower,card?lock=606',
    name: 'Flower Message Card',
    price: 130,
    oldPrice: 180,
    discount: 28,
    category: AppCategories.card,
  ),
];