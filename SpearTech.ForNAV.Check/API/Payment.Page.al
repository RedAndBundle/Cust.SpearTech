Page 50100 "PTE Payment Entity"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'payment';
    EntitySetName = 'payments';
    InsertAllowed = false;
    ModifyAllowed = false;
    ODataKeyFields = SystemId;
    PageType = API;
    APIPublisher = 'speartech';
    APIGroup = 'check';
    APIVersion = 'v2.0';
    SourceTable = "PTE Payment Interface";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(VendorNo; Rec."Vendor No.") { ApplicationArea = Basic; }
                field(id; Rec.SystemId) { ApplicationArea = Basic; }
                field(documentNo; Rec."Document No.") { ApplicationArea = Basic; }
                field(paymentMethod; Rec."Payment Method") { ApplicationArea = Basic; }
                field(bankAccount; Rec."Bank Account No.") { ApplicationArea = Basic; }
                field(invoiceNo; Rec."External Document No.") { ApplicationArea = Basic; }
                field(amountUSD; Rec."Amount (USD)") { ApplicationArea = Basic; }
                field(PaymentSpecification; PaymentSpecification) { ApplicationArea = Basic; }
                field(description; Rec.Description) { ApplicationArea = Basic; }
            }
        }
    }

    var
        PaymentSpecification: Text;
}
