global class SRC_OrderCreateJob implements Schedulable{
    
    global void execute(SchedulableContext sc){   
        SRC_OrderCreateBatch orderBatch = new SRC_OrderCreateBatch();        
        Id batchId = Database.executeBatch(orderBatch, 200);
    }
}
//System.schedule('Order Batch_Dummy to Real 9 AM', '0 07 9 * * ?', new SRC_OrderCreateJob());
//System.schedule('Order Batch_Dummy to Real 10 AM', '0 07 10 * * ?', new SRC_OrderCreateJob());
//System.schedule('Order Batch_Dummy to Real 11 AM', '0 07 11 * * ?', new SRC_OrderCreateJob());
//System.schedule('Order Batch_Dummy to Real 12 PM', '0 07 12 * * ?', new SRC_OrderCreateJob());
//System.schedule('Order Batch_Dummy to Real 13 PM', '0 07 13 * * ?', new SRC_OrderCreateJob());
//System.schedule('Order Batch_Dummy to Real 14 PM', '0 07 14 * * ?', new SRC_OrderCreateJob());
//System.schedule('Order Batch_Dummy to Real 15 PM', '0 07 15 * * ?', new SRC_OrderCreateJob());