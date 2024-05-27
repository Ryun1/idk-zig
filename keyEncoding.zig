const std = @import("std");
const ed25519 = std.crypto.sign.Ed25519;
const fmt = std.fmt;

pub fn public_key_hex_from_secret_key(secret_key: ed25519.SecretKey) ![64]u8 {
    const pubKeyBytes: [32]u8 = ed25519.SecretKey.publicKeyBytes(secret_key);
    return fmt.bytesToHex(&pubKeyBytes, .lower);
}

test "public_key_hex_from_secret_key" {
    const secretKeyHex = "c951eabb0e32e30b0f4184927f202fb4516affcb482454867830cfddc0aaf49835055068f6e153a701f1778c7a0b02950d2258c6b3cb73903cea03939d1a046f".*;
    var secretKeyBytes: [64]u8 = undefined;
    _ = try std.fmt.hexToBytes(&secretKeyBytes, &secretKeyHex);
    const secretKey = try ed25519.SecretKey.fromBytes(secretKeyBytes);
    const expectedPublicKeyHex = "35055068f6e153a701f1778c7a0b02950d2258c6b3cb73903cea03939d1a046f".*;
    const publicKeyHex = try public_key_hex_from_secret_key(secretKey);

    try std.testing.expectEqual(expectedPublicKeyHex, publicKeyHex);
}
