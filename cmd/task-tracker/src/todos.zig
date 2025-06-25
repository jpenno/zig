const std = @import("std");
const Todo = @import("todo.zig").Todo;

pub fn printTodos(todos: []Todo, state: ?Todo.State) void {
    for (todos) |todo| {
        if (state) |s| {
            if (s == todo.state) {
                todo.print();
            }
        } else {
            todo.print();
        }
        // if (state == null) {
        //     todo.print();
        // } else if (todo.state == state) {
        //     todo.print();
        // }
    }
}

pub fn add(todos: std.ArrayList(Todo), todo: Todo) void {
    todos.append(todo) catch unreachable;
}
