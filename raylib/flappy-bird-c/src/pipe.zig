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

    pub fn init() Pipe {
        const posX: f32 = 500;

        return .{
            .pos = Vec2F{ 700, posX },
            .size = Vec2F{
                25,
                @as(f32, @floatFromInt(rl.GetScreenHeight())) + 50 - posX,
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
