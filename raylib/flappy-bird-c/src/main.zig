const std = @import("std");

const Player = @import("player.zig").Player;

const rl = @cImport({
    @cInclude("raylib.h");
});

pub fn main() !void {
    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 1280;
    const screenHeight = 720;

    var player = Player.init(.{ 100, 100 });

    rl.InitWindow(screenWidth, screenHeight, "flappy bird");
    defer rl.CloseWindow(); // Close window and OpenGL context

    rl.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.WindowShouldClose()) { // Detect window close button or ESC key

        // Update
        //----------------------------------------------------------------------------------
        // TODO: Update your variables here
        //----------------------------------------------------------------------------------

        const dt = rl.GetFrameTime();
        player.update(dt);

        // Draw
        //----------------------------------------------------------------------------------
        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.GRAY);

        player.draw();

        //----------------------------------------------------------------------------------
    }
}
