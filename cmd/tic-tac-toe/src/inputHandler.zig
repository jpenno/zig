const std = @import("std");

pub const Input_handler = struct {
    reader: *std.Io.Reader,
    // stdin_buffer: [512]u8,

    pub fn Init(reader: *std.Io.Reader) Input_handler {
        return Input_handler{
            .reader = reader,
            // .stdin_buffer = stdin_buffer,
        };
    }

    pub fn GetInput(input_handler: *Input_handler) !usize {
        const input: []u8 = try input_handler.reader.takeDelimiterExclusive('\n');

        std.debug.print("Input: \"{s}\"\n", .{input});

        const move = std.fmt.parseInt(usize, input, 10) catch |err| {
            switch (err) {
                error.InvalidCharacter => {
                    // std.debug.print("Please enter a valid number {s}\n", .{input});
                    std.debug.print("Please enter a valid number\n", .{});
                    return err;
                },
                error.Overflow => {
                    std.debug.print("Please enter a small positive number\n", .{});
                    return err;
                },
            }
        };

        return move;
    }
};
