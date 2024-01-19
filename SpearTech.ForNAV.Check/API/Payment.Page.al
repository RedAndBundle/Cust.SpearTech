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
                field(vendorNo; Rec."Vendor No.") { ApplicationArea = Basic, Suite; }
                field(id; Rec.SystemId) { ApplicationArea = Basic, Suite; }
                field(documentNo; Rec."Document No.") { ApplicationArea = Basic, Suite; }
                field(externalDocumentNo; Rec."External Document No.") { ApplicationArea = Basic, Suite; }
                field(paymentMethod; Rec."Payment Method") { ApplicationArea = Basic, Suite; }
                field(bankAccount; Rec."Bank Account No.") { ApplicationArea = Basic, Suite; }
                field(bankNo; Rec."Bank No.") { ApplicationArea = Basic, Suite; }
                field(invoiceNo; Rec."Invoice No.") { ApplicationArea = Basic, Suite; }
                field(amountUSD; Rec."Amount (USD)") { ApplicationArea = Basic, Suite; }
                field(paymentSpecificationPDF; paymentSpecificationPDF) { ApplicationArea = Basic, Suite; }
                field(description; Rec.Description) { ApplicationArea = Basic, Suite; }
                field(postingDate; Rec."Posting Date") { ApplicationArea = Basic, Suite; }
                field(client; Rec.Client) { ApplicationArea = Basic, Suite; }
                field(tlnSsn; Rec."TIN SSN") { ApplicationArea = Basic, Suite; }
                field(claimNumber; Rec."Claim Number") { ApplicationArea = Basic, Suite; }
                field(claimantName; Rec."Claimant Name") { ApplicationArea = Basic, Suite; }
                field(lossDate; Rec."Loss Date") { ApplicationArea = Basic, Suite; }
                field(paymentType; Rec."Payment Type") { ApplicationArea = Basic, Suite; }
                field(fromDate; Rec."From Date") { ApplicationArea = Basic, Suite; }
                field(throughDate; Rec."Through Date") { ApplicationArea = Basic, Suite; }
                field(invoiceDate; Rec."Invoice Date") { ApplicationArea = Basic, Suite; }
                field(carrierName1; Rec."Carrier Name 1") { ApplicationArea = Basic, Suite; }
                field(carrierName2; Rec."Carrier Name 2") { ApplicationArea = Basic, Suite; }
                field(comment; Rec.Comment) { ApplicationArea = Basic, Suite; }
                field(department; Rec.Department) { ApplicationArea = Basic, Suite; }
                field(adjusterName; Rec."Adjuster Name") { ApplicationArea = Basic, Suite; }
                field(adjusterPhone; Rec."Adjuster Phone") { ApplicationArea = Basic, Suite; }
                field(eventNumber; Rec."Event Number") { ApplicationArea = Basic, Suite; }
                field(controlNumber; Rec."Control Number") { ApplicationArea = Basic, Suite; }
                field(additionalPayee; Rec."Additional Payee") { ApplicationArea = Basic, Suite; }
                field(additionalPayeeText; Rec."Additional Payee Text") { ApplicationArea = Basic, Suite; }
                field(groupClaimantVendorChecks; Rec."Group Claimant Vendor Checks") { ApplicationArea = Basic, Suite; }
                field(claimantId; Rec."Claimant Id") { ApplicationArea = Basic, Suite; }

                field(result; Result) { ApplicationArea = Basic, Suite; }
            }
        }
    }

    var
        paymentSpecificationPDF, Result : Text;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        Setup: Record "PTE Spear Technology Setup";
        Vendor: Record Vendor;
    begin
        Rec.TestField("Vendor No.");
        Rec.TestField("Document No.");
        Rec.TestField("Posting Date");
        Rec.TestField("Amount (USD)");
        Vendor.Get(Rec."Vendor No.");
        Setup.Get();
        Setup.TestField("Payment Method (Check)");
        Setup.TestField("Payment Method (EFT)");
        Setup.TestField("Payment Method (Void)");
        Setup.TestField("G/L Account No.");
        Result := Rec.ProcessPaymentInterface(paymentSpecificationPDF)
    end;
}
