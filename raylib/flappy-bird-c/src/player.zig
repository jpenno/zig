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
        rl.DrawRectangleV(vec.RlVec(p.pos), vec.RlVec(p.size), rl.LIME);
    }
};
