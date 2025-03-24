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
        return [2]Pipe{
            Pipe.init(.{ .x = 800, .y = 0 }, .{ .x = 50, .y = 100 }),
            Pipe.init(.{ .x = 800, .y = 600 }, .{
                .x = 50,
                .y = @as(f32, @floatFromInt(rl.GetScreenHeight())) + 50 - 600,
            }),
        };
    }
};
