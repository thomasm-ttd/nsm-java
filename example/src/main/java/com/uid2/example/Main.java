package com.uid2.example;

import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.Base64;
import com.uid2.attestation.aws.*;

public class Main {
    public static void main(String[] args) {
        try {
            NitroAttestationParams params = new NitroAttestationParams().withPublicKey("dummy_public_key".getBytes());
            NitroAttestationRequest request = NitroAttestation.generateAttestationRequest(params);
            byte[] data = Arrays.copyOfRange(request.getData(), 0, request.getLength());
            System.out.println(Base64.getEncoder().encodeToString(data));
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }    
}
