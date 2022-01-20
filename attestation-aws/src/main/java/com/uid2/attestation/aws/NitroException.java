package com.uid2.attestation.aws;

public class NitroException extends Exception {
    
    private static final long serialVersionUID = 1L;

    NitroException(String message) {
        super(message);
    }

    static NitroException fromErrorCode(int error) {
        switch(error) {
            case -1: return new NitroException("Invalid Argument");
            case -2: return new NitroException("Invalid Index");
            case -3: return new NitroException("Invalid Response");
            case -4: return new NitroException("Readonly Index");
            case -5: return new NitroException("Invalid Operation");
            case -6: return new NitroException("Buffer too small");
            case -7: return new NitroException("Input too large");
            case -8: return new NitroException("Internal Error");
            default: return new NitroException("Unknown Error");
        }
    }
}