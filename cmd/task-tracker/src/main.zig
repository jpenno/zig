const std = @import("std");

const store = @import("store.zig");
const App = @import("app.zig").App;
const Todo = @import("todo.zig").Todo;

const Commands = enum {
    add,
    delete,
    list,
    invalid_command,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const path = "./data/todos.json";

    var app = try App.init(allocator, path);
    defer app.deinit(allocator);

    const args = std.process.argsAlloc(allocator) catch |err| {
        std.log.err("err processing args: {}", .{err});
        return;
    };
    defer std.process.argsFree(allocator, args);

    if (args.len <= 1) {
        std.log.err("no argument", .{});
        return;
    }

    const command = std.meta.stringToEnum(Commands, args[1]) orelse .invalid_command;

    switch (command) {
        .add => {
            if (args.len > 2) {
                try app.todos.append(Todo.create(args[2]));
                const string = store.makeJson(allocator, app.todos.items);
                defer string.deinit();
                store.save(string.items, path);
            } else {
                std.log.err("no task to add", .{});
            }
        },
        .delete => {
            std.log.err("Not implemented: \"{s}\"", .{args[1]});
        },
        .list => {
            const stdout = std.io.getStdOut().writer();
            stdout.print("Id| todo | state\n", .{}) catch unreachable;
            for (app.todos.items) |todo| {
                todo.print(allocator);
            }
        },
        .invalid_command => {
            std.log.err("inavlid command: \"{s}\"", .{args[1]});
        },
    }
}
