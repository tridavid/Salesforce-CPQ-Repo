import { LightningElement } from 'lwc';

export default class HelloWorld extends LightningElement 
{
    greeting;

    connectedCallback()
    {
        this.greeting = 'Hello from Akhilesh';
    }
}