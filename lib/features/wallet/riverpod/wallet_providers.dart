import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pockaw/features/wallet/data/model/wallet_model.dart';
import 'package:pockaw/features/wallet/data/repositories/wallet_repo.dart';

final walletProvider = Provider<WalletModel>((ref) {
  return wallets.first;
});
