const std = @import("std");

pub const XPrv = struct {
    secret_key: [64]u8,
    chain_code: [32]u8,

    pub fn init(secret_key: [64]u8, chain_code: [32]u8) XPrv {
        return XPrv{
            .secret_key = secret_key,
            .chain_code = chain_code,
        };
    }

    pub fn fromBytes(data: []const u8) !XPrv {
        if (data.len != 96) {
            return error.InvalidLength;
        }
        var secret_key: [64]u8 = undefined;
        var chain_code: [32]u8 = undefined;
        std.mem.copyForwards(u8, secret_key[0..], data[0..64]);
        std.mem.copyForwards(u8, chain_code[0..], data[64..96]);
        return XPrv{
            .secret_key = secret_key,
            .chain_code = chain_code,
        };
    }

    pub fn toBytes(self: *const XPrv) [96]u8 {
        var result: [96]u8 = undefined;
        std.mem.copyForwards(u8, result[0..64], self.secret_key[0..]);
        std.mem.copyForwards(u8, result[64..96], self.chain_code[0..]);
        return result;
    }

    // pub fn fromHex(hex: []const u8) !XPrv {
    //     if (hex.len != 192) {
    //         return error.InvalidLength;
    //     }
    //     var data: [96]u8 = undefined;
    //     _ = try std.fmt.hexToBytes(&data, &hex);
    //     return try XPrv.fromBytes(&data);
    // }

    // pub fn toHex(self: *const XPrv) [192]u8 {
    //     var data = self.toBytes();
    //     return std.fmt.bytesToHex(&data, .lower);
    // }
};

test "XPrv struct functionality" {
    const secret_key: [64]u8 = [_]u8{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63 };
    const chain_code: [32]u8 = [_]u8{ 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95 };

    var xprv = XPrv.init(secret_key, chain_code);
    const xprv_bytes = xprv.toBytes();
    // const xprv_hex = xprv.toHex();

    var new_xprv = try XPrv.fromBytes(&xprv_bytes);
    try std.testing.expect(std.mem.eql(u8, &xprv.secret_key, &new_xprv.secret_key));
    try std.testing.expect(std.mem.eql(u8, &xprv.chain_code, &new_xprv.chain_code));

    // var new_xprv_from_hex = try XPrv.fromHex(xprv_hex);
    // try std.testing.expect(std.mem.eql(u8, &xprv.secret_key, &new_xprv_from_hex.secret_key));
    // try std.testing.expect(std.mem.eql(u8, &xprv.chain_code, &new_xprv_from_hex.chain_code));
}
