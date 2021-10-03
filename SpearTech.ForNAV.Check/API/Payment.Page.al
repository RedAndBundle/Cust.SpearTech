Page 80400 "PTE Payment Entity"
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
                field(vendorNo; Rec."Vendor No.") { ApplicationArea = Basic; }
                field(id; Rec.SystemId) { ApplicationArea = Basic; }
                field(documentNo; Rec."Document No.") { ApplicationArea = Basic; }
                field(paymentMethod; Rec."Payment Method") { ApplicationArea = Basic; }
                field(bankAccount; Rec."Bank Account No.") { ApplicationArea = Basic; }
                field(invoiceNo; Rec."External Document No.") { ApplicationArea = Basic; }
                field(amountUSD; Rec."Amount (USD)") { ApplicationArea = Basic; }
                field(paymentSpecificationPDF; paymentSpecificationPDF) { ApplicationArea = Basic; }
                field(description; Rec.Description) { ApplicationArea = Basic; }
                field(postingDate; Rec."Posting Date") { ApplicationArea = Basic; }
                field(client; Rec.Client) { ApplicationArea = Basic; }
                field(tlnSsn; Rec."TIN SSN") { ApplicationArea = Basic; }
                field(claimNumber; Rec."Claim Number") { ApplicationArea = Basic; }
                field(claimantName; Rec."Claimant Name") { ApplicationArea = Basic; }
                field(lossDate; Rec."Loss Date") { ApplicationArea = Basic; }
                field(paymentType; Rec."Payment Type") { ApplicationArea = Basic; }
                field(fromDate; Rec."From Date") { ApplicationArea = Basic; }
                field(throughDate; Rec."Through Date") { ApplicationArea = Basic; }
                field(invoiceDate; Rec."Invoice Date") { ApplicationArea = Basic; }

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
}
