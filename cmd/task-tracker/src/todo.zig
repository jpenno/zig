const std = @import("std");
const loge = std.log.err;

const store = @import("store.zig");

const stdout = std.io.getStdOut().writer();
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
        const string = store.makeJson(allocator, self);
        defer string.deinit();

        stdout.print(
            "{d}| {s} | {s}\n",
            .{ self.id, self.description, @tagName(self.state) },
        ) catch |err| {
            std.log.err("error printing todo: {}", .{err});
        };
    }
};
