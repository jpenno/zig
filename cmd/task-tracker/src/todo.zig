const std = @import("std");
const stdout = std.io.getStdOut().writer();
const loge = std.log.err;

pub const Todo = struct {
    const State = enum {
        Todo,
        In_progress,
        Done,
    };

    id: u32,
    description: []u8,
    state: State,
    created_at: []u8,
    updated_at: []u8,

    pub fn create(description: []u8) Todo {
        return Todo{
            .id = 1,
            .description = description,
            .state = .Todo,
            .created_at = "",
            .updated_at = "",
        };
    }

    pub fn print(self: Todo, allocator: std.mem.Allocator) void {
        var string = std.ArrayList(u8).init(allocator);
        defer string.deinit();

        std.json.stringify(self, .{ .whitespace = .indent_2 }, string.writer()) catch unreachable;

        stdout.print("{d}| {s} | {s}\n", .{ self.id, self.description, @tagName(self.state) }) catch unreachable;
        stdout.print("json: \n{s}", .{string.items}) catch unreachable;
    }
};
