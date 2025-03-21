const std = @import("std");

const rl = @import("raylib");

const vec = @import("./math/vec.zig");

pub fn main() anyerror!void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 1280;
    const screenHeight = 720;

    // var pos = Vf2{ 100, 100 };
    var pos = vec.Vec2F{ 100, 100 };
    // var pos = vec.Vec(2, f32){ 100, 100 };
    const dir = vec.Vec2F{ 1, 0 };
    const speed: i32 = 300;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        const dt = rl.getFrameTime();

        pos += vec.scaleF(dir, speed * dt);
        // pos += dir * @as(vec.V2f, @splat(dt * speed));
        // Draw
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.gray);

        rl.drawRectangleV(vec.RlVec(pos), .{ .x = 100, .y = 100 }, rl.Color.green);

        //----------------------------------------------------------------------------------
    }
}
