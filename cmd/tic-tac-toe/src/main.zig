const std = @import("std");
const Board = @import("board.zig").Board;
const Input_handler = @import("inputHandler.zig").Input_handler;

pub fn main() !void {
    // set up output
    var stdout_buffer: [512]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout: *std.Io.Writer = &stdout_writer.interface;

    // set up input
    var stdin_buffer: [512]u8 = undefined;
    var stdin_reader_wrapper = std.fs.File.stdin().reader(&stdin_buffer);
    const reader: *std.Io.Reader = &stdin_reader_wrapper.interface;

    var input_handler = Input_handler.Init(reader);

    var board = Board.Init();

    const move = try input_handler.GetInput();

    // game logic
    board.Move(move, 'x');

    // draw game
    try stdout.print("\nInput: {}\n", .{move});

    board.Print(stdout);

    try stdout.flush();
}

test {
    std.testing.refAllDecls(@This());
}
