const std = @import("std");

const Pipe = @import("pipe.zig").Pipe;
const Player = @import("player.zig").Player;
const Timer = @import("timer.zig").Timer;

const rl = @cImport({
    @cInclude("raylib.h");
});

pub const Game = struct {
    const State = enum {
        Playing,
        Pause,
        GameOver,
    };

    player: Player,
    pipes: [20]Pipe = undefined,
    pipe_spawn_timer: Timer,
    state: State,

    pub fn init() Game {
        const screenWidth = 600;
        const screenHeight = 880;

        rl.InitWindow(screenWidth, screenHeight, "flappy bird");

        rl.SetTargetFPS(60); // Set our game to run at 60 frames-per-second

        return .{
            .player = Player.init(.{ 100, 100 }),
            .state = .Playing,
            .pipe_spawn_timer = Timer.init(1.0),
        };
    }

    pub fn deinit(_: Game) void {
        rl.CloseWindow(); // Close window and OpenGL context
    }

    pub fn run(g: *Game) void {
        while (!rl.WindowShouldClose()) { // Detect window close button or ESC key
            const dt = rl.GetFrameTime();

            rl.BeginDrawing();
            defer rl.EndDrawing();

            switch (g.state) {
                .Playing => {
                    g.updatePlaying(dt);
                    g.drawPlaying();
                },
                .GameOver => {
                    g.updateGameOver();
                    g.drawGameOver();
                },
                .Pause => {},
            }
        }
    }

    fn updatePlaying(g: *Game, dt: f32) void {
        if (g.pipe_spawn_timer.tick(dt)) {
            const tmp = Pipe.spawnPar();

            for (tmp) |t| {
                for (&g.pipes) |*pipe| {
                    if (pipe.active == false) {
                        pipe.* = t;
                        break;
                    }
                }
            }
        }
        for (&g.pipes) |*pipe| {
            pipe.update(dt);
        }

        g.player.update(dt);

        g.collision();
    }

    fn drawPlaying(g: Game) void {
        rl.ClearBackground(rl.SKYBLUE);

        for (g.pipes) |pipe| {
            pipe.draw();
        }

        g.player.draw();
    }

    fn updateGameOver(g: *Game) void {
        if (rl.IsKeyPressed(rl.KEY_SPACE)) {
            g.reset();
        }
    }

    fn drawGameOver(g: Game) void {
        _ = g;
        rl.ClearBackground(rl.GRAY);
    }

    fn reset(g: *Game) void {
        g.player = Player.init(.{ 100, 100 });
        g.pipes = undefined;
        g.state = .Playing;
    }

    fn collision(g: *Game) void {
        for (g.pipes) |pipe| {
            if (rl.CheckCollisionRecs(
                .{
                    .x = g.player.pos[0],
                    .y = g.player.pos[1],
                    .width = g.player.size[0],
                    .height = g.player.size[1],
                },
                .{
                    .x = pipe.pos[0],
                    .y = pipe.pos[1],
                    .width = pipe.size[0],
                    .height = pipe.size[1],
                },
            )) {
                std.debug.print("Game Over\n", .{});
                g.state = .GameOver;
            }
        }
    }
};
