const std = @import("std");

const store = @import("store.zig");
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

    const path = "./data/todos.json";

    const todos_string = store.load(allocator, path);
    defer allocator.free(todos_string);

    var todos = std.ArrayList(Todo).init(allocator);
    defer todos.deinit();

    const todos_from_json = if (store.makeStructArrayFromJson(Todo, allocator, todos_string)) |tmp|
        tmp
    else
        unreachable;
    defer todos_from_json.deinit();

    try todos.appendSlice(todos_from_json.value);

    switch (command) {
        .add => {
            if (args.len > 2) {
                try todos.append(Todo.create(args[2]));
                const string = store.makeJson(allocator, todos.items);
                defer string.deinit();
                store.save(string.items, path);
            } else {
                std.log.err("no task to add", .{});
            }
        },
        .delete => {
            std.log.err("Not implemented: \"{s}\"", .{args[1]});
            return;
        },
        .list => {
            const stdout = std.io.getStdOut().writer();
            stdout.print("Id| todo | state\n", .{}) catch unreachable;
            for (todos.items) |todo| {
                todo.print(allocator);
            }
            return;
        },
        .invalid_command => {
            std.log.err("inavlid command: \"{s}\"", .{args[1]});
            return;
        },
    }
}
