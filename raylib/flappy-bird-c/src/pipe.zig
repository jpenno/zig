const std = @import("std");

const vec = @import("./math/vec.zig");
const Vec2F = vec.Vec2F;

const rl = @cImport({
    @cInclude("raylib.h");
});

pub const Pipe = struct {
    pos: Vec2F,
    size: Vec2F,
    dir: Vec2F = Vec2F{ -1, 0 },
    speed: f32,
    active: bool,

    pub fn init(pos: rl.Vector2, size: rl.Vector2) Pipe {
        return .{
            .pos = Vec2F{ pos.x, pos.y },
            .size = Vec2F{ size.x, size.y },
            .speed = 200,
            .active = true,
        };
    }

    pub fn update(self: *Pipe, dt: f32) void {
        self.pos += vec.scaleF(self.dir, self.speed * dt);

        if (self.pos[0] + self.size[0] < 0) self.active = false;
    }

    pub fn draw(self: Pipe) void {
        rl.DrawRectangleV(vec.RlVec(self.pos), vec.RlVec(self.size), rl.GREEN);
    }

    pub fn spawnPar() [2]Pipe {
        var seed: u64 = undefined;
        std.posix.getrandom(std.mem.asBytes(&seed)) catch std.debug.print("carnt get seed", .{});
        var prng = std.Random.DefaultPrng.init(seed);

        const screen_pading: i32 = 100;
        const gap: i32 = 300;
        const max_height: i32 = rl.GetScreenHeight() - gap - screen_pading;
        const rand_num: i32 = prng.random().intRangeAtMost(i32, screen_pading, max_height);
        const pipe2_start: f32 = @floatFromInt(rand_num + gap);

        return [2]Pipe{
            Pipe.init(.{ .x = 800, .y = 0 }, .{ .x = 50, .y = @floatFromInt(rand_num) }),
            Pipe.init(.{ .x = 800, .y = pipe2_start }, .{
                .x = 50,
                .y = @as(f32, @floatFromInt(rl.GetScreenHeight())) + 50 - pipe2_start,
            }),
        };
    }
};
