import { LightningElement, wire , track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import getCustomers from '@salesforce/apex/CNX_Apex_Class.getCustomers';

const columns = [
    { 
        label : '360 View',
        type : 'button',
        typeAttributes : {
            iconName : 'custom:custom15',
            label : 'Detail'
        }
    },
    {
        label : 'Customer Name',
        fieldName : 'nameWithUrl',
        type : 'url',
        typeAttributes : {
            label : { fieldName : 'Name' },
            target : '_blank'
        }
    }
];

export default class Customers extends LightningElement 
{
    @track columns = columns;
    @track hasCustomer = false;
    @track customer;
    @wire(CurrentPageReference) pageRef;
    @track productId;
    @track data;
    @wire(getCustomers , { productId : '$productId' })
    getCustomersCallback({error,data})
    {
        if(data)
        {
            this.data = data.map((row) => {
                return {...row , nameWithUrl : '/' + row.Id};
            });
        }
        else if(error)
        {
            alert(JSON.stringify(error));
        }
    }

    connectedCallback()
    {
        registerListener('procuctName',this.eventData,this);
    }
    disconnectedCallback()
    {
        unregisterAllListeners(this);
    }
    eventData(payload)
    {
        this.productId = payload;
    }
    handleRowAction(event)
    {
        if(event.detail.action.label == 'Detail')
        {
            const customer = { Id : event.detail.row.Id , Name : event.detail.row.Name };
            this.customer = customer;
            this.hasCustomer = true;
        }
    }
}