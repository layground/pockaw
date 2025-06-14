import 'package:pockaw/features/category/data/model/category_model.dart';

final List<CategoryModel> categories = [
  CategoryModel(
    id: 1,
    title: 'Food & Drinks',
    iconName: 'HugeIcons.strokeRoundedRestaurantMenu', // Example icon name
    description: 'Groceries, restaurants, coffee, snacks, etc.',
    subCategories: [
      CategoryModel(
        id: 101,
        parentId: 1,
        title: 'Groceries',
        iconName: 'HugeIcons.strokeRoundedShoppingBasket01',
        description: 'Food and household supplies from supermarkets.',
      ),
      CategoryModel(
        id: 102,
        parentId: 1,
        title: 'Restaurants & Cafes',
        iconName: 'HugeIcons.strokeRoundedPlate',
        description: 'Dining out, coffee shops, bars.',
      ),
      CategoryModel(
        id: 103,
        parentId: 1,
        title: 'Takeaway & Delivery',
        iconName: 'HugeIcons.strokeRoundedDeliveryBox01',
        description: 'Food ordered for delivery or pickup.',
      ),
    ],
  ),
  CategoryModel(
    id: 2,
    title: 'Transportation',
    iconName: 'HugeIcons.strokeRoundedBus', // Example icon name
    description: 'Public transport, fuel, ride-sharing, vehicle costs.',
    subCategories: [
      CategoryModel(
        id: 201,
        parentId: 2,
        title: 'Public Transport',
        iconName: 'HugeIcons.strokeRoundedTrain',
        description: 'Bus, train, subway, tram fares.',
      ),
      CategoryModel(
        id: 202,
        parentId: 2,
        title: 'Fuel/Gas',
        iconName: 'HugeIcons.strokeRoundedGasStation',
        description: 'Petrol, diesel, charging for electric vehicles.',
      ),
      CategoryModel(
        id: 203,
        parentId: 2,
        title: 'Taxi & Rideshare',
        iconName: 'HugeIcons.strokeRoundedCar',
        description: 'Uber, Lyft, taxi fares.',
      ),
      CategoryModel(
        id: 204,
        parentId: 2,
        title: 'Vehicle Maintenance',
        iconName: 'HugeIcons.strokeRoundedWrench',
        description: 'Repairs, servicing, tires.',
      ),
    ],
  ),
  CategoryModel(
    id: 3,
    title: 'Housing',
    iconName: 'HugeIcons.strokeRoundedHome02', // Example icon name
    description: 'Rent, mortgage, utilities, home maintenance.',
    subCategories: [
      CategoryModel(
        id: 301,
        parentId: 3,
        title: 'Rent/Mortgage',
        iconName: 'HugeIcons.strokeRoundedBuilding01',
        description: 'Monthly rent or mortgage payments.',
      ),
      CategoryModel(
        id: 302,
        parentId: 3,
        title: 'Property Taxes',
        iconName: 'HugeIcons.strokeRoundedDocument01',
        description: 'Annual or periodic property taxes.',
      ),
      CategoryModel(
        id: 303,
        parentId: 3,
        title: 'Home Insurance',
        iconName: 'HugeIcons.strokeRoundedShield01',
        description: 'Insurance for your home or contents.',
      ),
      CategoryModel(
        id: 304,
        parentId: 3,
        title: 'Furniture & Decor',
        iconName: 'HugeIcons.strokeRoundedSofa',
        description: 'New furniture, home decorations.',
      ),
    ],
  ),
  CategoryModel(
    id: 4,
    title: 'Shopping',
    iconName: 'HugeIcons.strokeRoundedShoppingBag01', // Example icon name
    description: 'Purchases for clothing, electronics, gifts, etc.',
    subCategories: [
      CategoryModel(
        id: 401,
        parentId: 4,
        title: 'Clothing & Accessories',
        iconName: 'HugeIcons.strokeRoundedTShirt',
        description: 'Clothes, shoes, jewelry, bags.',
      ),
      CategoryModel(
        id: 402,
        parentId: 4,
        title: 'Electronics',
        iconName: 'HugeIcons.strokeRoundedSmartphone01',
        description: 'Gadgets, computers, appliances.',
      ),
      CategoryModel(
        id: 403,
        parentId: 4,
        title: 'Hobbies & Leisure',
        iconName: 'HugeIcons.strokeRoundedJoystick01',
        description: 'Items for hobbies, sports equipment.',
      ),
    ],
  ),
  CategoryModel(
    id: 5,
    title: 'Entertainment',
    iconName: 'HugeIcons.strokeRoundedCinema', // Example icon name
    description: 'Movies, concerts, hobbies, subscriptions.',
    subCategories: [
      CategoryModel(
        id: 501,
        parentId: 5,
        title: 'Movies & Theatre',
        iconName: 'HugeIcons.strokeRoundedTicket01',
        description: 'Cinema tickets, theatre shows.',
      ),
      CategoryModel(
        id: 502,
        parentId: 5,
        title: 'Concerts & Events',
        iconName: 'HugeIcons.strokeRoundedMusicNote01',
        description: 'Live music, festivals, sports events.',
      ),
      CategoryModel(
        id: 503,
        parentId: 5,
        title: 'Streaming Services',
        iconName: 'HugeIcons.strokeRoundedTv01',
        description: 'Netflix, Spotify, etc.',
      ),
      CategoryModel(
        id: 504,
        parentId: 5,
        title: 'Games & Apps',
        iconName: 'HugeIcons.strokeRoundedGamepad01',
        description: 'Video games, mobile apps, in-app purchases.',
      ),
    ],
  ),
  CategoryModel(
    id: 6,
    title: 'Health & Wellness',
    iconName: 'HugeIcons.strokeRoundedMedicalCrossCircle', // Example icon name
    description: 'Doctor visits, medication, gym, etc.',
    subCategories: [
      CategoryModel(
        id: 601,
        parentId: 6,
        title: 'Doctor & Dentist',
        iconName: 'HugeIcons.strokeRoundedStethoscope',
        description: 'Consultations, check-ups.',
      ),
      CategoryModel(
        id: 602,
        parentId: 6,
        title: 'Pharmacy & Medication',
        iconName: 'HugeIcons.strokeRoundedPill',
        description: 'Prescriptions, over-the-counter drugs.',
      ),
      CategoryModel(
        id: 603,
        parentId: 6,
        title: 'Gym & Fitness',
        iconName: 'HugeIcons.strokeRoundedDumbbell',
        description: 'Gym memberships, fitness classes.',
      ),
    ],
  ),
  CategoryModel(
    id: 7,
    title: 'Utilities',
    iconName: 'HugeIcons.strokeRoundedLightbulb02', // Example icon name
    description: 'Electricity, water, gas, internet, phone bills.',
    subCategories: [
      CategoryModel(
        id: 701,
        parentId: 7,
        title: 'Electricity',
        iconName: 'HugeIcons.strokeRoundedFlash',
      ),
      CategoryModel(
        id: 702,
        parentId: 7,
        title: 'Water',
        iconName: 'HugeIcons.strokeRoundedDrop',
      ),
      CategoryModel(
        id: 703,
        parentId: 7,
        title: 'Gas',
        iconName: 'HugeIcons.strokeRoundedFire',
      ),
      CategoryModel(
        id: 704,
        parentId: 7,
        title: 'Internet & Cable',
        iconName: 'HugeIcons.strokeRoundedWifi',
      ),
      CategoryModel(
        id: 705,
        parentId: 7,
        title: 'Mobile Phone',
        iconName: 'HugeIcons.strokeRoundedSmartphone02',
      ),
    ],
  ),
  CategoryModel(
    id: 8,
    title: 'Personal Care',
    iconName: 'HugeIcons.strokeRoundedUser',
    description: 'Haircuts, toiletries, cosmetics.',
    subCategories: [
      CategoryModel(
        id: 801,
        parentId: 8,
        title: 'Haircuts & Styling',
        iconName: 'HugeIcons.strokeRoundedScissors',
      ),
      CategoryModel(
        id: 802,
        parentId: 8,
        title: 'Toiletries',
        iconName: 'HugeIcons.strokeRoundedToothbrush',
      ),
      CategoryModel(
        id: 803,
        parentId: 8,
        title: 'Cosmetics & Skincare',
        iconName: 'HugeIcons.strokeRoundedLipstick',
      ),
    ],
  ),
  CategoryModel(
    id: 9,
    title: 'Education',
    iconName: 'HugeIcons.strokeRoundedBook', // Example icon name
    description: 'Tuition, books, courses.',
    subCategories: [
      CategoryModel(
        id: 901,
        parentId: 9,
        title: 'Tuition & Fees',
        iconName: 'HugeIcons.strokeRoundedEducation',
      ),
      CategoryModel(
        id: 902,
        parentId: 9,
        title: 'Books & Supplies',
        iconName: 'HugeIcons.strokeRoundedNotebook',
      ),
      CategoryModel(
        id: 903,
        parentId: 9,
        title: 'Online Courses',
        iconName: 'HugeIcons.strokeRoundedLaptop01',
      ),
    ],
  ),
  CategoryModel(
    id: 10,
    title: 'Gifts & Donations',
    iconName: 'HugeIcons.strokeRoundedGift', // Example icon name
    description: 'Presents for others, charitable contributions.',
    subCategories: [
      CategoryModel(
        id: 1001,
        parentId: 10,
        title: 'Gifts Given',
        iconName: 'HugeIcons.strokeRoundedConfetti',
      ),
      CategoryModel(
        id: 1002,
        parentId: 10,
        title: 'Charitable Donations',
        iconName: 'HugeIcons.strokeRoundedFavourite',
      ),
    ],
  ),
  CategoryModel(
    id: 11,
    title: 'Travel',
    iconName: 'HugeIcons.strokeRoundedPlane', // Example icon name
    description: 'Flights, hotels, vacation expenses.',
    subCategories: [
      CategoryModel(
        id: 1101,
        parentId: 11,
        title: 'Flights & Trains',
        iconName: 'HugeIcons.strokeRoundedDirection01',
      ),
      CategoryModel(
        id: 1102,
        parentId: 11,
        title: 'Accommodation',
        iconName: 'HugeIcons.strokeRoundedHotelBed',
      ),
      CategoryModel(
        id: 1103,
        parentId: 11,
        title: 'Activities & Tours',
        iconName: 'HugeIcons.strokeRoundedMap01',
      ),
    ],
  ),
  CategoryModel(
    id: 12,
    title: 'Kids',
    iconName: 'HugeIcons.strokeRoundedBaby', // Example icon name
    description: 'Childcare, toys, school supplies for children.',
    subCategories: [
      CategoryModel(
        id: 1201,
        parentId: 12,
        title: 'Childcare',
        iconName: 'HugeIcons.strokeRoundedUserGroup',
      ),
      CategoryModel(
        id: 1202,
        parentId: 12,
        title: 'Toys & Games',
        iconName: 'HugeIcons.strokeRoundedPuzzle',
      ),
      CategoryModel(
        id: 1203,
        parentId: 12,
        title: 'School & Supplies',
        iconName: 'HugeIcons.strokeRoundedBackpack',
      ),
    ],
  ),
  CategoryModel(
    id: 13,
    title: 'Pets',
    iconName: 'HugeIcons.strokeRoundedPaw', // Example icon name
    description: 'Pet food, vet visits, pet supplies.',
    subCategories: [
      CategoryModel(
        id: 1301,
        parentId: 13,
        title: 'Pet Food',
        iconName: 'HugeIcons.strokeRoundedBowl',
      ),
      CategoryModel(
        id: 1302,
        parentId: 13,
        title: 'Vet & Medical',
        iconName: 'HugeIcons.strokeRoundedMedicalFile01',
      ),
      CategoryModel(
        id: 1303,
        parentId: 13,
        title: 'Toys & Accessories',
        iconName: 'HugeIcons.strokeRoundedDog',
      ),
    ],
  ),
  CategoryModel(
    id: 14,
    title: 'Business Expenses',
    iconName: 'HugeIcons.strokeRoundedBriefcase01', // Example icon name
    description: 'Work-related expenses, office supplies.',
    subCategories: [
      CategoryModel(
        id: 1401,
        parentId: 14,
        title: 'Office Supplies',
        iconName: 'HugeIcons.strokeRoundedPen',
      ),
      CategoryModel(
        id: 1402,
        parentId: 14,
        title: 'Software & Subscriptions',
        iconName: 'HugeIcons.strokeRoundedCloudSoftware',
      ),
      CategoryModel(
        id: 1403,
        parentId: 14,
        title: 'Business Travel',
        iconName: 'HugeIcons.strokeRoundedSuitcase',
      ),
    ],
  ),
  CategoryModel(
    id: 15,
    title: 'Investments',
    iconName: 'HugeIcons.strokeRoundedChartCandlestick', // Example icon name
    description: 'Stocks, bonds, mutual funds.',
    subCategories: [
      CategoryModel(
        id: 1501,
        parentId: 15,
        title: 'Stocks',
        iconName: 'HugeIcons.strokeRoundedChartTrendingUp01',
      ),
      CategoryModel(
        id: 1502,
        parentId: 15,
        title: 'Bonds',
        iconName: 'HugeIcons.strokeRoundedDocumentCertificate',
      ),
      CategoryModel(
        id: 1503,
        parentId: 15,
        title: 'Mutual Funds',
        iconName: 'HugeIcons.strokeRoundedChartPie01',
      ),
    ],
  ),
  CategoryModel(
    id: 16,
    title: 'Savings',
    iconName: 'HugeIcons.strokeRoundedBank', // Example icon name
    description: 'Contributions to savings accounts.',
    subCategories: [
      CategoryModel(
        id: 1601,
        parentId: 16,
        title: 'Emergency Fund',
        iconName: 'HugeIcons.strokeRoundedLifebuoy',
      ),
      CategoryModel(
        id: 1602,
        parentId: 16,
        title: 'Retirement Fund',
        iconName: 'HugeIcons.strokeRoundedUmbrella',
      ),
      CategoryModel(
        id: 1603,
        parentId: 16,
        title: 'General Savings',
        iconName: 'HugeIcons.strokeRoundedPiggyBank01',
      ),
    ],
  ),
  CategoryModel(
    id: 17, // Typically income is handled differently, but can be a category
    title: 'Income',
    iconName: 'HugeIcons.strokeRoundedReceiveDollars', // Example icon name
    description: 'Salary, wages, freelance income.',
    subCategories: [
      CategoryModel(
        id: 1701,
        parentId: 17,
        title: 'Salary/Wages',
        iconName: 'HugeIcons.strokeRoundedDollar',
      ),
      CategoryModel(
        id: 1702,
        parentId: 17,
        title: 'Freelance/Consulting',
        iconName: 'HugeIcons.strokeRoundedBriefcase02',
      ),
      CategoryModel(
        id: 1703,
        parentId: 17,
        title: 'Investment Income',
        iconName: 'HugeIcons.strokeRoundedChartBar02',
      ),
      CategoryModel(
        id: 1704,
        parentId: 17,
        title: 'Bonuses',
        iconName: 'HugeIcons.strokeRoundedAward01',
      ),
    ],
  ),
  CategoryModel(
    id: 18,
    title: 'Miscellaneous',
    iconName: 'HugeIcons.strokeRoundedGridSmall', // Example icon name
    description: 'Other uncategorized expenses.',
    subCategories: [
      CategoryModel(
        id: 1801,
        parentId: 18,
        title: 'Bank Fees',
        iconName: 'HugeIcons.strokeRoundedCreditCard01',
      ),
      CategoryModel(
        id: 1802,
        parentId: 18,
        title: 'Taxes (Other)',
        iconName: 'HugeIcons.strokeRoundedCalculator',
      ),
      CategoryModel(
        id: 1803,
        parentId: 18,
        title: 'Other Expenses',
        iconName: 'HugeIcons.strokeRoundedMore01',
      ),
    ],
  ),
];

extension CategoriesExtension on List<CategoryModel> {
  /// Returns a flat list of all categories, including sub-categories.
  List<CategoryModel> getAllCategories() {
    final List<CategoryModel> allCategories = [];
    // Helper function to recursively add categories
    void addCategoriesRecursively(List<CategoryModel>? categoryList) {
      if (categoryList == null) return;
      for (final category in categoryList) {
        allCategories.add(category);
        if (category.hasSubCategories) {
          addCategoriesRecursively(category.subCategories);
        }
      }
    }

    addCategoriesRecursively(
      this,
    ); // 'this' refers to the list of top-level categories
    return allCategories;
  }
}
