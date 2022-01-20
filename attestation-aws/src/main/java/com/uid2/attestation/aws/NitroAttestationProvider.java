package com.uid2.attestation.aws;

import com.uid2.enclave.AttestationException;
import com.uid2.enclave.IAttestationProvider;
import java.util.Arrays;

public class NitroAttestationProvider implements IAttestationProvider {
    @Override
    public byte[] getAttestationRequest(byte[] publicKey) throws AttestationException {
        try {
            NitroAttestationParams params = new NitroAttestationParams(null, publicKey, null);
            NitroAttestationRequest request = NitroAttestation.generateAttestationRequest(params);
            return Arrays.copyOfRange(request.getData(), 0, request.getLength());
        } catch (NitroException e) {
            throw new AttestationException(e);
        }
    }
}
