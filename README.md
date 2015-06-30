# Hubot Todo

A Hubot script that manages TODOs.

Functions supported: add,update,delete,show and help.

## Example
### todo add <task>

  add name -d desc -t time -c category -p priority -s status
  name and desc- mandatory, rest optional

![alt text](https://github.com/vishals79/hubot-todo/blob/master/etc/todo-add.jpg "todo add")

### todo update <task-number> <modified-task-desc>
![alt text](https://github.com/vishals79/hubot-todo/blob/master/etc/todo-update.jpg "todo update")

### todo delete <task-number>
![alt text](https://github.com/vishals79/hubot-todo/blob/master/etc/todo-delete.jpg "todo delete")

### todo show
![alt text](https://github.com/vishals79/hubot-todo/blob/master/etc/todo-show.jpg "todo show")

### todo help
![alt text](https://github.com/vishals79/hubot-todo/blob/master/etc/todo-help.jpg "todo help")

## Configuration
See [`src/scripts/todo.coffee`](src/scripts/todo.coffee).

## Work Flow

- Hubot Todo - A todo app to help users in task management. It provides facility to add, update, delete and show tasks.
  - How to install
  - Commands in use
    - Current
      - do (task-description)
        - A task will be added with description and default date (current date) and time (00:00) values.
      - modify (task-number) with (task-description)
        - update the description of the mentioned task-number.
      - set time (time in the format hh:mm) for (task number)
        - Modify the time for the mentioned task.
      - set date (date in the format DD-MM-YYYY) for (task number)
        - Modify the date for the mentioned task.
      - note (note-description) for (task number)
        - add note for the mentioned task.
      - remove (task number)
        - remove the mentioned task and all its subtasks.
      - list
        - display the list of tasks on chronological basis.
      - finish (task-number)
        -  mark the specified task as complete.
      - subtask (description) for (parent-task-number)
        -  add sub task for parent-task-number.
    - To be added
      - set date today/today+n for (task-number)
        - to provide user the feasibility to mark date using text. It will also handle arithmetic expression like today+1/2/3...
      - modify (task-number) with (task-description) @hh:mm 
        - update the task's description. Time is optional(format @hh:mm)
      - set default date DD-MM-YYYY|today+n
        - to set default date for task
      - set default time HH:MM
        - to set default time for task
      - organize the output of list command to display the results in tabular form.
      
  - Examples
