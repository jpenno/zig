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

        const screen_height: f32 = @floatFromInt(rl.GetScreenHeight());
        const screen_pading: f32 = 100;
        const gap: f32 = 300;
        const max_height: f32 = screen_height - gap - screen_pading;
        const rand_num: f32 = @floatFromInt(prng.random().intRangeAtMost(
            i32,
            @intFromFloat(screen_pading),
            @intFromFloat(max_height),
        ));
        const pipe2_start: f32 = rand_num + gap;

        return [2]Pipe{
            Pipe.init(.{ .x = 800, .y = 0 }, .{ .x = 50, .y = rand_num }),
            Pipe.init(.{ .x = 800, .y = pipe2_start }, .{
                .x = 50,
                .y = screen_height + 50.0 - pipe2_start,
            }),
        };
    }
};
