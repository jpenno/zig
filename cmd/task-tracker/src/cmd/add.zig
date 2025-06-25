const std = @import("std");
const App = @import("../app.zig").App;
const Todo = @import("../todo.zig").Todo;

const stdout = std.io.getStdOut().writer();

pub fn add(allocator: std.mem.Allocator, args: ?[][:0]u8) Todo {
    if (args) |a| {
        return Todo.create(allocator, a[1]);
    } else {
        stdout.print("No argument for add", .{}) catch |err| {
            std.log.err("pirnt error: {}", .{err});
        };
    }
    return Todo.create(allocator, "");
}

test "insertScore" {
    //TODO: write test for add cmd
    const highScores = [10]u32{ 100, 80, 70, 65, 64, 40, 35, 33, 20, 0 };
    const want = [10]u32{ 100, 80, 76, 70, 65, 64, 40, 35, 33, 20 };

    try std.testing.expectEqual(want, highScores);
}
