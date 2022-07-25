import { LightningElement, wire, track, api } from 'lwc';
import getCaseBOMRecord from '@salesforce/apex/SRC_TestCreateAS2.getCaseBOMRecord';
import getCaseRecord from '@salesforce/apex/SRC_TestCreateAS2.getCaseRecord';
import saveCaseRecord from '@salesforce/apex/SRC_TestCreateAS2.saveCaseRecord';

const columns = [
    { label: '품명',    fieldName: 'itemName'},
    { label: '규격',    fieldName: 'itemSpec'},
    { label: '품번',    fieldName: 'itemNo'},
    { label: '코드',    fieldName: 'itemCode'},
    { label: '요청수량', fieldName: 'itemNeedQty', editable : true},
    { label: '수량',    fieldName: 'itemQty'}
];

export default class BasicDatatable extends LightningElement {


    @track claimOptions;
    @track itemTypeOptions;
    @track chargeOptions = [
        {   'label' : '무상',
            'value' : '무상'
        }, 
        {
            'label' : '유상',
            'value' : '유상'
        }
    ];

    columns = columns;

    // 수주 정보 오브젝트
    @track
    ordInfo ={
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
        'isChange'          : 'true',
        'salesRemark'       : ' ',
        'asReqDate'         : ' ',
        'claimTypeList'     : [ ],
        'itemTypeList'      : [ ]
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

    /********** [ input field 제어 (주문번호, 휴대전화, 주소) Funtion() ] **********/
    handleChange(event) {
        
        var fieldName = event.target.name;
        this.ordInfo = JSON.parse(JSON.stringify(this.ordInfo));
        
        if(fieldName == 'orderNo') {
            this.orderNo = event.target.value;
        } else if(fieldName == 'salesRemark') {
            var salesRemark = event.target.value;
            this.ordInfo.salesRemark = salesRemark.replace(/<\/?[^>]+(>|$)/g, "");
        } else if(fieldName == 'isChange') {
            this.ordInfo.isChange = event.target.checked;
        } else {
            this.ordInfo[fieldName] = event.target.value;
        }
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
                    this.claimOptions = result[0].claimCodeList;        // 클레임 분류
                    this.itemTypeOptions = result[0].itemTypeList;      // 제품 분류
                    console.log('>>' + JSON.stringify(this.itemTypeOptions));
                } else {
                    this.ordInfo = this.ordInfo;
                    this.statusText = '* 수주 정보가 존재하지 않습니다.';
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

        // console.log('~1' + JSON.stringify(this.ordInfo));
        saveCaseRecord({ ordInfo : this.ordInfo, bomInfo : this.bomInfo })
        .then(result => {
            this.statusText = result;
        });

    }

}