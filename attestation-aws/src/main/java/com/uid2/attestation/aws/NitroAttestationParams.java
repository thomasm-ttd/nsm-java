package com.uid2.attestation.aws;

public class NitroAttestationParams {
    public byte[] userData;
    public byte[] publicKey;
    public byte[] nonce;

    public NitroAttestationParams(byte[] userData, byte[] publicKey, byte[] nonce) {
        this.userData = userData;
        this.publicKey = publicKey;
        this.nonce = nonce;
    }
}
