import { api, LightningElement , track, wire } from 'lwc';
import getProductsByCustomer from '@salesforce/apex/CNX_Apex_Class.getProductsByCustomer';
import getOrders from '@salesforce/apex/CNX_Apex_Class.getOrders';
import getComplaints from '@salesforce/apex/CNX_Apex_Class.getComplaints';

export default class CustomerTree extends LightningElement {
    @api customer;
    @track items1;
    @track items2;
    @track items3;
    @wire(getProductsByCustomer,{customerId:'$customer.Id'})
    wiredProductCallback({error,data})
    {
        if(data)
        {
            this.items1 = data;
        }
        else if(error)
        {
            alert(JSON.stringify(error));
        }
    }//wire
    @wire(getOrders,{customerId:'$customer.Id'})
    wiredOrderCallback({error,data})
    {
        if(data)
        {
            this.items2 = data;
        }
        else if(error)
        {
            alert(JSON.stringify(error));
        }
    }//wire
    @wire(getComplaints,{customerId:'$customer.Id'})
    wiredComplaintsCallback({error,data})
    {
        if(data)
        {
            this.items3 = data;
        }
        else if(error)
        {
            alert(JSON.stringify(error));
        }
    }//wire
    handleTree(event)
    {
        if(event.detail.name != 'Products')
        {
            window.open('/'+event.detail.name);
        }
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.customer = false;
    }
}