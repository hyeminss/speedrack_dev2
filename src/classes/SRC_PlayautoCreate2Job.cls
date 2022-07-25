/*
 * SRC_PlayautoCreate2Job.cls
 * 오시우 2022-07-11 ver1.0
 * 설명 : Batch2 -> Schedulable2
 */
public with sharing class SRC_PlayautoCreate2Job implements Schedulable {

    public SRC_PlayautoCreate2Job() {
    }

    public void execute(SchedulableContext sc){

        System.debug('SRC_PlayautoCreate2Job!!!');
        Database.executeBatch( new SRC_PlayautoCreate2Batch(), 20);

    }

}