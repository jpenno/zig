const std = @import("std");

const Pipe = @import("pipe.zig").Pipe;
const Player = @import("player.zig").Player;

const rl = @cImport({
    @cInclude("raylib.h");
});

pub const Game = struct {
    player: Player,
    pipe: Pipe,

    pub fn init() Game {
        const screenWidth = 600;
        const screenHeight = 880;

        rl.InitWindow(screenWidth, screenHeight, "flappy bird");

        rl.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

        return .{
            .player = Player.init(.{ 100, 100 }),
            .pipe = Pipe.init(),
        };
    }

    pub fn deinit(_: Game) void {
        rl.CloseWindow(); // Close window and OpenGL context
    }

    pub fn run(g: *Game) void {
        while (!rl.WindowShouldClose()) { // Detect window close button or ESC key
            const dt = rl.GetFrameTime();

            g.update(dt);
            g.draw();
        }
    }

    fn update(g: *Game, dt: f32) void {
        g.pipe.update(dt);
        g.player.update(dt);

        g.collision();
    }

    fn collision(g: *Game) void {
        if (rl.CheckCollisionRecs(
            .{
                .x = g.player.pos[0],
                .y = g.player.pos[1],
                .width = g.player.size[0],
                .height = g.player.size[1],
            },
            .{
                .x = g.pipe.pos[0],
                .y = g.pipe.pos[1],
                .width = g.pipe.size[0],
                .height = g.pipe.size[1],
            },
        )) {
            std.debug.print("Game Over\n", .{});
        }
    }

    fn draw(g: Game) void {
        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.GRAY);

        g.pipe.draw();
        g.player.draw();
    }
};
