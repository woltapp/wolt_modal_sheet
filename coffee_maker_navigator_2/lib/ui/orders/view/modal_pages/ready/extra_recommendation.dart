const String _assetPath = 'lib/assets/images/';

enum ExtraRecommendation {
  bananaBread(
    label: 'Banana bread',
    price: '€2,50',
    imageAssetPath: '${_assetPath}banana_bread.webp',
  ),
  chocolateCookie(
    label: 'Chocolate cookie',
    price: '€1,50',
    imageAssetPath: '${_assetPath}cohoco_cookie.webp',
  ),
  croissant(
    label: 'Croissant',
    price: '€2,99',
    imageAssetPath: '${_assetPath}croissant.webp',
  ),
  donut(
    label: 'Donut',
    price: '€1,50',
    imageAssetPath: '${_assetPath}donut.webp',
  ),
  iceCream(
    label: 'Ice cream',
    price: '€3,00',
    imageAssetPath: '${_assetPath}ice_cream.webp',
  ),
  lemonCake(
    label: 'Lemon cake',
    price: '€4,50',
    imageAssetPath: '${_assetPath}lemon_cake.webp',
  ),
  macaroni(
    label: 'Macaroni',
    price: '€2,50',
    imageAssetPath: '${_assetPath}macaroni.webp',
  ),
  muffin(
    label: 'Muffin',
    price: '€2,50',
    imageAssetPath: '${_assetPath}muffin.webp',
  ),
  pancake(
    label: 'Pancake',
    price: '€6,00',
    imageAssetPath: '${_assetPath}pancake.webp',
  ),
  blueberryPie(
    label: 'Blueberry muffin',
    price: '€3,70',
    imageAssetPath: '${_assetPath}blueberry_pie.webp',
  ),
  brownie(
    label: 'Brownie',
    price: '€2,00',
    imageAssetPath: '${_assetPath}brownie.webp',
  ),
  cinnamonRoll(
    label: 'Cinnamon roll',
    price: '€5,00',
    imageAssetPath: '${_assetPath}cinnamon_roll.webp',
  ),
  cheesecake(
    label: 'Cheesecake',
    price: '€2,50',
    imageAssetPath: '${_assetPath}cheesecake.webp',
  ),
  tiramisu(
    label: 'Tiramisu',
    price: '€7,50',
    imageAssetPath: '${_assetPath}tiramisu.webp',
  ),
  eclair(
    label: 'Eclair',
    price: '€3,00',
    imageAssetPath: '${_assetPath}eclair.webp',
  ),
  fudge(
    label: 'Fudge',
    price: '€2,00',
    imageAssetPath: '${_assetPath}fudge.webp',
  ),
  baklava(
    label: 'Baklava',
    price: '€5,50',
    imageAssetPath: '${_assetPath}baklava.webp',
  ),
  crepe(
    label: 'Crepe',
    price: '€3,00',
    imageAssetPath: '${_assetPath}crepe.webp',
  );

  const ExtraRecommendation({
    required this.imageAssetPath,
    required this.label,
    required this.price,
  });

  final String imageAssetPath;
  final String label;
  final String price;
}
