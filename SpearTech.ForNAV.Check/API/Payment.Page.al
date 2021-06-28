Page 50100 "PTE Payment Entity"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'payment';
    EntitySetName = 'payments';
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
                field(paymentSpecificationPDF; paymentSpecificationPDF) { ApplicationArea = Basic; }
                field(description; Rec.Description) { ApplicationArea = Basic; }
                field(postingDate; Rec."Posting Date") { ApplicationArea = Basic; }
                field(result; Result) { ApplicationArea = Basic; }
            }
        }
    }

    var
        paymentSpecificationPDF, Result : Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Setup: Record "PTE Spear Technology Setup";
    begin
        Rec.TestField("Vendor No.");
        Rec.TestField("Document No.");
        Rec.TestField("Posting Date");
        Rec.TestField("Amount (USD)");
        Setup.Get();
        Setup.TestField("Payment Method (Check)");
        Setup.TestField("Payment Method (EFT)");
        Setup.TestField("Payment Method (Void)");
        Setup.TestField("G/L Account No.");
        Result := Rec.ProcessPaymentInterface(paymentSpecificationPDF)
    end;

    // trigger OnOpenPage()
    // begin
    //     "Posting Date" := WorkDate();
    //     Insert();
    // end;

}
