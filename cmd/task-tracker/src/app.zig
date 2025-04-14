const std = @import("std");

const Store = @import("store.zig");
const Todo = @import("todo.zig").Todo;

const stdout = std.io.getStdOut().writer();

pub const App = struct {
    todos: std.ArrayList(Todo),
    path: []const u8,

    pub fn init(allocator: std.mem.Allocator, path: []const u8) !App {
        var todos_array_list = std.ArrayList(Todo).init(allocator);

        if (Store.load(allocator, path)) |todos_string| {
            defer allocator.free(todos_string);

            if (Store.makeStructArrayFromJson(Todo, allocator, todos_string)) |tmp| {
                defer tmp.deinit();
                try todos_array_list.ensureTotalCapacity(tmp.value.len);

                for (tmp.value) |value| {
                    todos_array_list.appendAssumeCapacity(Todo.copy(allocator, value));
                }
            }
        } else |err| {
            if (err == std.fs.File.OpenError.FileNotFound) {
                stdout.print(
                    "File not found: {s}\n",
                    .{path},
                ) catch |print_err| {
                    std.log.err("error printing: {}", .{print_err});
                };
            }
        }

        return App{
            .todos = todos_array_list,
            .path = path,
        };
    }

    pub fn deinit(self: *App, allocator: std.mem.Allocator) void {
        for (self.todos.items) |todo| todo.deinit(allocator);
        self.todos.deinit();
    }

    pub fn saveTodos(self: *App, allocator: std.mem.Allocator, path: []const u8) void {
        for (self.todos.items, 1..) |*todo, i| {
            todo.id = @intCast(i);
        }

        const string = Store.makeJson(allocator, self.todos.items);
        defer string.deinit();
        Store.save(string.items, path);
    }
};
