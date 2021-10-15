public with sharing class CNX_Apex_Class 
{
	@AuraEnabled(cacheable=true)
    public static List<CNX_Products__c> getCnxProducts()
    {
        return [SELECT Id,Name FROM CNX_Products__c LIMIT 10];
    }
    @AuraEnabled(cacheable=true)
    public static List<Customer__c> getCustomers(String productId)
    {
        //from Parent to Related Object Query ChildRelationship Name
        List<Customer__c> c = [SELECT Id , Name , (SELECT Id FROM Product_Items__r WHERE CNX_Product__c = :productId) FROM Customer__c];
        System.debug(c);
        return c;
    }
    
    class Item
    {
        @AuraEnabled
        public String label;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public boolean expanded;
        @AuraEnabled
        public List<Item> items;
        
        Item(String label,String name,boolean expanded,List<Item> items)
        {
            this.label = label;
            this.name = name;
            this.expanded = expanded;
            this.items = items;
        }    
    }

	@AuraEnabled(cacheable=true)
    public static List<Item> getOrders(String customerId)
    {
        List<Product_Item__c> productNames = [SELECT Id,CreatedDate,Name,CNX_Product__r.Name 
                                              FROM Product_Item__c 
                                              WHERE Customer__c = :customerId ORDER BY CreatedDate DESC];
        List<Item> pItems = new List<Item>();
        Item finalTreeItem ;
        List<Item> finalTreeItems = new List<Item>();
        for(Product_Item__c p : productNames)
        {
        	Item i = new Item('Date/Time:('+p.CreatedDate.format()+') Product :'+p.CNX_Product__r.Name,
                              String.valueOf(p.Id),
                              false,
                              null);
            pItems.add(i);
        }
        finalTreeItem = new Item('Orders','Orders',false,pItems);
        finalTreeItems.add(finalTreeItem);
        System.debug(finalTreeItems);
        return finalTreeItems;
    }
    @AuraEnabled(cacheable=true)
    public static List<Item> getProductsByCustomer(String customerId)
    {
        List<Product_Item__c> productNames = [SELECT Id,CreatedDate,Name,CNX_Product__r.Name,CNX_Product__c
                                              FROM Product_Item__c 
                                              WHERE Customer__c = :customerId ORDER BY CreatedDate DESC];
        List<Item> pItems = new List<Item>();
        Item finalTreeItem ;
        List<Item> finalTreeItems = new List<Item>();
        for(Product_Item__c p : productNames)
        {
        	Item i = new Item('Product : ' + p.CNX_Product__r.Name,
                              String.valueOf(p.CNX_Product__c),
                              false,
                              null);
            pItems.add(i);
        }
        finalTreeItem = new Item('Products','Products',false,pItems);
        finalTreeItems.add(finalTreeItem);
        System.debug(finalTreeItems);
        return finalTreeItems;
    }
    @AuraEnabled(cacheable=true)
    public static List<Item> getComplaints(String customerId)
    { 
        List<Complaint__c> comp = [SELECT Id,Name,Customer__c,Product_Item__r.CNX_Product__r.Name
                                   FROM Complaint__c 
                                   WHERE Customer__c = :customerId];
        System.debug(comp.get(0).Product_Item__r.CNX_Product__r.Name);
     	List<Item> pItems = new List<Item>();
        Item finalTreeItem ;
        List<Item> finalTreeItems = new List<Item>();
        
        for(Complaint__c c : comp)
        {
            Item i = new Item(c.Name + ' - ' + c.Product_Item__r.CNX_Product__r.Name,
                              String.valueOf(c.Id),
                              false,
                              null);
            pItems.add(i);
        }
        finalTreeItem = new Item('Complaints','Complaints',false,pItems);
        finalTreeItems.add(finalTreeItem);
        return finalTreeItems;
    }
    @AuraEnabled(cacheable=true)
    public static Decimal getTotalProductsCount()
    {
     	return [SELECT count() FROM Product_Item__c];
    }
    @AuraEnabled(cacheable=true)
    public static Decimal getTotalBusinessAmount()
    {
        List<Customer__c> custmerAmount = [SELECT Total_Purchase_Amount__c FROM Customer__c];
        Decimal amount = 0;
        for(Customer__c c : custmerAmount)
        {
         	amount += c.Total_Purchase_Amount__c; 
        }
        return amount;
    }    
}