global class SRC_ERPBOMBatch_Schedulable implements Schedulable {
    global void execute(SchedulableContext sc){
        SRC_ERPBOMBatch bomBatch = new SRC_ERPBOMBatch();
        Id batchId = Database.executeBatch(bomBatch, 200);
    }
}