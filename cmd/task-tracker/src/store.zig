const std = @import("std");

pub fn save(data: []const u8, path: []const u8) void {
    const out_file = std.fs.cwd().createFile(path, .{}) catch |err| {
        std.debug.print("Save file err: \"{}\"", .{err});
        return;
    };
    defer out_file.close();

    out_file.writeAll(data) catch |err| {
        std.debug.print("Save file err: \"{}\"", .{err});
    };
}

pub fn load(allocator: std.mem.Allocator, path: []const u8) []const u8 {
    const file = std.fs.cwd().openFile(path, .{}) catch |err| {
        std.log.err("Failed to open file: {s}", .{@errorName(err)});
        unreachable;
    };
    defer file.close();

    const data = file.reader().readAllAlloc(allocator, 1024) catch |err| {
        std.log.err("Failed to read file: {s}", .{@errorName(err)});
        unreachable;
    };

    return data;
}

pub fn makeJson(allocator: std.mem.Allocator, data: anytype) std.ArrayList(u8) {
    var string = std.ArrayList(u8).init(allocator);

    std.json.stringify(data, .{ .whitespace = .indent_2 }, string.writer()) catch |err| {
        std.log.err("error converting to JSON: {}", .{err});
        unreachable;
    };

    return string;
}

pub fn makeStructArrayFromJson(
    comptime T: type,
    allocator: std.mem.Allocator,
    data: []const u8,
) ?std.json.Parsed([]T) {
    if (data.len == 0) {
        std.log.err("No json to pass", .{});
        return null;
    }

    const todos = std.json.parseFromSlice(
        []T,
        allocator,
        data,
        .{ .allocate = .alloc_always },
    ) catch |err| {
        std.log.err("Pass json err: {}", .{err});
        return null;
    };

    return todos;
}
