const std = @import("std");

const Store = @import("store.zig");
const Todo = @import("todo.zig").Todo;

pub const App = struct {
    todos: std.ArrayList(Todo),

    pub fn init(allocator: std.mem.Allocator, path: []const u8) !App {
        var todos_array_list = std.ArrayList(Todo).init(allocator);

        const todos_string = Store.load(allocator, path);
        defer allocator.free(todos_string);

        if (Store.makeStructArrayFromJson(Todo, allocator, todos_string)) |tmp| {
            defer tmp.deinit();

            for (tmp.value) |value| {
                try todos_array_list.append(Todo.copy(allocator, value));
            }
        }

        return App{
            .todos = todos_array_list,
        };
    }

    pub fn deinit(self: *App, allocator: std.mem.Allocator) void {
        for (self.todos.items) |todo| {
            todo.deinit(allocator);
        }
        self.todos.deinit();
    }
};
