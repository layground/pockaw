import 'package:pockaw/features/wallet/data/model/wallet_model.dart';

List<WalletModel> wallets = [
  WalletModel(
    id: 1,
    name: 'Primary Checking',
    balance: 1250.75,
    currency: 'USD',
    iconName: 'HugeIcons.strokeRoundedBank', // Example icon name
    colorHex: 'FF4CAF50', // Green
  ),
  WalletModel(
    id: 2,
    name: 'Savings Account',
    balance: 5820.00,
    currency: 'USD',
    iconName: 'HugeIcons.strokeRoundedPiggyBank', // Example icon name
    colorHex: 'FF2196F3', // Blue
  ),
  WalletModel(
    id: 3,
    name: 'Naira Wallet',
    balance: 150000.00,
    currency: 'NGN',
    iconName: 'HugeIcons.strokeRoundedWallet02', // Example icon name
    colorHex: 'FFFF9800', // Orange
  ),
  WalletModel(
    id: 4,
    name: 'Vacation Fund',
    balance: 750.50,
    currency: 'EUR',
    colorHex: 'FF9C27B0', // Purple
  ),
];
