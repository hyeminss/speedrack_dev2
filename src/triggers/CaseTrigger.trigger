trigger CaseTrigger on Case (after insert) {
    new caseCreate_tr().run();
}