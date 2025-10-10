const std = @import("std");

const vec = @import("./math/vec.zig");
const Vec2F = vec.Vec2F;

const rl = @cImport({
    @cInclude("raylib.h");
});

pub const Player = struct {
    pos: Vec2F,
    size: Vec2F,
    velocity: Vec2F = Vec2F{ 0, 1 },
    gravity: f32 = 2500,
    jump_force: f32 = -600,
    score: u32 = 0,
    dead: bool = false,
    high_scores: [10]u32 = undefined,

    pub fn init(pos: vec.Vec2F) Player {
        return .{
            .pos = pos,
            .size = Vec2F{ 50, 50 },
        };
    }

    pub fn update(p: *Player, dt: f32) void {
        // movement
        if (rl.IsKeyPressed(rl.KEY_SPACE)) {
            p.velocity[1] = p.jump_force;
        }

        p.velocity[1] += p.gravity * dt;
        p.pos += vec.scaleF(p.velocity, dt);

        // collision
        if (p.pos[1] <= 0) {
            p.pos[1] = 0;
            p.velocity[1] = 0;
        }

        if (p.pos[1] + p.size[1] >= @as(f32, @floatFromInt(rl.GetScreenHeight()))) {
            p.pos[1] = @as(f32, @floatFromInt(rl.GetScreenHeight())) - p.size[1];
            p.velocity[1] = 0;
        }
    }

    pub fn draw(p: Player) void {
        rl.DrawRectangleV(rl.Vector2{
            .x = p.pos[0],
            .y = p.pos[1],
        }, rl.Vector2{
            .x = p.size[0],
            .y = p.size[1],
        }, rl.BLUE);
    }

    pub fn drawScore(p: Player) void {
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer std.debug.assert(gpa.deinit() == .ok);

        const text: []const u8 = std.fmt.allocPrint(allocator, "Score: {d}", .{p.score}) catch unreachable;
        defer allocator.free(text);

        const text_size = @divTrunc(rl.MeasureText(@ptrCast(text), 43), 2);

        rl.DrawText(@ptrCast(text), @divTrunc(rl.GetScreenWidth(), 2) - text_size, 25, 42, rl.WHITE);
    }

    // pub fn drawHighScores(p: Player) void {
    //     var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    //     const allocator = gpa.allocator();
    //     defer std.debug.assert(gpa.deinit() == .ok);
    //
    //     var text: []const u8 = std.fmt.allocPrint(allocator, "Score: {}", .{p.score}) catch unreachable;
    //
    //     var text_size = @divTrunc(rl.MeasureText(@ptrCast(text), 43), 2);
    //
    //     rl.DrawText(@ptrCast(text), @divTrunc(rl.GetScreenWidth(), 2) - text_size, 25, 42, rl.WHITE);
    //     allocator.free(text);
    //
    //     var text_y: i32 = 100;
    //     for (p.high_scores, 0..) |score, i| {
    //         text = std.fmt.allocPrint(allocator, "Score {d}: {d}", .{ i, score }) catch unreachable;
    //         defer allocator.free(text);
    //
    //         text_size = @divTrunc(rl.MeasureText(@ptrCast(text), 43), 2);
    //
    //         text_y += 42;
    //         rl.DrawText(@ptrCast(text), @divTrunc(rl.GetScreenWidth(), 2) - text_size, text_y, 42, rl.WHITE);
    //     }
    // }

    pub fn die(p: *Player) void {
        if (p.dead) return;

        p.dead = true;

        // const path = "./data/highscores.txt";
        //
        // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        // const allocator = gpa.allocator();
        // defer std.debug.assert(gpa.deinit() == .ok);
        //
        // const file = std.fs.cwd().openFile(path, .{}) catch |err| {
        //     std.log.err("Failed to open file: {s}", .{@errorName(err)});
        //     return;
        // };
        // defer file.close();

        // var i: usize = 0;
        // while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize)) catch |err| {
        //     std.log.err("Failed to read line: {s}", .{@errorName(err)});
        //     return;
        // }) |line| : (i += 1) {
        //     defer allocator.free(line);
        //     p.high_scores[i] = std.fmt.parseInt(u32, line, 10) catch unreachable;
        // }
        //
        // std.mem.sort(u32, &p.high_scores, {}, comptime std.sort.desc(u32));
        //
        // p.high_scores = insertScore(p.high_scores, p.score);
        //
        // // Open the file for writing
        // const out_file = std.fs.cwd().createFile(path, .{}) catch unreachable;
        // defer out_file.close();
        //
        // var data = std.ArrayList(u8).init(allocator);
        // defer data.deinit();
        //
        // for (p.high_scores) |high_score| {
        //     var buf: [10]u8 = undefined;
        //     const numAsString = std.fmt.bufPrint(&buf, "{}\n", .{high_score}) catch unreachable;
        //     data.appendSlice(numAsString[0..]) catch unreachable;
        // }
        //
        // // Write the data to the file
        // out_file.writeAll(data.items) catch unreachable;
    }
};

// fn insertScore(highScores: [10]u32, score: u32) [10]u32 {
//     var result = [_]u32{0} ** 10;
//
//     for (highScores, 0..) |highScore, j| {
//         if (score > highScore) {
//             result[j] = score;
//             const tmp_slice = highScores[j..9];
//
//             for (tmp_slice, 0..) |ts, k| {
//                 result[j + 1 + k] = ts;
//             }
//             break;
//         }
//         result[j] = highScore;
//     }
//     return result;
// }

// test "insertScore" {
//     const highScores = [10]u32{ 100, 80, 70, 65, 64, 40, 35, 33, 20, 0 };
//     const want = [10]u32{ 100, 80, 76, 70, 65, 64, 40, 35, 33, 20 };
//     const score = 76;
//
//     const result = insertScore(highScores, score);
//
//     try std.testing.expectEqual(want, result);
// }
