/*
 * SRC_PlayautoCreateJob.cls
 * 오시우 2022-07-11 ver1.0
 * 설명 : Batch -> Schedulable
 */
public class SRC_PlayautoCreateJob implements Schedulable {
    
    
    public void execute(SchedulableContext sc){

        System.debug('SRC_PlayautoCreateJob!!!');

        Database.executeBatch( new SRC_PlayautoCreateBatch(), 1);
                            
    }

}