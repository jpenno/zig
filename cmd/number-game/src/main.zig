const std = @import("std");

pub fn main() !void {
    // set up input
    var stdin_buffer: [512]u8 = undefined;
    var stdin_reader_wrapper = std.fs.File.stdin().reader(&stdin_buffer);
    const reader: *std.Io.Reader = &stdin_reader_wrapper.interface;

    // set up out put
    var stdout_buffer: [512]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout: *std.Io.Writer = &stdout_writer.interface;

    // set up rundom numbre
    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();

    const max_guess_count: u32 = 10;
    var guess_count: u32 = 0;

    // gte random number between 1 - 100
    const random_number = rand.intRangeAtMost(u8, 1, 100);
    std.debug.print("random number is: {}\n", .{random_number});

    try stdout.writeAll("Guess the numbre between 1 - 100\n");
    try stdout.flush();

    while (reader.takeDelimiterExclusive('\n')) |line| {
        defer stdout.flush() catch unreachable;

        // handle guess count
        guess_count += 1;
        if (guess_count >= max_guess_count) {
            try stdout.print("Game over ran out of gusses\n", .{});
            return;
        }
        try stdout.print("Gusses left: {}\n", .{max_guess_count - guess_count});

        // handle input
        const guess = std.fmt.parseInt(i32, line, 10) catch |err| {
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

        if (guess == random_number) {
            try stdout.print("you win\n", .{});
            break;
        } else if (guess > random_number) {
            try stdout.print("too high: {}\n", .{guess});
        } else if (guess < random_number) {
            try stdout.print("too low: {}\n", .{guess});
        }
    } else |err| switch (err) {
        error.EndOfStream => {},
        error.StreamTooLong => return err,
        error.ReadFailed => return err,
    }
}
