import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/address_model.dart';
import 'package:uuid/uuid.dart';
import 'package:state_notifier/state_notifier.dart';



final savedAddressesProvider =
StateNotifierProvider<AddressController, List<AddressModel>>((ref) {
  return AddressController();
});

class AddressController extends StateNotifier<List<AddressModel>> {
  AddressController() : super([]);

  final _uuid = const Uuid();

  void addAddress({required String label, required String address, required double lat, required double lng}) {
    final model = AddressModel(
      id: _uuid.v4(),
      label: label,
      address: address,
      lat: lat,
      lng: lng,
    );
    state = [...state, model];
  }

  void updateAddress(AddressModel updated) {
    state = state.map((a) => a.id == updated.id ? updated : a).toList();
  }

  void removeAddress(String id) {
    state = state.where((a) => a.id != id).toList();
  }

  void setDefault(String id) {
    final idx = state.indexWhere((a) => a.id == id);
    if (idx == -1) return;
    final chosen = state[idx];
    final rest = state.where((a) => a.id != id).toList();
    // put chosen first
    state = [chosen, ...rest];
  }
}
