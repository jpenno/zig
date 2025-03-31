const std = @import("std");

const Commands = enum {
    add,
    delete,
    invalid_command,
};

pub fn main() !void {
    // Get allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // Parse args into string array (error union needs 'try')
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    // Get and print them!
    std.debug.print("There are {d} args:\n", .{args.len});

    const command = std.meta.stringToEnum(Commands, args[1]) orelse .invalid_command;

    switch (command) {
        .add => {
            if (args.len > 2) {
                std.log.info("add task: {s}", .{args[2]});
            }
        },
        .delete => {},
        .invalid_command => {
            std.log.err("inavlid command: {s}", .{args[1]});
        },
    }
}
