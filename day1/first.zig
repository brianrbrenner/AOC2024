const std = @import("std");
const Allocator = std.mem.Allocator;
const input = @embedFile("in1.txt");
const MAX_SIZE: usize = 1000;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    try p1(allocator);
    try p2(allocator);
}

pub fn parse(allocator: Allocator) !struct { left: std.ArrayList(i32), right: std.ArrayList(i32) } {
    var lh_nums = std.ArrayList(i32).init(allocator);
    var rh_nums = std.ArrayList(i32).init(allocator);

    var it = std.mem.tokenizeAny(u8, input, " \n");
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

    return .{ .left = lh_nums, .right = rh_nums };
}

pub fn p1(allocator: Allocator) !void {
    const nums = try parse(allocator);
    const left = nums.left;
    defer left.deinit();
    const right = nums.right;
    defer right.deinit();

    var sum: u64 = 0;
    for (left.items, right.items) |l, r| {
        sum += @abs(l - r);
    }

    std.debug.print("Sum: {d}\n", .{sum});
}

pub fn p2(allocator: Allocator) !void {
    const nums = try parse(allocator);
    const left = nums.left;
    defer nums.right.deinit();
    defer left.deinit();
    var right = std.AutoHashMap(i32, i32).init(allocator);
    defer right.deinit();

    for (0.., left.items) |i, _| {
        const entry = try right.getOrPutValue(nums.right.items[i], 0);
        entry.value_ptr.* += 1;
    }

    var sum: i64 = 0;
    for (left.items) |l| {
        const occur = right.get(l) orelse {
            continue;
        };

        sum += occur * l;
    }

    std.debug.print("P2 Sum {d}\n,", .{sum});
}
