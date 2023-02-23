package com.example.zebra_rfid_sdk_plugin;

import com.zebra.rfid.api3.ACCESS_OPERATION_STATUS;

public class Base {
    public static class ErrorResult {

        public static ErrorResult error(String errorMessage, int code) {
            ErrorResult result=new ErrorResult();
            result.errorMessage=errorMessage;
            result.code=code;
            return result;

        }

        public  static ErrorResult error(String errorMessage) {
            ErrorResult result=new ErrorResult();
            result.errorMessage=errorMessage;
            return result;
        }

        int code = -1;
        String errorMessage = "";
    }

    public  static  class RfidEngineEvents{
        static String Error = "Error";
        static String ReadRfid = "ReadRfid";
        static String ConnectionStatus = "ConnectionStatus";
    }


    enum ConnectionStatus {
        ///not connected
        UnConnection,

        ///connection complete
        ConnectionRealy,

        ///connection error
        ConnectionError,
    }



    public static class RfidData{
        ///Label id
        public String tagID;

        public short antennaID;
        //signal peak
        public short peakRSSI;

        // public String tagDetails;
        ///operating state
        public ACCESS_OPERATION_STATUS opStatus;

        ///relative distance
        public short relativeDistance;

        ///Storing data
        public String memoryBankData;

        ///permanently lock data
        public String lockData;
        ///allocation size
        public int allocatedSize;

        public int count=0;
    }
}
