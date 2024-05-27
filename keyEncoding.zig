const std = @import("std");
const ed25519 = std.crypto.sign.Ed25519;
const fmt = std.fmt;

pub fn public_key_hex_from_secret_key(secret_key: ed25519.SecretKey) ![64]u8 {
    const pubKeyBytes: [32]u8 = ed25519.SecretKey.publicKeyBytes(secret_key);
    return fmt.bytesToHex(&pubKeyBytes, .lower);
}

pub fn secret_key_to_hex(secret_key: ed25519.SecretKey) ![128]u8 {
    const secretKeyBytes: [64]u8 = ed25519.SecretKey.toBytes(secret_key);
    return fmt.bytesToHex(&secretKeyBytes, .lower);
}

pub fn secret_key_from_hex(secret_key_hex: [128]u8) !ed25519.SecretKey {
    var secretKeyBytes: [64]u8 = undefined;
    _ = try fmt.hexToBytes(&secretKeyBytes, &secret_key_hex);
    return ed25519.SecretKey.fromBytes(secretKeyBytes);
}

pub fn public_key_to_hex(public_key: ed25519.PublicKey) ![64]u8 {
    const publicKeyBytes: [32]u8 = ed25519.PublicKey.toBytes(public_key);
    return fmt.bytesToHex(&publicKeyBytes, .lower);
}

pub fn public_key_from_hex(public_key_hex: [64]u8) !ed25519.PublicKey {
    var publicKeyBytes: [32]u8 = undefined;
    _ = try fmt.hexToBytes(&publicKeyBytes, &public_key_hex);
    return ed25519.PublicKey.fromBytes(publicKeyBytes);
}

test "encoding_helper_funcs" {
    const secretKeyHex = "c951eabb0e32e30b0f4184927f202fb4516affcb482454867830cfddc0aaf49835055068f6e153a701f1778c7a0b02950d2258c6b3cb73903cea03939d1a046f".*;
    const publicKeyHex = "35055068f6e153a701f1778c7a0b02950d2258c6b3cb73903cea03939d1a046f".*;

    try std.testing.expectEqual(secretKeyHex, try secret_key_to_hex(try secret_key_from_hex(secretKeyHex)));

    try std.testing.expectEqual(publicKeyHex, try public_key_to_hex(try public_key_from_hex(publicKeyHex)));
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
