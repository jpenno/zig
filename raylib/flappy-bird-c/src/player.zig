const vec = @import("./math/vec.zig");

const rl = @cImport({
    @cInclude("raylib.h");
});

pub const Player = struct {
    pos: vec.Vec2F,
    dir: vec.Vec2F,
    speed: f32 = 100,

    pub fn init(pos: vec.Vec2F) Player {
        return .{
            .pos = pos,
            .dir = vec.Vec2F{ 1, 0 },
        };
    }

    pub fn update(p: *Player, dt: f32) void {
        p.pos += vec.scaleF(p.dir, p.speed * dt);
    }

    pub fn draw(p: Player) void {
        rl.DrawRectangleV(vec.RlVec(p.pos), .{ .x = 100, .y = 100 }, rl.GREEN);
    }
};
