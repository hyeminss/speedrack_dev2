import { LightningElement, wire, track, api } from 'lwc';
import getOptionList    from '@salesforce/apex/SRC_TestCreateAS2.getOptionList';
import getCaseBOMRecord from '@salesforce/apex/SRC_TestCreateAS2.getCaseBOMRecord';
import getCaseRecord    from '@salesforce/apex/SRC_TestCreateAS2.getCaseRecord';
import saveCaseRecord   from '@salesforce/apex/SRC_TestCreateAS2.saveCaseRecord';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { CloseActionScreenEvent } from 'lightning/actions';

const columns = [
    { label: '품명',     fieldName: 'itemName'},
    { label: '규격',     fieldName: 'itemSpec'},
    { label: '품번',     fieldName: 'itemNo'},
    { label: '코드',     fieldName: 'itemCode'},
    { label: '요청수량', fieldName: 'itemNeedQty', editable : true},
    { label: '수량',     fieldName: 'itemQty'}
];

export default class CreateNewAS extends LightningElement {

    _title = 'AS문의';
    validationCheck = '[a-zA-Z0-9\/,:\'+( ?-)]*$';

    @wire (getOptionList) codeTypes({ error, data}) {
        if(data) {
            this.claimOptions = data.claimCodeList;
            this.itemTypeOptions = data.itemTypeList;
            this.chargeTypeOptions = data.chargeTypeList;
        } else {
        }
    }

    // 클레임 분류, 아이템 분류, 유무상 분류
    @track claimOptions;
    @track itemTypeOptions;
    @track chargeTypeOptions;

    columns = columns;

    // 수주 정보 오브젝트
    @track
    ordInfo = {
        'seq'               : ' ',
        'orderSeq'          : ' ',
        'orderSerl'         : ' ',
        'account'           : ' ',
        'itemName'          : ' ',
        'orderDate'         : ' ',
        'onlineOrdNo'       : ' ',
        'receiverName'      : ' ',
        'receiverPhone'     : ' ',
        'receiverAddress'   : ' ',
        'onlineMarket'      : ' ',
        'claimType'         : ' ',
        'umChargeType'      : ' ',
        'umItemType'        : ' ',
        'isChange'          : false,
        'salesRemark'       : ' ',
        'asReqDate'         : ' ',
        'asReqNo'           : ' ',
        'accounPhone'       : ' ',
        'logistic'          : ' ',          // 추가 필요
        'originASNo'        : ' ',
        'isCfmASDate'       : ' '
    };    

    @track orderNo = '';
    // 수주 제품 정보 리스트
    @track 
    bomInfo = [
        {
            'id'           : '',
            'itemName'     : '',
            'itemSpec'     : '',
            'itemNo'       : '',
            'itemCode'     : '',
            'itemNeedQty'  : '',
            'itemQty'      : ''
        }
    ];
    
    @track statusText = '';

    /********** [ 변경값 제어 Function() ] **********/
    handleChange(event) {
        
        var fieldName = event.target.name;
        this.ordInfo = JSON.parse(JSON.stringify(this.ordInfo));
        
        if(fieldName == 'orderNo') {
            this.orderNo = event.target.value;
        } else if(fieldName == 'SRF_SaelsRemark__c') {
            var salesRemark = event.target.value;
            this.ordInfo.salesRemark = salesRemark.replace(/<\/?[^>]+(>|$)/g, "");
        } else if(fieldName == 'isChange') {
            this.ordInfo.isChange = event.target.checked;
        } else {
            this.ordInfo[fieldName] = event.target.value;
        }

        console.log('>>' + this.ordInfo.umChargeType);
    }

    /********** [ 수주정보 조회 Funtion() ] **********/
    searchOrderInfo(event) {
        if(event.keyCode == 13) {
            // 수주
            getCaseRecord({ orderNo : this.orderNo })
            .then(result => {
                if(JSON.stringify(result[0]) != undefined) {
                    this.ordInfo = result[0];
                    this.statusText = '';
                } else {
                    this.statusText = '* 수주 정보가 존재하지 않습니다.';
                    this.ordInfo = 0;
                }
            })
            .catch((error) => {
                this.ordInfo = result[0];
            });
    
            // BOM
            if(this.statusText != '* 수주 정보가 존재하지 않습니다.') {
                getCaseBOMRecord({ orderNo : this.orderNo })
                .then(result => {
                    if(JSON.stringify(result[0]) != undefined) {
                        this.bomInfo = result;
                    } else {
                        this.bomInfo = this.bomInfo[0];
                    }
                })
                .catch((error) => {
                    this.bomInfo = undefined;
                });
            }
        }
    }
    
    /********** [ 요청 수량 변경(oncellchange) Funtion() ] **********/
    handleCellValue(event) {
        var modifyBOMInfo = event.detail;
        for(var i = 0; i < this.bomInfo.length; i++) {
            if(modifyBOMInfo.draftValues[0].id == this.bomInfo[i].id) {
                this.bomInfo[i].itemNeedQty = modifyBOMInfo.draftValues[0].itemNeedQty; 
            }
        }
    }

    /********** [ 레코드 저장 Funtion() ] **********/
    saveRecord(event){

        console.log('~1' + JSON.stringify(this.ordInfo));
        if(this.ordInfo.umChargeType == null) {
        }

        if(this.ordInfo.umItemType == null) {
        }

        saveCaseRecord({ caseInfo : this.ordInfo, caseBOMInfo : this.bomInfo })
        .then(result => {
            if(result == 'FAIL') {
                var resultMessage = '문제가 발생했습니다. 잠시 후 다시 시도하세요.';
                var resultVaraint = 'error';
            } else {
                var resultMessage = '생성 되었습니다.';
                var resultVaraint = 'success';
            }
            this._showToast(resultMessage, resultVaraint);
            this._closeQuickAction();
        });

    }


    _showToast(resultMessage, resultVaraint) {
        const event = new ShowToastEvent({
            title   : '신규 AS문의',
            message : resultMessage,
            variant : resultVaraint,
        });

        this.dispatchEvent(event);

    }

    _closeQuickAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}