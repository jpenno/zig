const std = @import("std");

pub const Board = struct {
    board: [9]u8,

    pub fn Init() Board {
        return Board{ .board = [_]u8{'.'} ** 9 };
    }

    pub fn Move(board: *Board, move: usize, player: u8) void {
        board.board[move - 1] = player;
    }

    pub fn CheckWin(board: *Board) bool {
        _ = board;
        return false;
    }

    test "Check-win" {
        var board = Init();
        try std.testing.expectEqual(false, board.CheckWin());
    }

    pub fn Print(board: *Board, stdout: *std.Io.Writer) void {
        for (board.board, 1..) |pos, i| {
            stdout.print("{c} ", .{pos}) catch unreachable;

            if (i % 3 == 0) {
                stdout.print("\n", .{}) catch unreachable;
            }
        }
    }
};
