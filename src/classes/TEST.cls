public class TEST {
    
    public static void test(){
        returnobjects();

    }

    public static void returnobjects(){
        List<Case> asCases = new List<Case>();
        List<SRO_CaseBOM__c> asBOMCases = new List<SRO_CaseBOM__c>();

        Case asCase = new Case();
        SRO_CaseBOM__c asBOMCase = new SRO_CaseBOM__c();

        asCase.SRF_UMItemType__c = 'TEST';
        asBOMCase.SRF_ItemName__c = 'test';

        asCases.add(asCase);
        asBOMCases.add(asBOMCase);


        // return asCases, asBOMCases;
    }
    
    
}