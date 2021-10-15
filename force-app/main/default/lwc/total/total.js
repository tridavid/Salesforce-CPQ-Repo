import { LightningElement, wire } from 'lwc';
import getTotalProductsCount from '@salesforce/apex/CNX_Apex_Class.getTotalProductsCount';
import getTotalBusinessAmount from '@salesforce/apex/CNX_Apex_Class.getTotalBusinessAmount';

export default class Total extends LightningElement 
{
    @wire(getTotalProductsCount)
    totalProducts;
    @wire(getTotalBusinessAmount)
    totalBusiness;
}