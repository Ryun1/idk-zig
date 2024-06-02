const std = @import("std");
const crypto = std.crypto;

const XPRV_SIZE = 96;
const XPUB_SIZE = 64;
const CHAIN_CODE_SIZE = 32;
const EXTENDED_SECRET_KEY_SIZE = 64;
const PUBLIC_KEY_SIZE = 32;

const ExtendedPrivateKey = struct {
    secret_key: [EXTENDED_SECRET_KEY_SIZE]u8,
    chain_code: [CHAIN_CODE_SIZE]u8,

    pub fn toBytes(self: *const ExtendedPrivateKey) [XPRV_SIZE]u8 {
        var out: [XPRV_SIZE]u8 = undefined;
        std.mem.copyForwards(u8, out[0..EXTENDED_SECRET_KEY_SIZE], self.secret_key[0..]);
        std.mem.copyForwards(u8, out[EXTENDED_SECRET_KEY_SIZE..], self.chain_code[0..]);
        return out;
    }

    // pub fn derive(self: *const ExtendedPrivateKey, index: u32) !ExtendedPrivateKey {
    //     var hasher = crypto.hash.sha2.Sha512.init(.{});
    //     try hasher.update(self.secret_key[0..]);
    //     try hasher.update((u8, index)[0..]);

    //     var hash: [crypto.hash.sha2.Sha512.digest_length]u8 = undefined;
    //     hasher.final(&hash);

    //     var new_secret_key: [EXTENDED_SECRET_KEY_SIZE]u8 = undefined;
    //     var new_chain_code: [CHAIN_CODE_SIZE]u8 = undefined;
    //     std.mem.copyForwards(u8, &new_secret_key, hash[0..EXTENDED_SECRET_KEY_SIZE]);
    //     std.mem.copyForwards(u8, &new_chain_code, hash[EXTENDED_SECRET_KEY_SIZE..]);

    //     return ExtendedPrivateKey{
    //         .secret_key = new_secret_key,
    //         .chain_code = new_chain_code,
    //     };
    // }

    // pub fn to_public(self: *const ExtendedPrivateKey) ExtendedPublicKey {
    //     var public_key = std.crypto.signatures.ed25519.getPublicKey(self.secret_key[0..32]);
    //     var xpub_data: [XPUB_SIZE]u8 = undefined;
    //     std.mem.copyForwards(u8, &xpub_data[0..32], public_key[0..]);
    //     std.mem.copyForwards(u8, &xpub_data[32..], self.chain_code[0..]);

    //     return ExtendedPublicKey{
    //         .data = xpub_data,
    //     };
    // }
};

const ExtendedPublicKey = struct {
    data: [XPUB_SIZE]u8,

    // pub fn verify(self: *const ExtendedPublicKey, msg: []const u8, signature: []const u8) bool {
    //     return std.crypto.signatures.ed25519.verify(signature, msg, self.data[0..32]);
    // }
};

fn generateExtendedMasterPrivateKey(seed: [64]u8) !ExtendedPrivateKey {
    var hash: [crypto.hash.sha2.Sha512.digest_length]u8 = undefined;
    crypto.hash.sha2.Sha512.hash(&seed, &hash, .{});

    var secret_key: [EXTENDED_SECRET_KEY_SIZE]u8 = undefined;
    var chain_code: [CHAIN_CODE_SIZE]u8 = undefined;
    std.mem.copyForwards(u8, &secret_key, hash[0..EXTENDED_SECRET_KEY_SIZE]);
    std.mem.copyForwards(u8, &chain_code, hash[EXTENDED_SECRET_KEY_SIZE..]);

    return ExtendedPrivateKey{
        .secret_key = secret_key,
        .chain_code = chain_code,
    };
}

test "BIP-32 Ed25519 minimal implementation" {
    // const seed = [64]u8{
    //     0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
    //     0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
    //     0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f,
    //     0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
    // };
    const seedhex = "00000000000000000000000000000000".*;
    var seed: [64]u8 = undefined;
    _ = try std.fmt.hexToBytes(&seed, &seedhex);

    const master_key = try generateExtendedMasterPrivateKey(seed);

    // Convert the master key to a hex string
    const master_key_bytes = master_key.toBytes();
    const master_key_hex = std.fmt.bytesToHex(master_key_bytes[0..], .lower);
    std.debug.print("Master Key: {s}\n", .{master_key_hex});

    // // Derive a child key
    // const child_index: u32 = 0;
    // const child_key = try master_key.derive(child_index);

    // // Convert to public key
    // const child_pub = child_key.to_public();

    // // Sign a message with the child key
    // const msg = "hello";
    // var signature: [64]u8 = undefined;
    // std.crypto.signatures.ed25519.sign(&signature, msg, child_key.secret_key[0..32]);

    // // Verify the signature with the child public key
    // std.testing.expect(child_pub.verify(msg, signature[0..]));
}
