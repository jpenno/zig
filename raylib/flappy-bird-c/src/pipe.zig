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

    pub fn init(pos: rl.Vector2) Pipe {
        return .{
            .pos = Vec2F{ pos.x, pos.y },
            .size = Vec2F{
                50,
                @as(f32, @floatFromInt(rl.GetScreenHeight())) + 50 - pos.y,
            },
            .speed = 100,
        };
    }

    pub fn update(self: *Pipe, dt: f32) void {
        self.pos += vec.scaleF(self.dir, self.speed * dt);
    }

    pub fn draw(self: Pipe) void {
        rl.DrawRectangleV(vec.RlVec(self.pos), vec.RlVec(self.size), rl.GREEN);
    }
};
