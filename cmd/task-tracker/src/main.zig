const std = @import("std");

const Todo = @import("todo.zig").Todo;

const Commands = enum {
    add,
    delete,
    invalid_command,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len <= 1) {
        std.log.err("no argument", .{});
        return;
    }

    const command = std.meta.stringToEnum(Commands, args[1]) orelse .invalid_command;

    var todos = std.ArrayList(Todo).init(allocator);
    defer todos.deinit();

    switch (command) {
        .add => {
            if (args.len > 2) {
                try todos.append(Todo.create(args[2]));
            } else {
                std.log.err("no task to add", .{});
            }
        },
        .delete => {},
        .invalid_command => {
            std.log.err("inavlid command: {s}", .{args[1]});
        },
    }

    const stdout = std.io.getStdOut().writer();
    stdout.print("Id| todo\n", .{}) catch unreachable;
    if (todos.items.len >= 1) {
        for (todos.items) |todo| {
            todo.print(allocator);
        }
    }
}
