import 'dart:async';

import 'package:mysql1/mysql1.dart';
import 'package:uuid/uuid.dart';
import 'package:yorglass_ik/models/task.dart';
import 'package:yorglass_ik/models/user-task.dart';
import 'package:yorglass_ik/services/authentication-service.dart';
import 'package:yorglass_ik/services/db-connection.dart';

forEach(Iterable list, Function(dynamic) function) {
  for (var element in list) {
    function(element);
  }
}

class TaskRepository {
  static final TaskRepository _instance = TaskRepository._privateConstructor();

  TaskRepository._privateConstructor();

  static TaskRepository get instance => _instance;

  StreamController<List<UserTask>> _currentTasks = StreamController.broadcast();

  Stream get currentUserTasks => _currentTasks.stream;

  Future<List<UserTask>> getUserTasks() async {
    Results res =
    await DbConnection.query("SELECT * FROM task WHERE active = 1");
    List<Task> taskList = [];
    if (res.length > 0) {
      forEach(res, (element) {
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
      forEach(userTasks, (element) {
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
        userTaskList.last.nextdeadline =
            userTaskList.last.nextdeadline.toLocal();
        userTaskList.last.lastUpdate = userTaskList.last.lastUpdate.toLocal();
        userTaskList.last.nextActive = userTaskList.last.nextActive.toLocal();
      });
    }

    forEach(taskList, (task) {
      List<UserTask> tasks = userTaskList.where((userTask) {
        return userTask.taskId == task.id;
      }).toList();
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
    _currentTasks.add(userTaskList);
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
      if (userTask.nextActive != null &&
          userTask.nextActive.compareTo(DateTime.now()) > 0) {
        return false;
      }
      if (userTask.nextdeadline != null &&
          userTask.nextdeadline.compareTo(DateTime.now()) < 0) {
        return false;
      }
    }
    return true;
  }

  Future<UserTask> updateUserTask(UserTask task) async {
    if (canUpdate(task)) {
      task.count = task.count + 1;
      if (task.count == task.task.count) {
        task.complete = 1;
        task.point = task.task.point;
      }
      task.lastUpdate = DateTime.now();
      if (task.task.renewableTime != null) {
        int days = task.task.renewableTime.toInt();
        int hours = 0;
        int minutes = 0;
        if (task.task.renewableTime > days) {
          double totalHours = 24 * (task.task.renewableTime - days);
          hours = totalHours.toInt();
          if (totalHours > hours) {
            double totalMins = 60 * (totalHours - hours);
            minutes = totalMins.toInt();
          }
        }
        DateTime next = calculateNextDate(minutes, hours, days, DateTime.now());
        DateTime nextDeadline = calculateNextDate(minutes, hours, days, next);
        task.nextActive = next;
        task.nextdeadline = nextDeadline;
      }
      return await _updateUserTaskData(task);
    } else {
      return task;
    }
  }

  Future<UserTask> _updateUserTaskData(UserTask task) async {
    Results res;
    if (task.id != null) {
      res = await DbConnection.query(
        "UPDATE usertask SET lastupdate = ?, nextactive = ?, nextdeadline = ?, count = ?, complete = ?, point = ? WHERE id = ?",
        [
          task.lastUpdate.toUtc(),
          task.nextActive.toUtc(),
          task.nextdeadline.toUtc(),
          task.count,
          task.complete,
          task.point,
          task.id,
        ],
      );
    } else {
      task.id = Uuid().v4();
      res = await DbConnection.query(
        "INSERT INTO usertask (id, taskid, userid, lastupdate, nextactive, nextdeadline, count, complete, point) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
          task.id,
          task.taskId,
          task.userId,
          task.lastUpdate.toUtc(),
          task.nextActive.toUtc(),
          task.nextdeadline.toUtc(),
          task.count,
          task.complete,
          task.point,
        ],
      );
    }
    if (res != null && res.affectedRows > 0) {
      if (task.complete == 1) {
        await DbConnection.query(
          "UPDATE leaderboard SET point = point + ? WHERE userid = ? AND enddate IS NULL",
          [
            task.point,
            AuthenticationService.verifiedUser.id,
          ],
        );
      }
    }
    await updateUserInfo();
    return task;
  }

  DateTime calculateNextDate(int minutes, int hours, int days, DateTime start) {
    if (minutes > 0 || hours > 0) {
      DateTime nextTime = start;
      if (days > 0) {
        nextTime = nextTime.add(new Duration(days: days));
      }
      if (hours > 0) {
        nextTime = nextTime.add(new Duration(hours: hours));
      }
      if (minutes > 0) {
        nextTime = nextTime.add(new Duration(minutes: minutes));
      }
      return nextTime;
    } else {
      DateTime nextTime = _getBeginingOfDay(start);
      nextTime = nextTime.add(new Duration(days: days));
      return nextTime;
    }
  }

  DateTime _getBeginingOfDay(DateTime date) {
    return new DateTime(date.year, date.month, date.day);
  }

  DateTime _getEndOfDay(DateTime date) {
    return _getBeginingOfDay(date)
        .add(new Duration(days: 1))
        .subtract(new Duration(milliseconds: 1));
  }

  DateTime _getBeginingOfWeek(DateTime date) {
    date = _getBeginingOfDay(date);
    return date.subtract(new Duration(days: date.weekday));
  }

  DateTime _getEndOfWeek(DateTime date) {
    date = _getBeginingOfDay(date);
    return date
        .add(new Duration(days: 7 - date.weekday))
        .subtract(new Duration(milliseconds: 1));
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

  Future updateUserInfo() async {
    Results res = await DbConnection.query(
        "SELECT * FROM leaderboard WHERE enddate IS NULL AND userid = ?",
        [AuthenticationService.verifiedUser.id]);
    if (res.length > 0) {
      AuthenticationService.verifiedUser.point = res.single[1];
    }
    List<UserTask> tasks = await TaskRepository.instance.getUserTasks();
    int count = 0;
    for (UserTask t in tasks) {
      if (!TaskRepository.instance.canUpdate(t)) count++;
    }
    AuthenticationService.verifiedUser.percentage =
        (count / tasks.length * 100).round();
    AuthenticationService.verifiedUser.taskCount = tasks.length - count;
  }
}
