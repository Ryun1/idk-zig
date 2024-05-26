const std = @import("std");
const ed25519 = std.crypto.sign.Ed25519;
const fmt = std.fmt;

// Lets test out some Ed25519 crypto
// https://github.com/ziglang/zig/blob/master/lib/std/crypto/25519/ed25519.zig

pub fn main() !void {
    std.debug.print("Generating you a random Ed25519 key pair\n", .{});
    try generate_random_key_pair();
}

pub fn generate_random_key_pair() !void {
    const myRandomKeyPair = try std.crypto.sign.Ed25519.KeyPair.create(null);
    const myPublicKey = myRandomKeyPair.public_key;
    const myPublicKeyBytes = myPublicKey.toBytes();
    const mySecretKey = myRandomKeyPair.secret_key;
    const mySecretKeyBytes = mySecretKey.toBytes();

    std.debug.print("Random pub key is : {s}\n", .{fmt.bytesToHex(myPublicKeyBytes, .lower)});
    std.debug.print("Random secret key is : {s}\n", .{fmt.bytesToHex(mySecretKeyBytes, .lower)});
}
