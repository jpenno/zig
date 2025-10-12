const std = @import("std");
const Board = @import("board.zig").Board;

pub fn main() !void {
    // set up output
    var stdout_buffer: [512]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout: *std.Io.Writer = &stdout_writer.interface;

    // set up input
    var stdin_buffer: [512]u8 = undefined;
    var stdin_reader_wrapper = std.fs.File.stdin().reader(&stdin_buffer);
    const reader: *std.Io.Reader = &stdin_reader_wrapper.interface;

    var board = Board.Init();

    while (reader.takeDelimiterExclusive('\n')) |line| {
        // handel input
        const input: usize = std.fmt.parseInt(usize, line, 10) catch |err| {
            switch (err) {
                error.InvalidCharacter => {
                    if (std.mem.eql(u8, line, "quit")) {
                        try stdout.print("quit game", .{});
                        return;
                    }
                    try stdout.print("Please enter a valid number\n", .{});
                    continue;
                },
                error.Overflow => {
                    try stdout.print("Please enter a small positive number\n", .{});
                    continue;
                },
            }
        };

        // game logic
        board.Move(input, 'x');

        // draw game
        try stdout.print("\nInput: {}\n", .{input});

        board.Print(stdout);

        try stdout.flush();
    } else |err| switch (err) {
        error.EndOfStream => {},
        error.StreamTooLong => return err,
        error.ReadFailed => return err,
    }
}
