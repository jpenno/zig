const rl = @import("raylib");

pub const Vec2F = @Vector(2, f32);
pub const Vec2I = @Vector(2, i32);

pub fn scaleF(self: Vec2F, scalar: f32) Vec2F {
    return self * @as(Vec2F, @splat(scalar));
}
pub fn scaleI(self: Vec2I, scalar: i32) Vec2I {
    return self * @as(Vec2I, @splat(scalar));
}

pub fn RlVec(self: Vec2F) rl.Vector2 {
    return .{ .x = self[0], .y = self[1] };
}
