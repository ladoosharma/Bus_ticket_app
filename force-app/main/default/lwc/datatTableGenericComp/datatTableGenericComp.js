import { LightningElement, api, wire, track } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
export default class DatatTableGenericComp extends LightningElement {

    @api
    objectName;
    @api
    FieldsName ;
    @api
    listViewName;
    @track
    errorList = [];
    @track
    columnObj;
    @track
    dataList ;

    @wire(getListUi, { objectApiName: '$objectName', listViewApiName: '$listViewName' })
    listOfData;

    renderedCallback(){
        if(this.listOfData.data && !this.dataList  && !this.columnObj){
            let headerList = [];
            let objList = [];
            this.listOfData.data.info.displayColumns.forEach((item)=>{
                if(this.FieldsName.toLowerCase().includes(item.fieldApiName.toLowerCase())){
                    headerList.push({fieldName: item.fieldApiName, label: item.label});
                }
                
            });
            this.listOfData.data.records.records.forEach((record)=>{
                let eachRecord = {};
                Object.entries(record.fields).forEach((field)=>{
                    eachRecord[field[0]] = field[1].value;
                })
                objList.push(eachRecord);
            })
            this.dataList = objList;
            this.columnObj = headerList;
        }
        
    }
    

    
}