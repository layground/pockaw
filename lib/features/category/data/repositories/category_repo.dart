import 'package:pockaw/features/category/data/model/category_model.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// --- Top Level Category IDs (for easy reference when creating sub-categories) ---
final String _foodAndDrinksId = _uuid.v4();
final String _transportationId = _uuid.v4();
final String _housingId = _uuid.v4();
final String _shoppingId = _uuid.v4();

final List<CategoryModel> categories = [
  // --- Top Level Categories ---
  CategoryModel(
    id: _foodAndDrinksId,
    title: 'Food & Drinks',
    iconName: 'HugeIcons.strokeRoundedRestaurantMenu', // Example icon name
    description: 'Expenses related to eating out, groceries, coffee, etc.',
  ),
  CategoryModel(
    id: _transportationId,
    title: 'Transportation',
    iconName: 'HugeIcons.strokeRoundedBus', // Example icon name
    description: 'Costs for public transport, fuel, ride-sharing, etc.',
  ),
  CategoryModel(
    id: _housingId,
    title: 'Housing',
    iconName: 'HugeIcons.strokeRoundedHome02', // Example icon name
    description: 'Rent, mortgage, utilities, home maintenance.',
  ),
  CategoryModel(
    id: _shoppingId,
    title: 'Shopping',
    iconName: 'HugeIcons.strokeRoundedShoppingBag01', // Example icon name
    description: 'Purchases for clothing, electronics, gifts, etc.',
  ),
  CategoryModel(
    id: _uuid.v4(),
    title: 'Entertainment',
    iconName: 'HugeIcons.strokeRoundedCinema', // Example icon name
    description: 'Movies, concerts, hobbies, subscriptions.',
  ),
  CategoryModel(
    id: _uuid.v4(),
    title: 'Health & Wellness',
    iconName: 'HugeIcons.strokeRoundedMedicalCrossCircle', // Example icon name
  ),

  // --- Sub-Categories ---
  CategoryModel(
    id: _uuid.v4(),
    title: 'Groceries',
    iconName: 'HugeIcons.strokeRoundedShoppingBasket01', // Example icon name
    parentId: _foodAndDrinksId,
    description: 'Weekly grocery shopping.',
  ),
  CategoryModel(
    id: _uuid.v4(),
    title: 'Restaurants',
    iconName: 'HugeIcons.strokeRoundedPlate', // Example icon name
    parentId: _foodAndDrinksId,
  ),
  CategoryModel(
    id: _uuid.v4(),
    title: 'Fuel',
    iconName: 'HugeIcons.strokeRoundedGasStation', // Example icon name
    parentId: _transportationId,
  ),
  CategoryModel(
    id: _uuid.v4(),
    title: 'Clothing',
    iconName: 'HugeIcons.strokeRoundedTShirt', // Example icon name
    parentId: _shoppingId,
    description: 'New clothes and accessories.',
  ),
  CategoryModel(
    // Example of a category without an ID (perhaps newly created, not yet saved)
    title: 'Coffee Shops',
    iconName: 'HugeIcons.strokeRoundedCoffee', // Example icon name
    parentId: _foodAndDrinksId,
  ),
];
