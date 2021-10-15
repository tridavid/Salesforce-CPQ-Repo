import { LightningElement, track, wire } from 'lwc';
import getCnxProducts from '@salesforce/apex/CNX_Apex_Class.getCnxProducts';
import { CurrentPageReference } from 'lightning/navigation';
import { fireEvent } from 'c/pubsub';

export default class Products extends LightningElement 
{
    @wire(CurrentPageReference) pageRef;

    @track products;

    @wire(getCnxProducts)
    wiredCallback({error,data})
    {
        if(data)
        {
            this.products = [ { label : 'Testing' , value : '' } ];
            data.forEach(element => {
                const row = {label:element.Name,value:element.Id};
                this.products.push(row);
            });
        }
        else if(error)
        {
            alert(JSON.stringify(error));
        }
    }

    handleProductChange(event)
    {
        const val = event.detail.value;
        fireEvent(this.pageRef,'procuctName',val);
    }
}