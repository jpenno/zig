const Player = @import("player.zig").Player;

const rl = @cImport({
    @cInclude("raylib.h");
});

pub const Game = struct {
    player: Player,

    pub fn init() Game {
        const screenWidth = 600;
        const screenHeight = 880;

        rl.InitWindow(screenWidth, screenHeight, "flappy bird");

        rl.SetTargetFPS(60); // Set our game to run at 60 frames-per-second
        return .{
            .player = Player.init(.{ 100, 100 }),
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
        g.player.update(dt);
    }

    fn draw(g: Game) void {
        rl.BeginDrawing();
        defer rl.EndDrawing();

        rl.ClearBackground(rl.GRAY);

        g.player.draw();
    }
};
