const std = @import("std");
const fmt = std.fmt;

// Lets test out some Ed25519 crypto
// https://github.com/ziglang/zig/blob/master/lib/std/crypto/25519/ed25519.zig

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"keys"});

    try generate_key();
}

pub fn generate_key() !void {
    const myRandomKeyPair = try std.crypto.sign.Ed25519.KeyPair.create(null);
    const myPublicKey = myRandomKeyPair.public_key;
    const myPublicKeyBytes = myPublicKey.toBytes();
    // const mySecretKey = myRandomKeyPair.secret_key;

    std.debug.print("hi my pub key is : {s}\n", .{fmt.bytesToHex(myPublicKeyBytes, .lower)});
}
