import 'package:yorglass_ik/models/branch.dart';
import 'package:yorglass_ik/models/branch_leader_board.dart';

class BranchRepository {
  static final BranchRepository _instance =
      BranchRepository._privateConstructor();

  BranchRepository._privateConstructor();

  static BranchRepository get instance => _instance;

  List<BranchLeaderBoard> getBoardPointList() {
    List<BranchLeaderBoard> list = List<BranchLeaderBoard>();
    list.add(BranchLeaderBoard(id: "1", branchId: "1", point: 450));
    list.add(BranchLeaderBoard(id: "2", branchId: "2", point: 435));
    list.add(BranchLeaderBoard(id: "3", branchId: "3", point: 300));
    list.add(BranchLeaderBoard(id: "4", branchId: "4", point: 100));
    list.add(BranchLeaderBoard(id: "5", branchId: "5", point: 250));
    list.add(BranchLeaderBoard(id: "6", branchId: "6", point: 70));
    list.sort((a, b) => b.point.compareTo(a.point));
    return list;
    // return list.sort((a, b) => a.point.compareTo(b.point));
  }

  List<Branch> getBranchList() {
    List<Branch> list = List<Branch>();
    list.add(Branch(id: "1", name: "Manisa", employeeCount: 150));
    list.add(Branch(id: "2", name: "Gebze", employeeCount: 120));
    list.add(Branch(id: "3", name: "Eskişehir", employeeCount: 130));
    list.add(Branch(id: "4", name: "Kemal Paşa", employeeCount: 110));
    list.add(Branch(id: "5", name: "Bolu", employeeCount: 180));
    list.add(Branch(id: "6", name: "Ataşehir", employeeCount: 145));
    return list;
  }
}
