const std = @import("std");
const input = @embedFile("in1.txt");
const MAX_SIZE: usize = 1000;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer gpa.deinit();
    var it = std.mem.tokenizeAny(u8, input, " \n");

    var lh_nums = std.ArrayList(i32).init(allocator);
    defer lh_nums.deinit();
    var rh_nums = std.ArrayList(i32).init(allocator);
    defer rh_nums.deinit();

    var counter: usize = 0;
    while (it.next()) |token| {
        const num = try std.fmt.parseInt(i32, token, 10);
        if (counter % 2 == 0) {
            // left col
            try lh_nums.append(num);
        } else {
            // right col
            try rh_nums.append(num);
        }

        counter += 1;
    }

    std.mem.sort(i32, lh_nums.items, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, rh_nums.items, {}, comptime std.sort.asc(i32));

    var sum: u64 = 0;
    for (lh_nums.items, rh_nums.items) |l, r| {
        sum += @abs(l - r);
    }

    std.debug.print("Sum: {d}\n", .{sum});
}
