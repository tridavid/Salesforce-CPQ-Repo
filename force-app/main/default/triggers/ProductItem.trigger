trigger ProductItem on Product_Item__c (after insert) 
{
	for(Product_Item__c p : trigger.new)
    {
        System.debug(p.Product_Bundle__c);
        CNX_Products__c price = [SELECT Price_USD__c FROM CNX_Products__c WHERE Id = :p.CNX_Product__c];
        System.debug(price);
        Product_Bundle__c bundle = [SELECT Bundle_discount__c,Volume_discount__c , Quantity__c FROM Product_Bundle__c WHERE Id = :p.Product_Bundle__c];
        System.debug(bundle);
        
        Double total = price.Price_USD__c * bundle.Quantity__c ;
        System.debug(total);
        Double percentage;
        if(bundle.Bundle_discount__c == null)
        	percentage = bundle.Volume_discount__c / 100 ;
        else if(bundle.Volume_discount__c == null)
            percentage = bundle.Bundle_discount__c / 100 ;
        System.debug(percentage);
        Double temp = total * percentage ;
        System.debug(temp);
        total = total - temp ;
        System.debug(total);
        
        Customer__c previousValue = [SELECT Total_Purchase_Amount__c FROM Customer__c WHERE Id = :p.Customer__c];
        
        Customer__c c = new Customer__c(Id = p.Customer__c);
        c.Total_Purchase_Amount__c = previousValue.Total_Purchase_Amount__c + total;
        update c;
    }    
}