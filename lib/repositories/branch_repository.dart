import 'package:yorglass_ik/models/branch.dart';
import 'package:yorglass_ik/models/branch_leader_board.dart';
import 'package:yorglass_ik/services/authentication-service.dart';

class BranchRepository {
  static final BranchRepository _instance =
      BranchRepository._privateConstructor();

  BranchRepository._privateConstructor();

  static BranchRepository get instance => _instance;

  List<BranchLeaderBoard> getBoardPointList() {
    List<BranchLeaderBoard> list = List<BranchLeaderBoard>();
    list.add(BranchLeaderBoard(id: "1", branchId: "1", point: 150));
    list.add(BranchLeaderBoard(id: "2", branchId: "2", point: 300));
    list.add(BranchLeaderBoard(id: "3", branchId: "3", point: 250));
    list.add(BranchLeaderBoard(id: "4", branchId: "4", point: 110));
    list.add(BranchLeaderBoard(id: "5", branchId: "5", point: 140));
    list.add(BranchLeaderBoard(id: "6", branchId: "6", point: 145));
    list.sort((a, b) => b.point.compareTo(a.point));
    return list;
  }

  List<Branch> getBranchList() {
    List<Branch> list = List<Branch>();
    list.add(Branch(id: "1", name: "Manisa", employeeCount: 150, point: 150, image: AuthenticationService.verifiedUser.image));
    list.add(Branch(id: "2", name: "Gebze", employeeCount: 120, point:300, image: AuthenticationService.verifiedUser.image));
    list.add(Branch(id: "3", name: "Eskişehir", employeeCount: 130, point: 250, image: AuthenticationService.verifiedUser.image));
    list.add(Branch(id: "4", name: "Kemal Paşa", employeeCount: 110, point:110, image: AuthenticationService.verifiedUser.image));
    list.add(Branch(id: "5", name: "Bolu", employeeCount: 180, point: 140, image: AuthenticationService.verifiedUser.image));
    list.add(Branch(id: "6", name: "Ataşehir", employeeCount: 145, image: AuthenticationService.verifiedUser.image));
    return list;
  }

  List<Branch> getTopBranchPointList(){
    var branchList = new List<Branch>();
    var branchPointList = getBoardPointList().take(3).toList();
    for (var branch in branchPointList) {
      branchList.add(getBranch(branch.id));
    }
    return branchList;
  }

  Branch getBranch(String id){
    return getBranchList().singleWhere((element) => element.id == id);
  }
}
