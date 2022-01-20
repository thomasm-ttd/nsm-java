package com.uid2.attestation.aws;

public class NitroAttestationRequest {
    private byte[] data;
    private int length;

    NitroAttestationRequest(byte[] data, int length) {
        this.data = data;
        this.length = length;
    }

    public byte[] getData() {
        return data;
    }

    public int getLength() {
        return length;
    }
}
