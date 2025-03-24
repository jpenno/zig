const std = @import("std");

const Game = @import("game.zig").Game;

pub fn main() void {
    var game = Game.init();
    defer game.deinit();

    game.run();
}
