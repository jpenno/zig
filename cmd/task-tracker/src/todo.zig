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

    pub fn create(allocator: std.mem.Allocator, description: []u8) Todo {
        return Todo{
            .id = 1,
            .description = allocator.dupe(u8, description) catch unreachable,
            .state = .Todo,
            .created_at = "",
            .updated_at = "",
        };
    }

    pub fn copy(allocator: std.mem.Allocator, todo: Todo) Todo {
        return Todo{
            .created_at = todo.created_at,
            .updated_at = todo.updated_at,
            .id = todo.id,
            .state = todo.state,
            .description = allocator.dupe(u8, todo.description) catch unreachable,
        };
    }

    pub fn deinit(self: Todo, allocator: std.mem.Allocator) void {
        allocator.free(self.description);
    }

    pub fn print(self: Todo, allocator: std.mem.Allocator) void {
        const string = store.makeJson(allocator, self);
        defer string.deinit();

        stdout.print(
            "{d: <2} | {s: <30} | {s}|\n",
            .{ self.id, self.description, @tagName(self.state) },
        ) catch |err| {
            std.log.err("error printing todo: {}", .{err});
        };
    }
};
