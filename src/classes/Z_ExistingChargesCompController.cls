/*   Copyright (c) 2013 Zuora, Inc.
 *
 *   Permission is hereby granted, free of charge, to any person obtaining a copy of 
 *   this software and associated documentation files (the "Software"), to use copy, 
 *   modify, merge, publish the Software and to distribute, and sublicense copies of 
 *   the Software, provided no fee is charged for the Software.  In addition the
 *   rights specified above are conditioned upon the following:
 *
 *   The above copyright notice and this permission notice shall be included in all
 *   copies or substantial portions of the Software.
 *
 *   Zuora, Inc. or any other trademarks of Zuora, Inc.  may not be used to endorse
 *   or promote products derived from this Software without specific prior written
 *   permission from Zuora, Inc.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *   FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
 *   ZUORA, INC. BE LIABLE FOR ANY DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES
 *   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 *   ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  
 *
 *
 *   IN THE EVENT YOU ARE AN EXISTING ZUORA CUSTOMER, USE OF THIS SOFTWARE IS GOVERNED
 *   BY THIS AGREEMENT AND NOT YOUR MASTER SUBSCRIPTION AGREEMENT WITH ZUORA.
 */

public with sharing class Z_ExistingChargesCompController {

    /* The Quote ID, set by the VF page calling the custom component 
        public ID quoteID { set; get; }
    
    /* The page where the component got called (quote page/product selector) 
    public String fromName { set; get; }
    
    /* ZChargeGroup to remove from the quote 
    public String toDeleteGroupID { set; get; }
    
    /* ZChargeGroup ID to edit (quantities only) 
    public String toEditGroupID { set; get; }
    
    /* Current charge group being edited 
    public zqu.zChargeGroup currentChargeGroup { set; get; }
    
    /* Boolean to know if we are editing a group charge or in read-only 
    public Boolean editMode { set; get; }
    
    /* List of existing charges in the quote  
    public List<zqu.zChargeGroup> chargeGroupList {
        get {
            if (chargeGroupList == null) {
                chargeGroupList = zqu.zQuoteUtil.getChargeGroups(this.quoteID);
            }
            return chargeGroupList;
        }
        set;
    }
    
    /**
     * Constructor
     
    public Z_ExistingChargesCompController() {
        editMode = false;
        System.debug('Quote ID ' + quoteID);
    }
    
    
    /**
     * Update total price when quantity is changed
     
    public void quntityChange() {
        List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnQuantityChange(currentChargeGroup.zCharges);
        currentChargeGroup.zCharges = charges;
    }
    
    
    /**
     * On discount change
     
    public void discountchange() {
        List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnDiscountChange(
            currentChargeGroup.zCharges
        );
        currentChargeGroup.zCharges = charges;
    }
    
    
    /**
     * On effective price change
     
    public void effectiveChange() {
        List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnEffectivePriceChange(
            currentChargeGroup.zCharges
        );
        currentChargeGroup.zCharges = charges;
    }
    
    
    /**
     * On total price change
     
    public void totalChange() {
        List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnTotalChange(
            currentChargeGroup.zCharges
        );
        currentChargeGroup.zCharges = charges;
    }


    /**
     * Action to remove a product rate plan from the quote
     
    public PageReference deleteProduct() {
        
        System.debug('Trying to delete ' + toDeleteGroupID);
        
        zqu.zChargeGroup chargeGroupToDelete = null;
        
        for (zqu.zChargeGroup cg : chargeGroupList) {
            if (cg.groupID == toDeleteGroupID) {
                chargeGroupToDelete = cg;
            }
        }
        
        if (null != chargeGroupToDelete) {
            System.debug('Deleting the charge group where ID = ' + toDeleteGroupID);
            zqu.zQuoteUtil.deleteChargeGroup(chargeGroupToDelete);
        }
        
        return new PageReference('/' + quoteId);
    }
    
    
    /**
     * Switch the panel to edit mode with one charge group
     
    public PageReference editProduct() {
        
        editMode = true;
        
        // Loop through all the charge group to find the one we are editing
        for (zqu.zChargeGroup cg : chargeGroupList) {
            if (cg.groupID == toEditGroupID) {
                currentChargeGroup = cg;
            }
        }
        
        return null;
    }
    
    
    /**
     * Save an updated product to the quote
     
    public PageReference saveProduct() {
        
        // Get the updated charge group (from the input in the VF page)
        zqu.ZChargeGroup updatedChargeGroup = zqu.zQuoteUtil.updateChargeGroup(this.currentChargeGroup);
        
        // Then update it in the list (to display the changes back)
        for(Integer i =0 ; i < this.chargeGroupList.size() ; i++){
            
            zqu.zChargeGroup zchargeGrp = this.chargeGroupList.get(i);
            
            if(updatedChargeGroup.groupId == zchargeGrp.groupId){
                this.chargeGroupList.set(i, updatedChargeGroup);
            }
        }
        
        editMode = false;
        
        return new PageReference('/' + quoteId);
    }
    
    
    /**
     * Cancel a product edit action
     
    public PageReference cancelEditing() {
        editMode = false;
        return null;
    }*/

}