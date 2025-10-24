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
        // check --------
        for (0..3) |y| {
            if (board.GetPos(0, y) == board.GetPos(1, y) and
                board.GetPos(0, y) == board.GetPos(2, y) and
                board.GetPos(0, y) != '.')
            {
                return true;
            }
        }

        // 123
        // 456
        // 789
        // TODO: check ||||||||
        for (0..3) |x| {
            if (board.GetPos(x, 0) == board.GetPos(x, 1) and
                board.GetPos(x, 0) == board.GetPos(x, 2) and
                board.GetPos(x, 0) != '.')
            {
                return true;
            }
        }
        // TODO: check \\\\\\\\
        // TODO: check ////////

        return false;
    }

    test "Win_empty" {
        var board = Board{ .board = [_]u8{'.'} ** 9 };

        try std.testing.expectEqual(false, board.CheckWin());
    }

    test "Win_3_across" {
        var board2 = Board{ .board = [_]u8{
            '.', 'x', '.',
            'x', 'x', 'x',
            '.', '.', '.',
        } };
        try std.testing.expectEqual(true, board2.CheckWin());
    }

    test "Win_3_down" {
        var board2 = Board{ .board = [_]u8{
            'x', 'x', '.',
            'x', 'x', '.',
            '.', 'x', '.',
        } };
        try std.testing.expectEqual(true, board2.CheckWin());
    }

    pub fn Print(board: *Board, stdout: *std.Io.Writer) void {
        for (board.board, 1..) |pos, i| {
            stdout.print("{c} ", .{pos}) catch unreachable;

            if (i % 3 == 0) {
                stdout.print("\n", .{}) catch unreachable;
            }
        }
    }

    fn GetPos(board: *Board, x: usize, y: usize) u8 {
        return board.board[x + 3 * y];
    }
};
