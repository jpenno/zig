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
        rl.DrawRectangleV(vec.RlVec(p.pos), vec.RlVec(p.size), rl.BLUE);
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

    pub fn die(p: *Player) void {
        if (p.dead) return;

        p.dead = true;

        std.debug.print("get high scores\n", .{});
        const path = "./data/highscores.txt";

        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();
        defer std.debug.assert(gpa.deinit() == .ok);

        const file = std.fs.cwd().openFile(path, .{}) catch |err| {
            std.log.err("Failed to open file: {s}", .{@errorName(err)});
            return;
        };
        defer file.close();

        while (file.reader().readUntilDelimiterOrEofAlloc(allocator, '\n', std.math.maxInt(usize)) catch |err| {
            std.log.err("Failed to read line: {s}", .{@errorName(err)});
            return;
        }) |line| {
            defer allocator.free(line);
            std.debug.print("highscores: {s}\n", .{line});
        }
    }
};
