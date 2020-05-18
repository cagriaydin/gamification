import 'package:mysql1/mysql1.dart';
import 'package:yorglass_ik/models/task.dart';
import 'package:yorglass_ik/models/user-task.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/services/db-connection.dart';

class TaskRepository {
  static final TaskRepository _instance = TaskRepository._privateConstructor();

  TaskRepository._privateConstructor();

  static TaskRepository get instance => _instance;

  Future<List<UserTask>> getUserTasks() async {
    Results res = await DbConnection.query("SELECT * FROM task WHERE active = 1");
    List<Task> taskList = [];
    if (res.length > 0) {
      res.forEach((element) {
        taskList.add(
          Task(
            id: element[0],
            name: element[1],
            point: element[2],
            interval: element[3],
            count: element[4],
            renewableTime: element[5],
          ),
        );
      });
    }

    Results userTasks = await DbConnection.query(
      "SELECT * FROM usertask WHERE userid = ? AND (lastupdate, taskid) IN (SELECT MAX(lastupdate), taskid FROM usertask WHERE userid = ? GROUP BY taskid)",
      [
        AuthenticationService.verifiedUser.id,
        AuthenticationService.verifiedUser.id,
      ],
    );
    List<UserTask> userTaskList = [];
    if (userTasks.length > 0) {
      userTasks.forEach((element) {
        userTaskList.add(
          UserTask(
            id: element[0],
            taskId: element[1],
            userId: element[2],
            lastUpdate: element[3],
            nextActive: element[4],
            nextdeadline: element[5],
            count: element[6],
            complete: element[7],
            point: element[8],
          ),
        );
      });
    }

    taskList.forEach((task) {
      List<UserTask> tasks = userTaskList.where((userTask) => userTask.taskId == task.id);
      if (tasks.length > 0) {
        UserTask userTask = tasks.first;
        userTask.task = task;
        if (userTask.complete == 1) {
          if (task.interval == null) {
            userTaskList.remove(userTask);
            createNewUserTask(task, userTaskList);
          } else {
            DateTime startTime;
            if (task.interval == 1) {
              startTime = _getBeginingOfDay(DateTime.now());
            } else if (task.interval == 2) {
              startTime = _getBeginingOfWeek(DateTime.now());
            } else if (task.interval == 3) {
              startTime = _getBeginingOfMonth(DateTime.now());
            }
            if (userTask.lastUpdate.compareTo(startTime) < 0) {
              userTaskList.remove(userTask);
              createNewUserTask(task, userTaskList);
            }
          }
        } else {
          if (userTask.nextdeadline.compareTo(DateTime.now()) < 0) {
            userTaskList.remove(userTask);
            createNewUserTask(task, userTaskList);
          }
        }
      } else {
        createNewUserTask(task, userTaskList);
      }
    });
    return userTaskList;
  }

  void createNewUserTask(Task task, List<UserTask> userTaskList) {
    DateTime nextActive;
    DateTime nextDeadline;
    if (task.interval == 1) {
      nextActive = _getBeginingOfDay(DateTime.now());
      nextDeadline = _getEndOfDay(DateTime.now());
    } else if (task.interval == 2) {
      nextActive = _getBeginingOfWeek(DateTime.now());
      nextDeadline = _getEndOfWeek(DateTime.now());
    } else if (task.interval == 3) {
      nextActive = _getBeginingOfMonth(DateTime.now());
      nextDeadline = _getEndOfMonth(DateTime.now());
    } else {}
    userTaskList.add(
      UserTask(
        taskId: task.id,
        userId: AuthenticationService.verifiedUser.id,
        count: 0,
        point: task.point,
        complete: 0,
        nextActive: nextActive,
        nextdeadline: nextDeadline,
        task: task,
      ),
    );
  }

  bool canUpdate(UserTask userTask) {
    if (userTask.complete == 1) {
      return false;
    } else {
      if (userTask.nextActive != null && userTask.nextActive.compareTo(DateTime.now()) > 0) {
        return false;
      }
      if (userTask.nextdeadline != null && userTask.nextdeadline.compareTo(DateTime.now()) < 0) {
        return false;
      }
    }
    return true;
  }

  updateUserTask(UserTask task) {
    if (canUpdate(task)) {
      task.count = task.count + 1;
    } else {
      return -1;
    }
  }

  DateTime _getBeginingOfDay(DateTime date) {
    return new DateTime(date.year, date.month, date.day);
  }

  DateTime _getEndOfDay(DateTime date) {
    return _getBeginingOfDay(date).add(new Duration(days: 1)).subtract(new Duration(milliseconds: 1));
  }

  DateTime _getBeginingOfWeek(DateTime date) {
    date = _getBeginingOfDay(date);
    return date.subtract(new Duration(days: date.weekday));
  }

  DateTime _getEndOfWeek(DateTime date) {
    date = _getBeginingOfDay(date);
    return date.add(new Duration(days: 7 - date.weekday)).subtract(new Duration(milliseconds: 1));
  }

  DateTime _getBeginingOfMonth(DateTime date) {
    return new DateTime(date.year, date.month, 1);
  }

  DateTime _getEndOfMonth(DateTime date) {
    int year = date.year;
    int month = date.month;
    if (month == 12) {
      month = 1;
      year++;
    } else {
      month++;
    }
    return new DateTime(year, month, 1).subtract(new Duration(milliseconds: 1));
  }
}
